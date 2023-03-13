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
    IO.inspect(values)

    {:ok, updated_item} = TodoItems.update_item(socket.assigns.selected_item ,values)

    updated_list = TodoItems.list_items()

    IO.inspect(updated_item)
    socket = assign(socket , all_items: updated_list, selected_item: updated_item)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div class='mt-10 ml-5' >
      <h1 class='text-xl ml-[5px]'> Edit Form </h1>

      <button class='inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3 mt-[15px] text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500'>
        <%= live_redirect "Return Home", class: "text-md  ",
              to: Routes.live_path(@socket, TodoWeb.HomeLive) %>
      </button>
      </div>

      <div class="mt-5 md:col-span-2 md:mt-0">
         <.form let={f} for={@changeset}  phx-submit="update_item"  >
            <div class="overflow-hidden shadow sm:rounded-md">
              <div class="bg-white px-4 py-5 sm:p-6">
                <div class="grid grid-cols-6 gap-6">
                  <div class="col-span-6">
                  </div>

                    <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                      <label for="description" class="block text-sm font-medium leading-6 text-gray-900">Description</label>
                      <%= text_input f, :description , placeholder: "Todo description", value: @selected_item.description, class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
                    </div>

                    <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                      <label for="region" class="block text-sm font-medium leading-6 text-gray-900">Sub Tasks</label>
                      <%=  textarea f, :sub_tasks , placeholder: "Sub Tasks", value: @selected_item.sub_tasks, class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
                    </div>

                    <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                      <label for="region" class="block text-sm font-medium leading-6 text-gray-900">Priority Level</label>
                      <%=  number_input f, :priority_value , placeholder: "Prority Level", value: @selected_item.priority_value, class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
                    </div>

                    <div class="col-span-6 sm:col-span-3 lg:col-span-2">
                      <button type="submit" class="inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3 mt-[30px] text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500">Save</button>
                    </div>
                  </div>
                </div>
              </div>
          </.form>
        </div>
    """
  end
end
