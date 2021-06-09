defmodule WebHn.Repo.Migrations.CommentsAddAuthor do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :author, references(:users, on_delete: :nothing)
    end
  end
end
