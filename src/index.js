import './main.css'
import avatarUrl from './avatar.png'
import programmingElmBetaUrl from './programming-elm-beta.jpg'
import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import conferences from './conferences.json'

const app = Main.embed(document.getElementById('root'), {
  avatarUrl,
  programmingElmBetaUrl,
  conferences,
  width: window.innerWidth,
  height: window.innerHeight,
})

app.ports.title.subscribe((title) => {
  document.title = title
})

registerServiceWorker()
