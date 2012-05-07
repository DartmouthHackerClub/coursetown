if window.location.href == 'https://banner.dartmouth.edu/banner/groucho/bwskotrn.P_ViewTran'
  submit_url = 'http://localhost:3000/reviews/batch_from_transcript'

  payload = document.documentElement.innerHTML.replace(/"/g, '&quot;').replace(/'/g, '&apos;')

  send_transcript_via_bookmarklet = ->
    # send transcript (over https) to rails server for scraping
    $("<form action='#{submit_url}' method='POST'>
      <input type='hidden' name='transcript' value='#{payload}'>
      </form>").submit()

  if typeof jQuery == 'undefined'
    script = document.createElement('script')
    script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
    script.onload = send_transcript_via_bookmarklet
    document.body.appendChild(script)
  else
    send_transcript_via_bookmarklet()

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