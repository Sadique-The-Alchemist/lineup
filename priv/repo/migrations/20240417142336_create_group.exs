defmodule Lineup.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false
      add :description, :string
      add :total_task, :integer, default: 0
      add :completed_task, :integer, default: 0
      timestamps()
    end
  end
end
