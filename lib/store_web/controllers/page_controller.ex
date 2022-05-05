defmodule StoreWeb.PageController do
  use StoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
