ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(WebHn.Repo, :manual)

Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)

Application.put_env(:web_hn, :http_client, HTTPoison.BaseMock)
