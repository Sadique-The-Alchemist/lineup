defmodule Lineup.Todos do
  import Ecto.Query
  alias Lineup.Repo
  alias Lineup.Todos.Group
  alias Lineup.Todos.Task
  alias Ecto.Multi

  @doc """
  List all groups
  """

  def list_groups() do
    Repo.all(Group)
  end

  def list_tasks(group_id) do
    from(t in Task, where: t.group_id == ^group_id) |> Repo.all()
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
    `depended_task_id`  - optional if any task blocks this task
  """
  @spec create_task(map()) :: {:ok, %Task{}} | {:error, Ecto.Changeset.t()}
  def create_task(params) do
    %Task{}
    |> Task.changeset(params)
    |> Repo.insert()
  end

  @doc """
  completes the given task and updates the status of tasks that has dependency with this task
  """

  def complete_task(id) do
    Task
    |> Repo.get(id)
    |> complete()
  end

  defp complete(%Task{} = task) do
    task.id
    |> list_blocked_tasks()
    |> Enum.reduce(Multi.new(), fn depended_task, multi ->
      Multi.update(
        multi,
        {:unblocked_task, depended_task.id},
        Task.status_changeset(depended_task, %{"status" => "ready"})
      )
    end)
    |> Multi.update(:complete_task, Task.status_changeset(task, %{"status" => "completed"}))
    |> Repo.transaction()
  end

  defp complete(_), do: nil

  defp list_blocked_tasks(task_id) do
    from(t in Task, where: t.depended_task_id == ^task_id) |> Repo.all()
  end
end
