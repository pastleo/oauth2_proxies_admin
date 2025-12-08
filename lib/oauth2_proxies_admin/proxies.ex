defmodule Oauth2ProxiesAdmin.Proxies do
  @moduledoc """
  """

  @emails_file_name "emails"

  def priv_proxies_path do
    Application.get_env(:oauth2_proxies_admin, :proxies_path)
  end

  def list_proxies do
    with {:ok, names} <- priv_proxies_path() |> File.ls() do
      Enum.filter(names, fn name ->
        Path.join(priv_proxies_path(), name)
        |> File.dir?()
      end)
      |> then(fn x -> {:ok, x} end)
    end
  end

  def list_emails(container_name) do
    with {:ok, content} <- proxy_email_file_path(container_name) |> File.read() do
      String.trim(content)
      |> String.split("\n")
      |> Enum.filter(&(&1 != ""))
      |> then(fn x -> {:ok, x} end)
    end
  end

  def set_emails(emails, container_name) do
    File.write(
      proxy_email_file_path(container_name),
      Enum.join(emails, "\n")
    )
  end

  defp proxy_email_file_path(container_name) do
    priv_proxies_path()
    |> Path.join(container_name)
    |> Path.join(@emails_file_name)
  end
end
