defmodule BlogEngine.LayoutViewTest do
  use BlogEngine.ConnCase
  alias BlogEngine.LayoutView
  alias BlogEngine.User

  setup do
    User.changeset(%User{}, %{username: "test", password: "test123", password_confirmation: "test123", email: "test@test.com"})
    |> Repo.insert

    conn = conn()
    {:ok, conn: conn}
  end

  test "current user returns the user in the session", %{conn: conn} do
      conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test123"}
      assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session" do
      user = Repo.get_by(User, %{username: "test"})
      conn = delete conn, session_path(conn, :delete, user)
      refute LayoutView.current_user(conn)
  end
end
