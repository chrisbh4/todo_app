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

        <div class='mb-5'></div>

        <div class="mt-5 md:col-span-2 md:mt-0">
         <.form let={f} for={@changeset} phx-change="form_change" phx-submit="submit"  >
            <div class="overflow-hidden shadow sm:rounded-md">
              <div class="bg-white px-4 py-5 sm:p-6">
                <div class="grid grid-cols-6 gap-6">
                  <div class="col-span-6">
                  </div>

                    <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                      <label for="description" class="block text-sm font-medium leading-6 text-gray-900">Description</label>
                      <%= text_input f, :description , placeholder: "Todo description", class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
                    </div>

                    <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                      <label for="region" class="block text-sm font-medium leading-6 text-gray-900">Priority Level</label>
                      <%=  number_input f, :priority_value , placeholder: "Prority Level", class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
                    </div>

                    <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                      <button type="submit" class="inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3 mt-[30px] text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500">Save</button>
                    </div>
                  </div>
                </div>
                <div class="bg-gray-50 px-4 py-3 text-right sm:px-6">
                </div>
              </div>
          </.form>
        </div>

        <section class='mt-10'>
          <%= for item <- @all_items do  %>
            <div class='flex justify-around w-1/2' id={"item-#{item.id}"}>
                <h3 class="mx-4">
                  <%= item.description %>
                </h3>
                <h3>
                  <%= item.priority_value %>
                </h3>

                <button class="inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3   text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500">
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

  def handle_event(
        "submit",
        %{"item" => %{"description" => description, "priority_value" => priority}},
        socket
      ) do
    {:ok, new_item} =
      Todo.TodoItems.create_item(%{description: description, priority_value: priority})

    changeset = Todo.Item.changeset(%Item{})

    socket =
      assign(socket, all_items: socket.assigns.all_items ++ [new_item], changeset: changeset)

    {:noreply, socket}
  end

  def handle_event("delete_item", %{"value" => value}, socket) do
    id = String.to_integer(value)

    Todo.TodoItems.delete_item(%Item{id: id})

    socket = assign(socket, all_items: TodoItems.list_items())
    {:noreply, socket}
  end
end
