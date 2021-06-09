defmodule WebHn.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :comment, Comment, foreign_key: :parent
    belongs_to :story, Story, foreign_key: :parent_story
    belongs_to :author, User
    has_many :comments, Comment, foreign_key: :parent

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
