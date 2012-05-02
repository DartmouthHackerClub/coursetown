$('document').ready -> 
  $('input[type="checkbox"]').click ->
     $checkbox = $(this)
     $course = $checkbox.closest('tr')
     data = {}
     data["course_id"] = $course.attr('course_id')
     type = if $checkbox.attr('course_in_wishlist')  == "true" then "delete" else "post"
     url = "/wishlists/" 
     url += data["course_id"] if type == "delete" 
     console.log $course, $checkbox, type, data
     $.ajax(
       url: url
       data: data
       type: type
       success: ->
         $checkbox.toggleCheckbox()
         $checkbox.attr('course_in_wishlist', !attr('course_in_wishlist'))
     );
     return false
  
