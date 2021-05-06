defmodule WebHn.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories, [primary_key: false]) do
      add :id, :integer, promary_key: true
      add :by, :string
      add :descendants, :integer
      add :post_id, :integer, primary_key: false
      add :score, :integer
      add :time, :utc_datetime
      add :title, :string
      add :url, :string

      timestamps()
    end
    create unique_index(:stories, [:id])
  end
end
