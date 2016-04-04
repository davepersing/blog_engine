defmodule BlogEngine.PageControllerTest do
  use BlogEngine.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Phoenix Tech Blog"
  end
end
