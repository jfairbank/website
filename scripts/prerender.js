const util = require('util')
const fs = require('fs')
const path = require('path')
const sh = require('shelljs')
const elmStaticHtml = require('elm-static-html-lib').default
const cheerio = require('cheerio')
const manifest = require('../build/webpack-assets.json')
const conferences = require('../src/conferences.json')

const writeFile = util.promisify(fs.writeFile)

const rootPath = path.resolve(__dirname, '../')
const elmStaticHtmlDir = path.resolve(rootPath, '.elm-static-html')
const elmPackage = path.resolve(rootPath, 'elm-package.json')
const buildDir = path.resolve(rootPath, 'build')

const avatarUrl = manifest['static/media/avatar.png']

const pages = [
  {
    view: 'Pages.viewHome',
    outFile: path.join(buildDir, 'index.html'),
    model: avatarUrl,
    decoder: 'Json.Decode.string',
  },

  {
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

function addLinkAndScript($) {
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
      <title>Jeremy Fairbank</title>
      <link rel="stylesheet" href="https://use.fontawesome.com/102743fa7d.css">
      <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300i,400,700" rel="stylesheet">
    `)

  $root.append($children)

  $body
    .html($root)
    .append(`<script src="${mainJs}"></script>`)

  return $
}


Promise.all(
  pages.map(({ view, outFile, ...options }) => (
    elmStaticHtml(rootPath, view, { ...baseOptions, ...options })
      .then(cheerio.load)
      .then(addLinkAndScript)
      .then($ => $.html())
      .then(html => writeFile(outFile, html))
  ))
)
  .then(() => console.log('All done!'))
