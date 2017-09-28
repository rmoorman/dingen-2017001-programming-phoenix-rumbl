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

    postButton.addEventListener("click", e => {
      const payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel
        .push("new_annotation", payload)
        .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    vidChannel.on("new_annotation", res => {
      this.renderAnnotation(msgContainer, res)
    })

    vidChannel.join()
      .receive("ok", ({annotations}) => {
        annotations.forEach(annotation => this.renderAnnotation(msgContainer, annotation))
      })
      .receive("error", error => console.log("join failed", reason))
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    const template = document.createElement("div")
    template.innerHTML = `
    <a href="#" data-seek="${this.esc(at)}">
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `
    msgContainer.appendChild(template)
    msgContainer.scrollTop = msgContainer.scrollHeight
  },

  esc(str) {
    const div = document.createElement("div")
    div.appendChild(document.createTextNode(str))
    return div.innerHTML
  },
}


export default Video
