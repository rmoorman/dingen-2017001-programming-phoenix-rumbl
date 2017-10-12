defmodule RumblWeb.Channels.VideoChannelTest do
  use RumblWeb.ChannelCase
  import Ecto
  import Rumbl.TestHelpers
  alias Rumbl.Repo


  setup do
    user = insert_user(%{name: "Rebecca"})
    video = insert_video(user, title: "Testing")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    {:ok, socket} = connect(RumblWeb.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, video: video}
  end

  test "join replies with video annotations", %{socket: socket, video: vid} do
    for body <- ~w(one two) do
      vid
      |> build_assoc(:annotations, %{body: body})
      |> Repo.insert!()
    end
    {:ok, reply, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})

    assert socket.assigns.video_id == vid.id
    assert %{annotations: [%{body: "one"}, %{body: "two"}]} = reply
  end
end
