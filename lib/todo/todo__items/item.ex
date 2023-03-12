defmodule Todo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :description, :string
    field :priority_value, :integer
    field :sub_tasks, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs \\ %{}) do
    item
    |> cast(attrs, [:description, :priority_value, :sub_tasks])
    |> validate_required([:description, :priority_value, :sub_tasks])
  end
end
