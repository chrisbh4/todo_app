defmodule Todo.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :description, :string
      add :sub_tasks, :string
      add :priority_value, :integer

      timestamps()
    end
  end
end
