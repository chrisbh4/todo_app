defmodule Todo.Todo_ItemsTest do
  use Todo.DataCase

  alias Todo.Todo_Items

  describe "items" do
    alias Todo.Todo_Items.Item

    import Todo.Todo_ItemsFixtures

    @invalid_attrs %{description: nil, priority_value: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Todo_Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Todo_Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      valid_attrs = %{description: "some description", priority_value: 42}

      assert {:ok, %Item{} = item} = Todo_Items.create_item(valid_attrs)
      assert item.description == "some description"
      assert item.priority_value == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo_Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{description: "some updated description", priority_value: 43}

      assert {:ok, %Item{} = item} = Todo_Items.update_item(item, update_attrs)
      assert item.description == "some updated description"
      assert item.priority_value == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo_Items.update_item(item, @invalid_attrs)
      assert item == Todo_Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Todo_Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Todo_Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Todo_Items.change_item(item)
    end
  end
end
