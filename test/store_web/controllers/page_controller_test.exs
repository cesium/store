defmodule StoreWeb.PageControllerTest do
  use StoreWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Buy Now"
  end
end
