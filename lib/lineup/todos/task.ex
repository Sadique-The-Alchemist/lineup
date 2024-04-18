defmodule Lineup.Todos.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @required_keys [:name, :status, :group_id]
  @optional_keys [:description, :depended_task_id]

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: [:ready, :blocked, :completed]
    belongs_to(:group, Lineup.Todos.Group)
    belongs_to(:depended_task, __MODULE__)
    timestamps()
  end

  def changeset(task, params \\ %{}) do
    task
    |> cast(params, @required_keys ++ @optional_keys)
    |> change_status(params)
    |> validate_required(@required_keys)
  end

  def status_changeset(task, params \\ %{})

  def status_changeset(%__MODULE__{status: :blocked} = task, %{"status" => "completed"} = params) do
    task
    |> cast(params, [:status])
    |> add_error(:status, "Blocked task can't be completed")
  end

  def status_changeset(task, params) do
    task
    |> cast(params, [:status])
    |> validate_required([:status])
  end

  defp change_status(changeset, %{"depended_task_id" => depended_task_id})
       when is_integer(depended_task_id) do
    changeset
    |> put_change(:status, :blocked)
  end

  defp change_status(changeset, _params), do: changeset
end
