defmodule WebHn.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password_hash, :string
    field :pasword, :string, virtual: true
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :pasword, :password_hash])
    |> validate_required([:username, :pasword, :password_hash])
    |> unique_constraint(:username)
  end
end
