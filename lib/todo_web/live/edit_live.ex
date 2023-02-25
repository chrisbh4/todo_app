defmodule TodoWeb.EditLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias Todo.Item

  alias TodoWeb.Router.Helpers, as: Routes

  def mount( params, _url , socket) do
    changeset = Todo.Item.changeset(%Item{})
    IO.inspect(params)
    socket = assign(socket, changeset: changeset)
    {:ok , socket}
  end

  def handle_params( _params, _url, socket) do

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= live_redirect "Return Home", class: "text-xl underline",
              to: Routes.live_path(@socket, TodoWeb.HomeLive) %>

        <div  class='mb-5'>
            <.form let={f} for={@changeset} phx-submit="update_item" class='flex justify-around w-1/2'>

              <%= textarea f, :description , placeholder: "Todo description" %>
              <%= number_input f, :prority_value , placeholder: "Prority Rank" %>

              <%= submit "Submit" %>
            </.form>
          </div>
      </div>
    """
  end
end
