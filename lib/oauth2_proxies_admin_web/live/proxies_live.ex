defmodule Oauth2ProxiesAdminWeb.ProxiesLive do
  use Oauth2ProxiesAdminWeb, :live_view

  alias Oauth2ProxiesAdmin.Proxies

  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{
      proxies: list_proxies(),
    })}
  end

  def handle_info({:put_flash, type, message}, socket) do
    {:noreply, put_flash(socket, type, message)}
  end

  defp list_proxies do
    case Proxies.list_proxies() do
      {:ok, proxies} -> proxies
      _ -> []
    end
  end

end
