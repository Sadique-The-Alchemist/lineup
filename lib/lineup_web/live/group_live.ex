defmodule LineupWeb.GroupLive do
  use LineupWeb, :live_view
  alias Lineup.Todos
  import LineupWeb.TodoComponent

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl text-slate-500">Things to do</h1>

      <div class="mt-10 border-t-2">
        <div :for={group <- @groups}>
          <a href={"/#{group.id}/#{group.name}"}>
            <.group group={group} />
          </a>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    groups = Todos.list_groups()
    socket = assign(socket, :groups, groups)
    {:ok, socket}
  end
end
