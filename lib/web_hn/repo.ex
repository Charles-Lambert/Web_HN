defmodule WebHn.Repo do
  use Ecto.Repo,
    otp_app: :web_hn,
    adapter: Ecto.Adapters.Postgres
end
