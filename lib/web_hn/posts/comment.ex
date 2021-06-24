defmodule WebHn.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias WebHn.Posts.{Comment, Story}
  alias WebHn.Accounts.User

  schema "comments" do
    field :body, :string
    belongs_to :comment, Comment, foreign_key: :parent
    belongs_to :story, Story, foreign_key: :parent_story
    belongs_to :user, User, foreign_key: :author
    has_many :comments, Comment, foreign_key: :parent

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :parent_story, :parent])
    |> validate_required([:body])
  end
end
