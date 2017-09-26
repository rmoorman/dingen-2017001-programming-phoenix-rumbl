import Player from "./player"


const Video = {
  init(socket, element) {
    if (!element) return

    const playerId = element.getAttribute("data-player-id")
    const videoId = element.getAttribute("data-id")

    socket.connect()

    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket) {
    const msgContainer = document.getElementById("msg-container")
    const msgInput = document.getElementById("msg-input")
    const postButton = document.getElementById("msg-submit")
    const vidChannel = socket.channel("videos:" + videoId)
    vidChannel.join()
      .receive("ok", res => console.log("joined the video channel", res))
      .receive("error", error => console.log("join failed", reason))
  },
}


export default Video
