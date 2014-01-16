# Use local alias
# $ = jQuery

# Namespacing
window.LoadingHandler ||= {}

LoadingHandler.showLoader = () ->
  $('.loading-frame').show()
  $('body').css("background-color", "grey")
  $('.frame').css("opacity", "0.4")