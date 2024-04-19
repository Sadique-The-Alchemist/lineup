defmodule Lineup.Todos do
  import Ecto.Query
  alias Lineup.Repo
  alias Lineup.Todos.{Group, Task, TaskDependency}
  alias Ecto.Multi

  @doc """
  List all groups
  """
  @spec list_groups() :: list()
  def list_groups() do
    Repo.all(Group)
  end

  @doc """
   Returns the count of tasks under a group
  """
  @spec total_tasks(integer()) :: integer()
  def total_tasks(group_id) do
    list_task_query(group_id) |> Repo.aggregate(:count)
  end

  @doc """
  Returns the count of completed task under a group
  """
  @spec task_completed(integer()) :: integer()
  def task_completed(group_id) do
    list_task_query(group_id)
    |> where([t], t.status == :completed)
    |> Repo.aggregate(:count)
  end

  @doc """
  List task under a group
  """
  @spec list_tasks(integer()) :: list()
  def list_tasks(group_id) do
    list_task_query(group_id) |> Repo.all()
  end

  defp list_task_query(group_id) do
    Task
    |> where([t], t.group_id == ^group_id)
  end

  @doc """
  Insert a group in database
  ### Params
  * `params` - map contains attributes to create group
      `name` - group name
      `description` - group description
  """
  @spec create_group(map()) :: {:ok, %Group{}} | {:error, Ecto.Changeset.t()}
  def create_group(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Inserts a task in database
  ### Params
  * params - map contains attributes to create task
    `name` - Task name
    `description` - Task description
    `group_id` - Belonged group id
    `depended_task_ids`  - List of task ids that blocks this task to start
  """
  @spec create_task(map()) :: {:ok, map()} | Multi.failure()
  def create_task(params) do
    create_task_multi =
      Multi.new()
      |> Multi.insert(:task, Task.changeset(%Task{}, params))

    {depended_task_ids, _params} = Map.pop(params, "depended_task_ids", [])

    Enum.reduce(depended_task_ids, create_task_multi, fn depended_task_id, multi ->
      if not_completed?(depended_task_id) do
        Multi.insert(multi, {:depended_task, depended_task_id}, fn %{task: task} ->
          TaskDependency.changeset(%TaskDependency{}, %{
            "depended_task_id" => depended_task_id,
            "task_id" => task.id
          })
        end)
      else
        multi
      end
    end)
    |> Multi.update(:add_count_to_group, fn %{task: task} ->
      total_tasks = total_tasks(task.group_id)
      group = get_group(task.group_id)
      Group.create_task_changeset(group, %{"total_task" => total_tasks})
    end)
    |> Repo.transaction()
  end

  defp not_completed?(depended_task_id) do
    status =
      depended_task_id
      |> get_task()
      |> Map.get(:status, :completed)

    status in [:ready, :blocked]
  end

  def get_task(task_id), do: Repo.get(Task, task_id)

  @doc """
  completes the given task and updates the status of tasks that has dependency with this task
  """
  @spec complete_task(integer()) :: {:ok, map()} | Multi.failure()
  def complete_task(id) do
    Task
    |> Repo.get(id)
    |> complete()
  end

  @spec get_group(integer()) :: %Group{}
  def get_group(group_id), do: Repo.get(Group, group_id)

  defp complete(%Task{} = task) do
    task.id
    |> list_task_dependency()
    |> Enum.reduce(Multi.new(), fn %{task_id: task_id} = task_dependency, multi ->
      delete_multi =
        Multi.delete(multi, {:delete_task_dependecy, task_dependency.id}, task_dependency)

      if blocked_task_free?(task_id) do
        task_to_unblock = get_task(task_id)

        Multi.update(
          delete_multi,
          {:unblocked_task, task_id},
          Task.status_changeset(task_to_unblock, %{"status" => "ready"})
        )
      else
        delete_multi
      end
    end)
    |> Multi.update(:complete_task, Task.status_changeset(task, %{"status" => "completed"}))
    |> Multi.update(:update_completed_task_count, fn %{complete_task: task} ->
      completed_task_count = task_completed(task.group_id)
      group = get_group(task.group_id)
      Group.complete_task_changeset(group, %{"completed_task" => completed_task_count})
    end)
    |> Repo.transaction()
  end

  defp complete(_), do: nil

  defp blocked_task_free?(task_id) do
    from(td in TaskDependency, where: td.task_id == ^task_id) |> Repo.aggregate(:count) == 1
  end

  defp list_task_dependency(task_id) do
    from(td in TaskDependency, where: td.depended_task_id == ^task_id) |> Repo.all()
  end
end
