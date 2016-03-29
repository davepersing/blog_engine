defmodule BlogEngine.SessionControllerTest do
    use BlogEngine.ConnCase

    alias BlogEngine.User
    alias BlogEngine.Repo
    alias BlogEngine.TestHelper

    setup do
        {:ok, role} = TestHelper.create_role(%{name: "User", admin: false})
        {:ok, _user} = TestHelper.create_user(role, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
        conn = conn()
        {:ok, conn: conn}
    end

    test "shows the login form", %{conn: conn} do
        conn = get conn, session_path(conn, :new)
        assert html_response(conn, 200) =~ "Login"
    end

    test "creates a new user session for a valid user", %{conn: conn} do
        conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test"}
        assert get_session(conn, :current_user)
        assert get_flash(conn, :info) == "Sign in successful!"
        assert redirected_to(conn) == page_path(conn, :index)
    end

    test "does not create a session if user doesn't exist", %{conn: conn} do
        conn = post conn, session_path(conn, :create), user: %{username: "test", password: "incorrect"}
        assert get_session(conn, :current_user) == nil
        assert get_flash(conn, :error) == "Invalid username/password combination!"
        assert redirected_to(conn) == page_path(conn, :index)
    end

    test "deletes the session", %{conn: conn} do
        user = Repo.get_by(User, %{username: "test"})
        conn = delete conn, session_path(conn, :delete, user)
        refute get_session(conn, :current_user)
        assert get_flash(conn, :info) == "Signed out successfully!"
        assert redirected_to(conn) == page_path(conn, :index)
    end
end
