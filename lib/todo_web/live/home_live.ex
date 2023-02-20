defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView

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
      <.form
        for={@changeset}
        phx-change="validate"
        phx-submit="submit"
        >

      <button type="submit">Submit </button>
      </.form>
    </div>
    """
  end


  def handle_event("submit", %{"values" => values}, socket) do
    new_item = Todo.TodoItems.create_item(values)

    socket = assign(socket, new_item: new_item)

    {:noreply , socket}
  end


end
