$('document').ready -> 
  $('input[type="checkbox"]').click ->
     $checkbox = $(this)
     $course = $checkbox.closest('tr')
     data = {}
     data["course_id"] = $course.attr('course_id')
     ctype = if $checkbox.attr('checked') == "checked" then "delete" else "post"
     console.log $course, $checkbox, ctype, data
     return false
  