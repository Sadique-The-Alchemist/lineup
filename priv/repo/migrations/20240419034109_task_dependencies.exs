defmodule Lineup.Repo.Migrations.TaskDependencies do
  use Ecto.Migration

  def change do
    create table(:task_dependencies) do
      add :depended_task_id, references(:tasks, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)
    end

    create unique_index(:task_dependencies, [:depended_task_id, :task_id],
             name: :depended_task_unique_index
           )
  end
end
