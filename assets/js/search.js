import Vue from "vue/dist/vue.js"
import algoliasearch from "algoliasearch"
import _ from 'lodash'

let client = algoliasearch('297ZPBDUDG', '85e710f8d55f85555f3dc77a607ef83c')
let index = client.initIndex('dev_JOBS')

Vue.component('search', {
  data() {
    return {
      searchDone: false,
      query: "",
      hits: []
    }
  },
  methods: {
    handle: _.debounce(function () {
        if (this.query === "") {
          this.hits = []
          this.searchDone = false
        }
      
        if (this.query.length >= 2) {
          this.searchDone = false

          index.search(this.query, (err, content) => {
            this.hits = this.parse(content)
            this.searchDone = true
          })
        }
      }, 300),
    parse(content) {
      return content.hits.map(el => {
        return {
          link: el.link,
          title: this.generateTitle(el)
        }
      })
    },
    generateTitle(el) {
      let h = el._highlightResult
      return `${h.title.value} - ${h.company.value} - ${h.location.value}`
    },
    toggle(event)
    {
      if (!this.active) {
        document.querySelector(".queryInput").focus()
      }

      this.active = !this.active
    },
    clearQuery() {
      this.query = ""
      this.hits = []
      this.searchDone = false
      document.querySelector(".search__input").focus()
    }
  }
})

let app = null

document.addEventListener('turbolinks:load', () => {
  app = new Vue({
    el: '.header'
  })
})