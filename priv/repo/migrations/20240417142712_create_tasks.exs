defmodule Lineup.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :description, :string
      add :status, :string
      add :group_id, references(:groups, on_delete: :nothing)
      add :depended_task_id, references(:tasks, on_delete: :nothing)
      timestamps()
    end
  end
end
