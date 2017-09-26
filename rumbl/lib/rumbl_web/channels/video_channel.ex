defmodule RumblWeb.VideoChannel do
  use RumblWeb, :channel

  def join("videos:" <> video_id, _params, socket) do
    IO.inspect([socket: socket])
    {:ok, assign(socket, :video_id, String.to_integer(video_id))}
  end
end
