defmodule Oauth2ProxiesAdminWeb.PageController do
  use Oauth2ProxiesAdminWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
