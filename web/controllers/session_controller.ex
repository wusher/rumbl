defmodule Rumbl.SessionController do 
  use Rumbl.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def delete(conn, _) do
    conn
    |> Rumbl.Auth.logout()
    |> put_flash(:info, "you have been logged out")
    |> redirect(to: page_path(conn, :index))
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Rumbl.Auth.login_by_creds(conn, username, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "welcome back")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "invalid creds")
        |> render("new.html")
    end
  end
end
