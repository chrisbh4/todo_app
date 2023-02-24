defmodule TodoWeb.EditLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  def mount( params, _url , socket) do
    IO.inspect(params)
    {:ok , socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        <h1>Edit Item </h1>

        <div  class='mb-5'>
            <.form let={f} for={@changeset} phx-submit="update_item" class='flex justify-around w-1/2'>

              <%= textarea f, :description , placeholder: "Todo description" %>
              <%= number_input f, :prority_value , placeholder: "Prority Rank" %>

              <%= submit "Submit" %>
            </.form>
          </div>
      </div>
    """
  end
end
