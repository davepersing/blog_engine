defmodule BlogEngine.LayoutView do
  use BlogEngine.Web, :view

  def current_user(conn) do
      Plug.Conn.get_session(conn, :current_user)
  end
end
