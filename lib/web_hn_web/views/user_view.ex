defmodule WebHnWeb.UserView do
  use WebHnWeb, :view
  alias WebHn.Accounts

  def first_name(%Accounts.User{username: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
