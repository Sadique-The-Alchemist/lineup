defmodule LineupWeb.TaskLive do
  use LineupWeb, :live_view
  import LineupWeb.TodoComponent
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
      <div class="flex relative">
        <h1 class="text-2xl text-slate-500"><%= @group_name %></h1>
        <div class="text-blue-500 absolute right-0"><a href="/">ALL GROUPS</a></div>
      </div>
      <div class="mt-10 border-t-2">
        <div :for={task <- @tasks}>
          <.task task={task} />
        </div>
      </div>
    </div>
    """
  end
end
