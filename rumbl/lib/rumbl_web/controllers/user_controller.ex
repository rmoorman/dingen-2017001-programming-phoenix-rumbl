defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  def index(conn, _params) do
    users = Rumbl.Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end
end
