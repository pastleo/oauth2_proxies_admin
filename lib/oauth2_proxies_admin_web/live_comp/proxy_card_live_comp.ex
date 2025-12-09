defmodule Oauth2ProxiesAdminWeb.ProxyCardLiveComp do
  use Oauth2ProxiesAdminWeb, :live_component

  alias Oauth2ProxiesAdmin.Proxies
  alias Oauth2ProxiesAdmin.Docker

  def update(assigns, socket) do
    socket =
      assign(socket, assigns)
      |> assign(%{
        status: get_container_status(assigns.name),
        emails: list_emails(assigns.name),
        form: to_form(%{"email" => ""}),
      })

    {:ok, socket}
  end

  def handle_event("remove_email", %{"email" => email}, socket) do
    List.delete(socket.assigns.emails, email)
    |> Proxies.set_emails(socket.assigns.name)

    {:noreply, assign(socket, :emails, list_emails(socket.assigns.name))}
  end

  
  def handle_event("add_email", %{"email" => email}, socket) do
    [email | socket.assigns.emails]
    |> Enum.uniq()
    |> Proxies.set_emails(socket.assigns.name)

    {:noreply, assign(socket, :emails, list_emails(socket.assigns.name))}
  end

  def handle_event("restart_proxy_container", _value, socket) do
    case Docker.restart_container(socket.assigns.name) do
      :ok ->
        put_flash(:info, "Proxy container '#{socket.assigns.name}' restarted successfully")
      {:error, reason} ->
        put_flash(:error, "Failed to restart proxy container: #{inspect(reason)}")
    end

    {:noreply, assign(socket, :status, get_container_status(socket.assigns.name))}
  end

  defp get_container_status(container_name) do
    case Docker.get_container_status(container_name) do
      {:ok, status} -> status
      {:error, :not_found} -> "not found"
      {:error, _reason} -> "unavailable"
    end
  end

  defp list_emails(container_name) do
    case Proxies.list_emails(container_name) do
      {:ok, emails} -> emails
      _ -> []
    end
  end

  defp put_flash(type, message) do
    send(self(), {:put_flash, type, message})
  end

  defp status_classes("running"), do: "bg-green-400/20 text-green-50 border border-green-300/30"
  defp status_classes("paused"), do: "bg-yellow-400/20 text-yellow-50 border border-yellow-300/30"
  defp status_classes(status) when status in ["stopped", "exited"], do: "bg-slate-400/20 text-slate-50 border border-slate-300/30"
  defp status_classes(_), do: "bg-red-400/20 text-red-50 border border-red-300/30"
end
