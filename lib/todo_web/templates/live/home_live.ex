defmodule TodoWeb.HomeLive do
  use Phoenix.LiveView

  import Todo.Todo_Items
  alias Todo.Item

  def mount(_params, _url, socket) do
    changeset = Todo.Item.changeset(%Item{})
    socket = assign(socket, name: "Home Page", changeset: changeset)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1> <%= @name %></h1>

    <.form
      for={@changeset}
      phx-change="validate"
      >

    </.form>
    """
  end
end
