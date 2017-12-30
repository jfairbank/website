import './main.css'
import avatarUrl from './avatar.png'
import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'
import conferences from './conferences.json'

Main.embed(document.getElementById('root'), {
  avatarUrl,
  conferences,
})

registerServiceWorker()
