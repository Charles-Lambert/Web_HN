defmodule WebHn.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :parent_story, references(:stories, on_delete: :nothing)
      add :parent, references(:comments, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:parent_story])
    create index(:comments, [:parent])
  end
end
