defmodule LineupWeb.GroupLive do
  use LineupWeb, :live_view
  alias Lineup.Todos
  import LineupWeb.CoreComponents, only: [table: 1]

  def render(assigns) do
    ~H"""
    <div class="mt-10">
      <.table id="groups" rows={@groups}>
        <:col :let={group} label="Groups">
          <.link patch={~p"/#{group.id}/#{group.name}"}><%= group.name %></.link>
        </:col>
      </.table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    groups = Todos.list_groups()
    socket = assign(socket, :groups, groups)
    {:ok, socket}
  end
end
