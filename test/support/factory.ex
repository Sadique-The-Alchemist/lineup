defmodule Lineup.Factory do
  alias Lineup.Repo
  alias Lineup.Todos.{Group, Task, TaskDependency}

  def build(:group) do
    %Group{
      name: "Group #{System.unique_integer()}"
    }
  end

  def build(:task) do
    %Task{name: "Task #{System.unique_integer()}", status: :ready, group: build(:group)}
  end

  def build(:task_dependecy) do
    %TaskDependency{}
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
