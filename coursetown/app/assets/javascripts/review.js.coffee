# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

batch_submit_url = '/reviews/batch'

markCompleteRows = (data) ->
  alert JSON.stringify(data)
  for row_id in data
    $("#review_row_#{row_id}").remove()

$(document).ready ->
  $('#batch_review_submit').click ->
    $.ajax(
      dataType: 'json'
      type: 'POST'
      url: batch_submit_url
      data: $('#batch_review_form').serialize()
      success: markCompleteRows
      error: (e) ->
        console.log($('#batch_review_form').serialize());
    )
    false
