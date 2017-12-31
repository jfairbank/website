const util = require('util')
const fs = require('fs')
const path = require('path')
const sh = require('shelljs')
const elmStaticHtml = require('elm-static-html-lib').default
const cheerio = require('cheerio')
const manifest = require('../build/webpack-assets.json')
const conferences = require('../src/conferences.json')
const childProcess = require('child_process')
const { createHash } = require('crypto')

const writeFile = util.promisify(fs.writeFile)
const deleteFile = util.promisify(fs.unlink)

const spawn = (...args) => new Promise((resolve, reject) => {
  const process = childProcess.spawn(...args)
  process.stdout.on('data', resolve)
  process.stderr.on('data', reject)
})

const rootPath = path.resolve(__dirname, '../')
const elmStaticHtmlDir = path.resolve(rootPath, '.elm-static-html')
const elmPackage = path.resolve(rootPath, 'elm-package.json')
const buildDir = path.resolve(rootPath, 'build')

const avatarUrl = manifest['static/media/avatar.png']

const pages = [
  {
    title: 'Pages.Home.title',
    view: 'Pages.viewHome',
    outFile: path.join(buildDir, 'index.html'),
    model: avatarUrl,
    decoder: 'Json.Decode.string',
  },

  {
    title: 'Pages.Talks.title',
    view: 'Pages.viewTalks',
    outFile: path.join(buildDir, 'talks.html'),
    model: conferences,
    decoder: 'Data.Conference.decodeConferences',
  },
]

const baseOptions = {
  newLines: false,
  indent: 0,
}

function addLinkAndScript(title, $) {
  const $body = $('body')
  const $children = $body.children()
  const $root = $('<div id="root"></div>')
  const mainJs = manifest['main.js']

  $('head')
    .append(`
      <meta charset="utf-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
      <meta name="theme-color" content="#000000">
      <title>${title}</title>
      <link rel="stylesheet" href="https://use.fontawesome.com/102743fa7d.css">
      <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300i,400,700" rel="stylesheet">
    `)

  $root.append($children)

  $body
    .html($root)
    .append(`<script src="${mainJs}"></script>`)

  return $
}

const portSubscribe = port => new Promise((resolve) => port.subscribe(resolve))

async function loadTitle(title) {
  const [_, ...rest] = title.split('.').reverse()
  const titleModule = rest.reverse().join('.')
  const hash = createHash('MD5').update(title).digest('hex')
  const moduleName = `Call${hash}`

  const moduleTemplate = `port module ${moduleName} exposing (..)

import Platform
import ${titleModule}

port title : String -> Cmd msg

main =
    Platform.program
        { init = ( (), title ${title} )
        , update = \\_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }`

  await writeFile(`${moduleName}.elm`, moduleTemplate)
  await spawn('elm-make', [`${moduleName}.elm`, '--output', `${moduleName}.js`])

  const module = require(`../${moduleName}`)
  const app = module[moduleName].worker()

  const pageTitle = await portSubscribe(app.ports.title)

  await Promise.all([
    deleteFile(`${moduleName}.elm`),
    deleteFile(`${moduleName}.js`),
  ])

  return pageTitle
}

async function prerender(page) {
  const title = await loadTitle(page.title)

  const initialHtml = await elmStaticHtml(rootPath, page.view, {
    ...baseOptions,
    model: page.model,
    decoder: page.decoder,
  })

  const $ = cheerio.load(initialHtml)

  addLinkAndScript(title, $)

  const finalHtml = $.html()

  return writeFile(page.outFile, finalHtml)
}

Promise.all(pages.map(prerender))
  .then(() => console.log('All done!'))
