defmodule Oauth2ProxiesAdmin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Oauth2ProxiesAdminWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:oauth2_proxies_admin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Oauth2ProxiesAdmin.PubSub},
      # Start a worker by calling: Oauth2ProxiesAdmin.Worker.start_link(arg)
      # {Oauth2ProxiesAdmin.Worker, arg},
      # Start to serve requests, typically the last entry
      Oauth2ProxiesAdminWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Oauth2ProxiesAdmin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Oauth2ProxiesAdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
