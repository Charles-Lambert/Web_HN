defmodule WebHnWeb.PageController do
  use WebHnWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
