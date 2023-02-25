defmodule TodoWeb.EditLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias Todo.Item

  alias Todo.TodoItems

  alias TodoWeb.Router.Helpers, as: Routes

  def mount( params, _url , socket) do
    changeset = Todo.Item.changeset(%Item{})
    socket = assign(socket, changeset: changeset)
    {:ok , socket}
  end

  def handle_params( params, _url, socket) do
    id = String.to_integer(params["id"])
    selected_item = TodoItems.get_item!(id)

    {:noreply, assign(socket, id: id, selected_item: selected_item)}
  end


  def handle_event("update_item", %{"item" => values} , socket ) do

    updated_item = TodoItems.update_item(socket.assigns.selected_item ,values)

    updated_list = TodoItems.list_items()
    socket = assign(socket , all_items: updated_list, selected_item: updated_item)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class='mt-10 ml-5' >
        <%= live_redirect "Return Home", class: "text-xl underline",
              to: Routes.live_path(@socket, TodoWeb.HomeLive) %>

        <div  class='mb-5'>
            <.form let={f} for={@changeset} phx-submit="update_item" class='flex justify-around w-1/2'>

              <%= textarea f, :description , placeholder: "Todo description", value: @selected_item.description %>
              <%= number_input f, :priority_value , placeholder: "Prority Rank", value: @selected_item.priority_value %>

              <%= submit "Submit" %>
            </.form>
          </div>
      </div>
    """
  end
end
