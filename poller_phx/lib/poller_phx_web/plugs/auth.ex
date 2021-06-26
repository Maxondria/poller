defmodule PollerPhxWeb.Plugs.Auth do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias PollerPhxWeb.Router.Helpers, as: Routes

  alias PollerDal.Users

  # Module based plug
  def init(opts), do: opts

  def call(conn, _opts) do
    # Retrieves values from the session cookie
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Users.get_user!(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  # End Module based plug

  # Functonal based plugs here
  def valid_user(conn, _opts) do
    cond do
      conn.assigns.current_user ->
        conn

      true ->
        conn
        |> put_flash(:error, "You must be logged in to access that page")
        |> redirect(to: Routes.auth_path(conn, :new))
        # Don't call any more plugs
        |> halt()
    end
  end

  def admin_user(conn, _opts) do
    cond do
      conn.assigns.current_user && conn.assigns.current_user.admin ->
        conn

      true ->
        conn
        |> put_flash(:error, "You must be an admin to access this page")
        |> redirect(to: Routes.page_path(conn, :index))
        # Don't call any more plugs
        |> halt()
    end
  end

  # End functional plugs here
end
