defmodule Oauth2ProxiesAdminWeb.ProxiesLive do
  use Oauth2ProxiesAdminWeb, :live_view

  alias Oauth2ProxiesAdmin.Proxies

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{
      proxies: list_proxies(),
    })}
  end

  defp list_proxies do
    case Proxies.list_proxies() do
      {:ok, proxies} -> proxies
      _ -> []
    end
  end

end
