defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end

  def handle_in(event, params, socket) do
    user = Rumbl.Repo.get(Rumbl.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> Ecto.build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Rumbl.Videos.Annotation.changeset(params)

    case Rumbl.Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: RumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at,
        }
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
