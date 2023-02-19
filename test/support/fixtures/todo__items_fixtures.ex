defmodule Todo.Todo_ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todo.Todo_Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        description: "some description",
        priority_value: 42
      })
      |> Todo.Todo_Items.create_item()

    item
  end
end
