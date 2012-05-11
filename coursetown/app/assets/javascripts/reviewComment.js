$( function(){ 
    $('.showCommentWork').click( function(){
            commentButton(this, "workload", false );
    });
    $('.showCommentCourse').click( function(){
            commentButton(this, "course", false );
    });
    $('.showCommentProf').click( function(){
            commentButton(this, "prof", false );
    });
    $('.showCommentWorkFuzzy').click( function(){
            commentButton(this, "workload", true );
    });
    $('.showCommentCourseFuzzy').click( function(){
            commentButton(this, "course", true );
    });
    $('.showCommentProfFuzzy').click( function(){
            commentButton(this, "prof", true );
    });



    var commentButton = function( that, type, fuzzy){
        if(!that.clicked){
            showComments(that, type, fuzzy );
            that.clicked = true;
        }
        else if(that.clicked){
           $("#" + getId(that, type, fuzzy) ).parent().toggle(); 
           $('#' + getId(that, type, fuzzy)).focus();  
        }
    }

    var showComments = function(that, type, fuzzy){
       //Super hacky, get id from class and use it to create a proper commentbox;
        var id = getId( that, type, fuzzy );
        var prefix = "schedule";
        if( fuzzy ){
            prefix = "fuzzy";
        }
        var area = '<tr><td colspan=8>' + type+':<textarea class="" id="' +id + '" name="offerings[' + prefix +'][6]['+ type+ '_comment]"></textarea></td></tr>'
        $(that).parent().parent().after(area);
       $('#' + id).focus();  
        };
    
    var getId = function( that, type, fuzzy ){
        var p = "schedule";
        if( fuzzy ){
            p = "fuzzy";
        }
        var index = $(that).parent().parent().attr('class').split(/\s+/)[1];
        return 'offerings_' + p + '_' + index + '_' + type + '_comment';
    }
});
