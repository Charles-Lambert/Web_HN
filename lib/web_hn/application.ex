defmodule WebHn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      WebHn.Repo,
      # Start the Telemetry supervisor
      WebHnWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WebHn.PubSub},
      # Start the Endpoint (http/https)
      WebHnWeb.Endpoint,

      WebHn.Update.Supervisor
      # Start a worker by calling: WebHn.Worker.start_link(arg)
      # {WebHn.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebHn.Supervisor]
    Supervisor.start_link(children, opts)
  end

    def application do
    [
      env: [interval: 5000,
        list_url: "https://hacker-news.firebaseio.com/v0/newstories.json",
        story_url: "https://hacker-news.firebaseio.com/v0/item/",
      ],
      mod: {Hackernews.Supervisor, []},
      extra_applications: [:logger]
    ]
  end


  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WebHnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
