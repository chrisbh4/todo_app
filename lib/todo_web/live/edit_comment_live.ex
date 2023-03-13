defmodule TodoWeb.EditCommentLive do

  use Phoenix.LiveView
  use Phoenix.HTML
  use Phoenix.Component

  alias Todo.Comment
  alias Todo.Comments

  alias TodoWeb.Router.Helpers, as: Routes

  def mount(%{"id" => id}, _url, socket ) do
    changeset = Comment.changeset(%Comment{})
    comment = Comments.get_comment!(id)


    socket= assign(socket, selected_item: comment,  changeset: changeset)
    {:ok , socket}
  end


  def handle_event("update_comment", %{"comment" => %{"comment" => comment}} , socket ) do
    IO.inspect(comment)

    {:ok, updated_comment} = Comments.update_comment(socket.assigns.selected_item, %{"text" => comment})

    socket = assign(socket, selected_item: updated_comment)


    {:noreply , socket}
  end


  def render(assigns) do

    ~H"""
    <div class="mt-5 md:col-span-2 md:mt-0">
    <button class="inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3   text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500">
                <%= live_redirect "Comments",
                  to: Routes.live_path(@socket, TodoWeb.CommentLive) %>
          </button>
         <.form let={f} for={@changeset}  phx-submit="update_comment"  >
            <div class="overflow-hidden shadow sm:rounded-md">
              <div class="bg-white px-4 py-5 sm:p-6">
                <div class="grid grid-cols-6 gap-6">
                  <div class="col-span-6">
                  </div>

                    <div class="col-span-6 sm:col-span-6 lg:col-span-2">
                      <label for="comment" class="block text-sm font-medium leading-6 text-gray-900">Comment</label>
                      <%= text_input f, :comment , placeholder: "Edit Comment", value: @selected_item.text, class: "mt-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6" %>
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
