defmodule Lineup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LineupWeb.Telemetry,
      Lineup.Repo,
      {DNSCluster, query: Application.get_env(:lineup, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Lineup.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Lineup.Finch},
      # Start a worker by calling: Lineup.Worker.start_link(arg)
      # {Lineup.Worker, arg},
      # Start to serve requests, typically the last entry
      LineupWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lineup.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LineupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
