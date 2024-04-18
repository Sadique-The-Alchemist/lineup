defmodule Lineup.Todos.Group do
  import Ecto.Changeset
  use Ecto.Schema

  schema "groups" do
    field(:name, :string)
    field(:description, :string)
    timestamps()
  end

  def changeset(group, params \\ %{}) do
    group
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
