defmodule Lineup.Todos.Group do
  import Ecto.Changeset
  use Ecto.Schema

  schema "groups" do
    field(:name, :string)
    field(:description, :string)
    field(:total_task, :integer)
    field(:completed_task, :integer)
    timestamps()
  end

  def changeset(group, params \\ %{}) do
    group
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end

  def create_task_changeset(group, params \\ %{}) do
    group
    |> cast(params, [:total_task])
    |> validate_required([:total_task])
  end

  def complete_task_changeset(group, params \\ %{}) do
    group
    |> cast(params, [:completed_task])
    |> validate_required([:completed_task])
  end
end
