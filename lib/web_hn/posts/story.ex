defmodule WebHn.Posts.Story do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebHn.Posts.{Comment, Story}

  @primary_key {:id, :integer, autogenerate: false}
  schema "stories" do
    field :by, :string
    field :descendants, :integer
    field :post_id, :integer, primary_key: false
    field :score, :integer
    field :time, :utc_datetime
    field :title, :string
    field :url, :string
    has_many :comments, Comment, foreign_key: :parent_story

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:by, :descendants, :id, :score, :time, :title, :url])
    |> validate_required([:by, :descendants, :id, :score, :time, :title])
    |> unique_constraint(:id)
  end
end
