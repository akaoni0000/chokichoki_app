# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#hairdresser_post_number").jpostal({
    postcode : [ "#hairdresser_post_number" ],
    address  : {
                  "#hairdresser_address" : "%3%4%5"
                  }
  })