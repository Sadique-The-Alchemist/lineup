defmodule LineupWeb.TaskLive do
  use LineupWeb, :live_view

  alias Lineup.Todos

  def mount(%{"id" => group_id, "name" => group_name}, _session, socket) do
    tasks = Todos.list_tasks(group_id)

    socket =
      socket
      |> assign(:tasks, tasks)
      |> assign(:group_id, group_id)
      |> assign(:group_name, group_name)

    {:ok, socket}
  end

  def handle_event("complete_task", %{"value" => task_id}, socket) do
    socket =
      case Todos.complete_task(task_id) do
        {:ok, _rsponse} ->
          socket

        {:error, _failed_step, failed_chageset, _changes} ->
          socket
          |> put_flash(
            :error,
            "Not able to complete the task, Reason: #{inspect(failed_chageset.errors)}"
          )
      end

    {:noreply, socket |> assign(:tasks, Todos.list_tasks(socket.assigns.group_id))}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-10">
      <label><%= @group_name %></label>
      <.table id="tasks" rows={@tasks}>
        <:col :let={task} label="Name"><%= task.name %></:col>
        <:col :let={task} label="Status"><%= task.status %></:col>
        <:col :let={task} label="Complete">
          <input
            type="checkbox"
            id={"task-#{task.id}"}
            name={task.name}
            value={task.id}
            checked={task.status == :completed}
            class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
            phx-click="complete_task"
          />
        </:col>
      </.table>
    </div>
    """
  end
end
