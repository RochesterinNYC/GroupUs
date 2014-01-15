# Use local alias
# $ = jQuery

# Namespacing
window.LoadingHandler ||= {}

LoadingHandler.initializeLoader = () ->
  for el in $('.loader-needed')
    el = $(el)
    el.click(LoadingHandler.showLoader)

LoadingHandler.showLoader = () ->
  $('.loading-frame').show()
  $('body').css("background-color", "grey")
  $('.frame').css("opacity", "0.4")