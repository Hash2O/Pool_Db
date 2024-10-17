defmodule PoolDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PoolDbWeb.Telemetry,
      PoolDb.Repo,
      {DNSCluster, query: Application.get_env(:pool_db, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PoolDb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PoolDb.Finch},
      # Start a worker by calling: PoolDb.Worker.start_link(arg)
      # {PoolDb.Worker, arg},
      # Start to serve requests, typically the last entry
      PoolDbWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoolDb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PoolDbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
