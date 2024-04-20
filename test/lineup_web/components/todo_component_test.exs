defmodule LineupWeb.TodoComponentTest do
  use Lineup.DataCase
  alias LineupWeb.TodoComponent
  import Phoenix.LiveViewTest
  import Lineup.Factory

  describe "task" do
    test "renders text style and image based on the status" do
      task = insert!(:task, status: :blocked)
      render_component(&TodoComponent.task/1, task: task) =~ "<div class=\"m-6\">\n
             <img src=\"/images/locked.svg\">\n
              </div>\n
               <div class=\"font-bold text-slate-300 m-6\">\n
                      #{task.name}\n
                </div>"
    end
  end
end
