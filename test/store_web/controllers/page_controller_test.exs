defmodule StoreWeb.PageControllerTest do
  use StoreWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    IO.inspect(html_response(conn, 200))
    assert html_response(conn, 200) =~ "Welcome to Phoenix"
  end
end
