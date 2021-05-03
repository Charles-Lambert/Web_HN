defmodule WebHn.Posts.Story do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field :by, :string
    field :descendants, :integer
    field :post_id, :integer
    field :score, :integer
    field :time, :utc_datetime
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:by, :descendants, :post_id, :score, :time, :title, :url])
    |> validate_required([:by, :descendants, :post_id, :score, :time, :title])
    |> unsafe_validate_unique([:post_id], Story)
    |> unique_constraint([:post_id, :id])
  end
end
