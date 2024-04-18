defmodule Lineup.TodosTest do
  alias Lineup.Todos
  import Lineup.Factory

  use Lineup.DataCase

  describe "create_group/1" do
    test "create group by its name" do
      group_name = "Group #{System.unique_integer()}"
      assert {:ok, group} = Todos.create_group(%{"name" => group_name})
      assert group.name == group_name
    end

    test "cannot create group by invalid params" do
      assert {:error, changeset} = Todos.create_group(%{})
      assert [name: {"can't be blank", [validation: :required]}] == changeset.errors
    end
  end

  describe "create_task/1" do
    test "creates the task by valid params" do
      name = "Task #{System.unique_integer()}"
      group = insert!(:group)

      assert {:ok, task} =
               Todos.create_task(%{"name" => name, "group_id" => group.id, "status" => "ready"})

      assert task.name == name
      assert task.group_id == group.id
    end

    test "can not create with invalid params" do
      name = "Task #{System.unique_integer()}"
      assert {:error, changeset} = Todos.create_task(%{"name" => name, "status" => "blocked"})
      assert [group_id: {"can't be blank", [validation: :required]}] == changeset.errors
    end

    test "task with depended tasks creates with status blocked" do
      group = insert!(:group)
      depended_task = insert!(:task, group_id: group.id)
      name = "Task #{System.unique_integer()}"

      assert {:ok, task} =
               Todos.create_task(%{
                 "name" => name,
                 "group_id" => group.id,
                 "depended_task_id" => depended_task.id
               })

      assert task.status == :blocked
    end
  end

  describe "complete_task/1" do
    test "complete status updates the status to completed" do
      task = insert!(:task, status: :ready)
      assert {:ok, %{complete_task: completed_task}} = Todos.complete_task(task.id)
      assert completed_task.status == :completed
    end

    test "blocked tasks will not able to complete" do
      task = insert!(:task, status: :blocked)

      assert {:error, :complete_task, failed_changeset, _changes_so_far} =
               Todos.complete_task(task.id)

      assert [status: {"Blocked task can't be completed", []}] == failed_changeset.errors
    end

    test "completing task unblocks the tasks that depended by this task" do
      depeneded_task = insert!(:task, status: :ready)
      task = insert!(:task, depended_task_id: depeneded_task.id, status: :blocked)

      assert {:ok, %{:complete_task => completed_task} = responce} =
               Todos.complete_task(depeneded_task.id)

      unblocked_task = Map.fetch!(responce, {:unblocked_task, task.id})

      assert completed_task.status == :completed
      assert unblocked_task.status == :ready
    end
  end
end
