defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import Todo.TodoItems
  alias Todo.TodoItems
  alias Todo.Item

  def mount(_params, _url, socket) do
    changeset = Todo.Item.changeset(%Item{})
    all_items = TodoItems.list_items()

    socket = assign(socket, name: "Home Page", changeset: changeset, all_items: all_items)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1 class='text-2xl text-red-400'>
      <%= @name %>
    </h1>

    <div>
      <.form let={f} for={@changeset} phx-change="form_change" phx-submit="submit">

        <%= textarea f, :description , placeholder: "Todo description" %>
        <%= number_input f, :prority_value , placeholder: "Prority Rank" %>

        <%= submit "Submit" %>
      </.form>
    </div>

    <section>
        <%= for item <- @all_items do  %>
      <div class='flex' id={"item-#{item.id}"}>
        <h3 class="mx-4">
          <%= item.description %>
        </h3>
        <h3>
          <%= item.priority_value %>
        </h3>

        <button
          phx-click="edit_item"
          class='ml-4 px-4 bg-gray-300'>
          Edit
        </button>
      </div>
        <% end %>

    </section>


    """
  end

  # def handle_event("form_change", %{"item" => %{"description" => values}}, socket) do
  def handle_event("form_change", %{"item" => values}, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", %{"item" => %{"description" => description, "prority_value" => priority}}, socket) do
    new_item = Todo.TodoItems.create_item(%{description: description, priority_value: priority})
    changeset = Todo.Item.changeset(%Item{})

    socket = assign(socket, all_items: socket.assigns.all_items ++ new_item, changeset: changeset)

    {:noreply, socket}
  end
end
