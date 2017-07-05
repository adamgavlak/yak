// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import search from "./search"
import Quill from "quill"

import Turbolinks from "turbolinks"

Turbolinks.start()

function initQuill(container) {
  return new Quill(container, {
    modules: {
      toolbar: [
        [{'header': '2'}],
        ['bold', 'italic', 'underline'],
        [{list: 'bullet'}, {list: 'ordered'}],
      ]
    },
    theme: 'snow'
  })
}

document.addEventListener('turbolinks:load', () => {
  // Mobile menu
  let mobile = document.querySelector(".navigation__mobile")
  let menu = document.querySelector(".js-menu")

  if (mobile && menu)
  {
    mobile.addEventListener('click', (e) => {
      if (menu.classList.contains('is-open')) {
        menu.classList.remove('is-open')
        mobile.children[1].classList.remove('is-active')
      }
      else {
        menu.classList.add('is-open')
        mobile.children[1].classList.add('is-active')
      }
    })
  }

  let search_button = document.querySelector(".search__btn")
  let search_bar = document.querySelector(".search__bar")

  if (search_button && search_bar)
  {
    search_button.addEventListener('click', (e) => {
      if (search_bar.classList.contains('search--open'))
        search_bar.classList.remove('search--open')
      else {
        search_bar.classList.add('search--open')
        document.querySelector(".search__input").focus()
      }
    })
  }

  let quill = null
  let editor_container = document.querySelector('#description-container')

  if (quill === null && editor_container) {
    quill = initQuill(editor_container);
  }

  if (quill && editor_container) {
    let form = document.querySelector('form')
    let description = document.querySelector('#job_description')
    let description_formatted = document.querySelector('#job_description_formatted')

    if (description.value) {
      quill.setContents(JSON.parse(description.value))
    }

    form.onsubmit = () => {
      description.value = JSON.stringify(quill.getContents())
      description_formatted.value = quill.container.firstChild.innerHTML
    }
  }
})