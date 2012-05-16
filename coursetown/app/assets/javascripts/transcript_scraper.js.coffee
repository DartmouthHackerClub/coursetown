if window.location.href == 'https://banner.dartmouth.edu/banner/groucho/bwskotrn.P_ViewTran'
  app_root = 'http://localhost:3000/'
  submit_url = "#{app_root}reviews/batch_from_transcript"
  login_check_url = "#{app_root}am_i_logged_in"
  course_picker_url = "http://localhost:3000/auth/cas?callback=#{app_root}reviews/batch_from_transcript"

  payload = document.documentElement.innerHTML.replace(/"/g, '&quot;').replace(/'/g, '&apos;')

  # CONTROL FLOW:
  #  load jQuery if necessary
  #  check if user's logged in
  #    if not, tell them to log in and EXIT
  #  remove names from document
  #  prompt about removing grades
  #    if cancel, remove grades
  #  actually send the data via POST & load the results (POST!)

  # replication of the hpricot parsing, but with jquery!
  remove_grades = ($) ->
    # are we at the part of the page yet that has grades?
    at_grades_already = false
    $('table.datadisplaytable tr').each( (i, row) ->
      kids = row.children
      if !at_grades_already && kids.length == 1 && $(kids[0]).find('a[name="insti_credit"]').length >= 1
        at_grades_already = true
      return if !at_grades_already || kids.length < 7
      meets_format = true
      $(kids).each( (j,kid) ->
        meets_format = meets_format && ($(kid).attr('class') == 'dddefault' ||
          $(kid).attr('class') == 'dddead')
      )
      # replace grade
      return if !meets_format
      $(kids[6]).html('<span class="redacted-data" style="color:#2ad;">[removed]</span>')
    )

  submit_transcript = ->
    # send transcript (over https) to rails server for scraping
    $("<form action='#{submit_url}' method='POST'>
      <input type='hidden' name='transcript' value='#{payload}'>
      </form>").submit()

  remove_name = ->
    $('table.datadisplaytable tr').each( (i, row) ->
      kids = row.children
      return if kids.length != 2
      if $(kids[0]).attr('class') == 'ddlabel' && ($(kids[0]).html() == 'Name :' || $(kids[0]).html() == 'Birth Date:')
        $(kids[1]).html('<span class="redacted-data" style="color:#2ad;">[removed]</span>')
    )

  not_logged_in = ->
    alert("Looks like you aren't logged in on Course Picker. Please log in and then try again")

  check_logged_in = ->
    $.ajax(
        dataType: "json"
        type: "GET"
        url: login_check_url
        success: (data) ->
          if data == 'yes'
            remove_name()
            prompt_about_removing_grades()
          else
            not_logged_in()
        error: (e) ->
            not_logged_in()
    )

  get_it_started = ->
    remove_name()
    prompt_about_removing_grades()

  prompt_about_removing_grades = ->
    str = "It's helpful to have reviewers report their grades to give their " +
      "reviews context. All of Course Picker's data is anonymized, so if you " +
      "report your grades nobody (neither us NOR anyone malicious) will be able " +
      "to trace them to your identity." +
      "\n\nPress OK to report your grades along with " +
      "the courses you took (to save you one more step in the review process). " +
      "\n\nPress CANCEL to have your grades removed from this transcript first " +
      "(just like we've already removed your name)."
    if !confirm(str)
      remove_grades(jQuery)
    submit_transcript()

  # RUN IT

  if typeof jQuery == 'undefined'
    script = document.createElement('script')
    script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
    script.onload = get_it_started
    document.body.appendChild(script)
  else
    get_it_started

else
  alert "It looks like you're using this in the wrong place.\n" +
    "\n1. Make sure you're logged in on Hacker Club's Course Picker" +
    "\n2. Make sure you've dragged the bookmarklet into your bookmarks bar" +
    "\n3. Navigate to: Banner > Academic Transcript" +
    "\n4. Pick:" +
    "\n\tTranscript Level: Undergraduate." +
    "\n\tTranscript Type: Undergraduate Unofficial." +
    "\n5. Hit 'Submit'. You should now see your transcript." +
    "\n6. Click the bookmarklet again."
    "\nWe'll send you to bannerstudent now"

  window.location.href = 'https://dartmouth.edu/bannerstudent'
