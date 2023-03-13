defmodule Todo.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
