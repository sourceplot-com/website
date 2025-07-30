defmodule Sourceplot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SourceplotWeb.Telemetry,
      Sourceplot.Repo,
      {DNSCluster, query: Application.get_env(:sourceplot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sourceplot.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sourceplot.Finch},
      # Start a worker by calling: Sourceplot.Worker.start_link(arg)
      # {Sourceplot.Worker, arg},
      # Start to serve requests, typically the last entry
      SourceplotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sourceplot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SourceplotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
