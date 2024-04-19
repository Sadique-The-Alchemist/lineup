defmodule Lineup.Todos.TaskDependency do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lineup.Todos.Task

  @required_keys [:depended_task_id, :task_id]

  schema "task_dependencies" do
    belongs_to(:depended_task, Task)
    belongs_to(:task, Task)
  end

  def changeset(task_dependency, params \\ %{}) do
    task_dependency
    |> cast(params, @required_keys)
    |> validate_required(@required_keys)
    |> unique_constraint(:depended_task_unique_index, message: "The task has already marked")
  end
end
