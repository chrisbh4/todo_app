
defmodule TodoWeb.CommentLive do
alias Todo.Comment

  use Phoenix.LiveView
  use Phoenix.HTML
  use Phoenix.Component

  import Todo.Comment
  alias Todo.Comments

  alias TodoWeb.Router.Helpers, as: Routes

  def mount(_url, _params, socket ) do
    changeset = Comment.changeset(%Comment{})

    list_comments = Comments.list_comments

    socket= assign(socket, list_comments: list_comments,  changeset: changeset)
    {:ok , socket}
  end


  def handle_event("form_change", %{"comment" => _comment} , socket) do
    {:noreply, socket}
  end

  def handle_event("submit", %{"comment" => comment} , socket ) do

    value = comment["comment"]
    {:ok , new_comment} = Comments.create_comment(%{text: value})

    IO.inspect(new_comment)
    changeset = Comment.changeset(%Comment{})

    socket = assign(socket, list_comments: socket.assigns.list_comments ++ [new_comment], changeset: changeset)

    {:noreply, socket }
  end


  def handle_event("delete_comment", %{"value" => id}, socket) do

    Comments.delete_comment(%Comment{id: String.to_integer(id)})
    list_comments = Comments.list_comments

    {:noreply, assign(socket, list_comments: list_comments)}
  end




  def render(assigns) do
    ~H"""
    <div>
      <h1> Comments </h1>

      <.form let={f} for={@changeset} phx-change="form_change" phx-submit="submit">

      <%= text_input f, :comment, placeholder: "Comments Here"  %>

      <%= submit "Submit", class: "btn bg-gray-200 p-3" %>

      </.form>

      <div >
        <%= for c <- @list_comments do %>

        <div class=' flex justify-around'>
          <h1> <%= c.text %> </h1>
          <button class="inline-flex justify-center rounded-md bg-indigo-600 py-2 px-3   text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500">
                <%= live_redirect "Edit Me",
                  to: Routes.live_path(@socket, TodoWeb.EditCommentLive , id: c.id) %>
          </button>

          <button value={"#{c.id}"} phx-click="delete_comment" > Delete </button>
        </div>
        <% end %>
      </div>
    </div>
    """
  end

end
