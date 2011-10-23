
/*
FOR LATER....
var favorites = {
    0 : {
        'dept' : 'COSC',
        'number' : '005',
        'time' : '10',
        'title' : 'Intro Computer Science',
        'quarter' : '11F',
        'prof' : 'Balkcom',
        },
};

function show_favorites(){
    show_in_here = $('#favorites');
    favorites_dom_elem = $('<span></span>');
    for(var key in favorites){
        favorite = favorites[key];
        favorite_li = $("<li>hi</li>");
        timeslot_div = get_or_create_favorite_timeslot_div(favorite['timeslot']);
        timeslot_div.append(favorite_li);
    }
    show_in_here.append(favorites_dom_elem);
}

function get_or_create_favorite_timeslot_div(timeslot){
    class = 'favorite_timeslot_div_' + timeslot
    existing_div = $('.' + class);
    if(existing_div){
        return existing_div;
    }
    else{
        new_div = $('<div></div>');
        new_div.attr('class', class);
        $('#favorites').append();
    }
}
*/

