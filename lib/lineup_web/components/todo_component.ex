defmodule LineupWeb.TodoComponent do
  use Phoenix.Component

  attr :group, :any, required: true

  def group(assigns) do
    ~H"""
    <div class="flex border-b-2">
      <div class="m-6">
        <img src="/images/group.svg" />
      </div>
      <div>
        <span class="font-bold text-slate-500"><%= @group.name %></span>
        <p class="font-normal text-slate-400">
          <%= @group.completed_task %> OF <%= @group.total_task %> TASKS COMPLETED
        </p>
      </div>
    </div>
    """
  end

  attr :task, :any, required: true

  def task(assigns) do
    ~H"""
    <div class="border-b-2">
      <div>
        <div :if={@task.status == :completed} class="flex">
          <div class="m-6">
            <img src="/images/completed.svg" />
          </div>
          <div class="font-bold text-slate-500 line-through m-6">
            <%= @task.name %>
          </div>
        </div>
        <div :if={@task.status == :blocked} class="flex">
          <div class="m-6">
            <img src="/images/locked.svg" />
          </div>
          <div class="font-bold text-slate-300 m-6">
            <%= @task.name %>
          </div>
        </div>
        <div :if={@task.status == :ready} class="flex">
          <div class="m-6">
            <button phx-click="complete_task" value={@task.id}>
              <img src="/images/incomplete.svg" />
            </button>
          </div>
          <div class="font-bold text-slate-500 m-6">
            <%= @task.name %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
