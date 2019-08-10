defmodule CenatusLtdWeb.SessionController do
  use CenatusLtdWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
    case CenatusLtdWeb.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :admin))

      {:error, _reason, conn} ->
        conn |> put_flash(:error, "Invalid username/password combination") |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CenatusLtdWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :home))
  end
end
