defmodule WebHn.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :by, :string
      add :descendants, :integer
      add :post_id, :integer
      add :score, :integer
      add :time, :utc_datetime
      add :title, :string
      add :url, :string

      timestamps()
    end

  end
end
