defmodule Oauth2ProxiesAdminWeb.ErrorJSONTest do
  use Oauth2ProxiesAdminWeb.ConnCase, async: true

  test "renders 404" do
    assert Oauth2ProxiesAdminWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Oauth2ProxiesAdminWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
