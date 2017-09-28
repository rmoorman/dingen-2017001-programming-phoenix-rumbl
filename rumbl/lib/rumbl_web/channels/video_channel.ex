defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel
  alias RumblWeb.AnnotationView
  import Ecto.Query

  def join("videos:" <> video_id, _params, socket) do
    video_id = String.to_integer(video_id)
    video = Rumbl.Videos.get_video!(video_id)

    annotations = Rumbl.Repo.all(
      from a in Ecto.assoc(video, :annotations),
        order_by: [asc: a.at, asc: a.id],
        limit: 200,
        preload: [:user]
    )
    res = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}

    {:ok, res, assign(socket, :video_id, video_id)}
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
