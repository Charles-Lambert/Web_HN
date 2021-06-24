defmodule WebHnWeb.UserController do
  use WebHnWeb, :controller
  alias WebHn.Accounts
  alias WebHn.Accounts.User
  #plug :authenticate_user when action in [:index, :show]
  
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = WebHn.Accounts.change_registration(%WebHn.Accounts.User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do 
      {:ok, user} ->
        conn
        |> WebHnWeb.Auth.login(user)
        |> put_flash(:info, "#{user.username} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  #defp authenticate(conn, _opts) do
    #if conn.assigns.current_user do
      #conn
    #else
      #conn
      #|> put_flash(:error, "You must be logged in to access that page")
      #|> redirect(to: Routes.page_path(conn, :index))
      #|> halt()
    #end
  #end
end
