defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  use Phoenix.Component
  # import Todo.TodoItems

  alias Todo.TodoItems
  alias Todo.Item

  alias TodoWeb.Router.Helpers, as: Routes

  def mount(_params, _url, socket) do
    changeset = Todo.Item.changeset(%Item{})
    all_items = TodoItems.list_items()

    socket = assign(socket, page_title: "Home Page", changeset: changeset, all_items: all_items)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class='w-full '>



        <div  class='mb-5'>
          <.form let={f} for={@changeset} phx-change="form_change" phx-submit="submit" class='flex justify-around w-1/2'>

            <%= textarea f, :description , placeholder: "Todo description" %>
            <%= number_input f, :priority_value , placeholder: "Prority Rank" %>

            <%= submit "Submit" %>
          </.form>
        </div>

        <section>
            <%= for item <- @all_items do  %>
          <div class='flex justify-around w-1/2' id={"item-#{item.id}"}>
            <h3 class="mx-4">
              <%= item.description %>
            </h3>
            <h3>
              <%= item.priority_value %>
            </h3>

            <button>
            <%= live_redirect "Edit Me",
              to: Routes.live_path(@socket, TodoWeb.EditLive , id: item.id) %>

            </button>
            <button
              phx-click="delete_item"
              value={"#{item.id}"}
              class='ml-4 px-4 bg-gray-300'>

              Delete
            </button>

          </div>


            <% end %>

        </section>




      </div>
    """
  end

  # def handle_event("form_change", %{"item" => %{"description" => values}}, socket) do
  def handle_event("form_change", %{"item" => _values}, socket) do
    {:noreply, socket}
  end

  def handle_event("edit_item", %{"value" => _values}, socket) do
    {:noreply, push_patch(socket, to: "/edit")}
  end

  def handle_event("submit", %{"item" => %{"description" => description, "priority_value" => priority}}, socket) do
    {:ok, new_item} = Todo.TodoItems.create_item(%{description: description, priority_value: priority})
    changeset = Todo.Item.changeset(%Item{})

    IO.inspect(socket.assigns.all_items)
    IO.inspect(new_item)

    socket = assign(socket, all_items: socket.assigns.all_items ++ [new_item] , changeset: changeset)

    {:noreply, socket}
  end


def handle_event("delete_item", %{"value" => value}, socket) do
  IO.inspect(String.to_integer(value))
  id = String.to_integer(value)

  Todo.TodoItems.delete_item(%Item{id: id})

  socket = assign(socket, all_items: TodoItems.list_items() )
  {:noreply,socket}

end
end
