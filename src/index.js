import './main.css'
import avatarUrl from './avatar.png'
import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import conferences from './conferences.json'

const app = Main.embed(document.getElementById('root'), {
  avatarUrl,
  conferences,
})

app.ports.title.subscribe((title) => {
  document.title = title
})

registerServiceWorker()
