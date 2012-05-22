# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

batch_submit_url = '/reviews/batch'
num_successful_reviews = 0

markCompleteRows = (data) ->
  num_successes = data.length
  if data.length == 0
    $('#alert_box').hide()
    $('#warning_box').show()
  else
    num_successful_reviews = num_successful_reviews + num_successes
    $('#alert_box').html('Submitted ' + num_successes + " new reviews (" + num_successful_reviews + ' total this session)')
    $('#alert_box').show()
    $('#warning_box').hide()
    for row_id in data
      $("#review_row_#{row_id}").addClass('submitted')
      $("#review_row_#{row_id}_prof_comment").addClass('submitted-comment-row')
      $("#review_row_#{row_id}_workload_comment").addClass('submitted-comment-row')
      $("#review_row_#{row_id}_course_comment").addClass('submitted-comment-row')

$(document).ready ->
  $('#alert_box').hide()
  $('#warning_box').hide()
  $('#warning_box').html("Woops, you didn't successfully submit any new reviews. Make sure you have all the required fields filled out (including 'Why?')")
  $('#batch_review_submit').click ->
    $.ajax(
      dataType: 'json'
      type: 'POST'
      url: batch_submit_url
      data: $('#batch_review_form').serialize()
      success: markCompleteRows
      error: (e) ->
        console.log($('#batch_review_form').serialize());
        $('#alert_box').hide()
        $('#warning_box').show()
    )
    false