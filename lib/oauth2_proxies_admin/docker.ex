defmodule Oauth2ProxiesAdmin.Docker do
  @moduledoc """
  Module for interacting with the Docker/Podman daemon via the Unix socket API.

  ## Configuration

  Configure the Docker socket path in your config files:

      # config/local.exs
      config :oauth2_proxies_admin, docker_socket: "/your/path/docker.sock"

  The default socket path is `/var/run/docker.sock`.
  For Podman, use `/run/podman/podman.sock`.
  """

  @default_socket_path "/var/run/docker.sock"
  @api_version "v1.52"

  @doc """
  Get the status of a container by name.

  Returns `{:ok, status}` where status is one of:
  - "running"
  - "stopped"
  - "paused"
  - "exited"
  - "dead"
  - "unknown"

  Returns `{:error, reason}` if the container is not found or the daemon is unreachable.
  """
  def get_container_status(container_name) do
    case inspect_container(container_name) do
      {:ok, %{"State" => %{"Status" => status}}} ->
        {:ok, normalize_status(status)}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Inspect a container by name and return full container information.

  Returns `{:ok, container_info}` or `{:error, reason}`.
  """
  def inspect_container(container_name) do
    url = build_url("/containers/#{container_name}/json")

    case Req.get(url, unix_socket: socket_path()) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: 404}} ->
        {:error, :not_found}

      {:ok, %Req.Response{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, {:connection_error, reason}}
    end
  end

  @doc """
  Restart a container by name.

  Returns `:ok` or `{:error, reason}`.
  """
  def restart_container(container_name) do
    url = build_url("/containers/#{container_name}/restart")

    case Req.post(url, unix_socket: socket_path()) do
      {:ok, %Req.Response{status: status}} when status in [204, 304] ->
        :ok

      {:ok, %Req.Response{status: 404}} ->
        {:error, :not_found}

      {:ok, %Req.Response{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, {:connection_error, reason}}
    end
  end

  # Private functions

  defp build_url(path) do
    "http://#{@api_version}#{path}"
  end

  defp socket_path do
    Application.get_env(:oauth2_proxies_admin, :docker_socket, @default_socket_path)
  end

  defp normalize_status(status) when is_binary(status) do
    status
    |> String.downcase()
    |> case do
      "running" -> "running"
      "stopped" -> "stopped"
      "paused" -> "paused"
      "exited" -> "exited"
      "dead" -> "dead"
      _ -> "unknown"
    end
  end
end
