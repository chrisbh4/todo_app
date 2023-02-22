defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import Todo.TodoItems
  alias Todo.TodoItems
  alias Todo.Item

  def mount(_params, _url, socket) do
    changeset = Todo.Item.changeset(%Item{})
    all_items = TodoItems.list_items()

    IO.inspect(all_items)

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
      <div>
        <%= for item <- @all_items do  %>
        <h3>
          <% item.description %>
        </h3>
        <% end %>
      </div>

    </section>


    """
  end

  # def handle_event("form_change", %{"item" => %{"description" => values}}, socket) do
  def handle_event("form_change", %{"item" => values}, socket) do
    # IO.inspect(values.description)
    {:noreply, socket}
  end

  def handle_event("submit", %{"item" => %{"description" => description, "prority_value" => priority}}, socket) do
    IO.inspect("Form Submitted!")
    new_item = Todo.TodoItems.create_item(%{description: description, priority_value: priority})
    changeset = Todo.Item.changeset(%Item{})

    socket = assign(socket, new_item: new_item, changeset: changeset)

    {:noreply, socket}
  end
end
