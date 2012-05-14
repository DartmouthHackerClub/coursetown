// TODO: the better way to do this would be to just number rows 1..n
// and include a hidden 'schedule_id' field on the ones w/ schedules
// then there's no need to hide the id as a class (hacky!) to generate
// the name field

var course_placeholder = "How interesting, well-paced, and useful was the course? Would you recommend it?";
var workload_placeholder = "Was the workload manageable? Consistent throughout the term? Difficult? Did it seem like busy-work? Any tips?";
var prof_placeholder = "Were the professors helpful? Knowledgeable? Fair? How were the lectures/discussions?";

$( function(){
    $('.showCommentWork').click( function(){
            commentButton(this, 'workload', "Workload", workload_placeholder );
    });
    $('.showCommentCourse').click( function(){
            commentButton(this, 'course', "Course", course_placeholder );
    });
    $('.showCommentProf').click( function(){
            commentButton(this, 'prof', "Prof.", prof_placeholder );
    });



    var commentButton = function( that, type, title, placeholder){
        if(!that.clicked){
            showComments(that, type, title, placeholder );
            that.clicked = true;
        }
        else if(that.clicked){
           $("#" + getId(that, type)).toggle();
           $('#' + getId(that, type) + '-span').focus();
        }
    }

    var showComments = function(that, type, title, placeholder){
       //Super hacky, get id from class and use it to create a proper commentbox;
        var id = getId( that, type );
        var row_id = getIndex(that);
        var area = '<tr class="comment-row" id="' + id + '"><td colspan=10><span>' + title + '</span><textarea class="" ' +
            'id="' + id + '-span" name="offerings[' + row_id +']['+ type + '_comment]" ' +
            'placeholder="' + placeholder + '"></textarea></td></tr>';
        $(that).parent().parent().after(area);
       $('#' + id + '-span').focus();
        };

    var getIndex = function( that ){
        // parent row has id like "review_row_6"
        return $(that).parent().parent().attr('id').split('review_row_')[1];
    }

    var getId = function( that, type ){
        return 'review_row_' + getIndex(that) + '_' + type + '_comment';
    }
});
