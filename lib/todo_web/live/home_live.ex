defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import Todo.TodoItems
  alias Todo.Item

  def mount(_params, _url, socket) do
    changeset = Todo.Item.changeset(%Item{})

    socket = assign(socket, name: "Home Page", changeset: changeset)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1> <%= @name %></h1>

    <div>
      <.form let={f} for={@changeset} phx-change="form_change" phx-submit="submit">

        <%= text_input f, :name , placeholder: "Name" %>
        <%= textarea f, :description , placeholder: "Todo description" %>

        <%= submit "Submit" %>
      </.form>
    </div>

    
    """
  end


  # def handle_event("form_change", %{"item" => %{"description" => values}}, socket) do
  def handle_event("form_change", %{"item" => values}, socket) do
    # IO.inspect(values)
    {:noreply, socket}
  end


  def handle_event("submit", %{"item" => values}, socket) do
    IO.inspect(values)
    new_item = Todo.TodoItems.create_item(values)
    changeset = Todo.Item.changeset(%Item{})

    socket = assign(socket, new_item: new_item, changeset: changeset)

    {:noreply, socket}
  end
end
