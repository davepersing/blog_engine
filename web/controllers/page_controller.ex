defmodule BlogEngine.PageController do
  use BlogEngine.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
