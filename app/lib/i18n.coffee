English = require 'locales/en'

class I18n
  @languages:
    en: English
  
  @current: English
  
  @switchTo: (id) =>
    locale = require "locales/#{ id }"
    @current = @languages[id] = locale
    @load()
  
  @load: =>
    for el in $('[data-i18n]')
      el = $(el)
      el.text @t(el.data('i18n'))
  
  @iterator: (hash, key) -> hash[key]
  @t: (path) => _(path.split('.')).reduce @iterator, @current

module.exports = I18n
