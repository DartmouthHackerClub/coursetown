
var empty_rows = 0;
var query_url = 'http://hacktown.cs.dartmouth.edu/search/courses/courses/_search';
//TODO: delete the above when we're fully transitioned off of couch
var search_query_url = '/search_json';
var d1 = null; //for debugging

var last_result = null;     // used for re-sorting
var sortby = "course";

function sort_divs(data) {
    var f;
    switch(sortby) {
        case "course":
            f = function(a,b) {
                a = $(a);
                b = $(b);
                var keya = a.attr('data-department');
                var keyb = b.attr('data-department');
                if (keya < keyb) {
                    return -1;
                }
                else if (keya > keyb) {
                    return 1;
                }
                else {
                    return a.attr('data-number') - b.attr('data-number');
                }
            }
            break;
        case "time":
            f = function(a,b) {

                function score(period) {
                    switch(period) {
                        case '8': return 0;
                        case '9': return 1;
                        case '9L': return 1;
                        case '9S': return 1;
                        case '10': return 2;
                        case '10A': return 2;
                        case '11': return 3;
                        case '12': return 4;
                        case '2': return 5;
                        case '2A': return 5;
                        case '3A': return 6;
                        case '3B': return 6;
                        default: return 7;
                    }
                }
                return score($(a).attr('data-period')) - score($(b).attr('data-period'));
            }
            break;
        case "median":
            // highest first
            f = function(a,b) {
                amed = $(a).attr('data-avg-median');
                bmed = $(b).attr('data-avg-median');
                if (!amed && !bmed)
                    return 0;
                if (!amed)
                    return 1;
                if (!bmed)
                    return -1;
                return bmed - amed;
            }
            break;

        default: alert('invalid sorting id, something went wrong');
    }
    return data.sort(f);
}

function loading() {
    $('#loading_results').show();
    $('#the_results').hide();
    $('#no_results').hide()
}

function hide_loading() {
    $('#loading_results').hide();
}

function show_results(results) {
    last_result = results
    hide_loading();
    if(results.length <= 0) {
        $('#no_results').show();
        $('#the_results').hide();
    } else {
        $('#no_results').hide();
        $('#the_results').show();
        results = sort_divs(results);
        $('#the_results').html(results);
    }
    return;
}

function show_error(e) {
    //console.log(e);
    result_div = $('<div class="error_msg"><h3>OH NOES! AN ERROR!</h3><h4>Shield Your Eyes:</h4><div>');
    result_div.append(JSON.stringify(e));
    $('#the_results').html(result_div);
    return true;
}

// course guide defines depts by number
function get_department_number(dept) {
    if (dept_map && dept_map[dept])
        return dept_map[dept]['id'];
    return -1;
}

function generate_input_field_quarter() {
    date = new Date();
    this_year = date.getFullYear();
    years = [this_year, this_year+1]
    var html = '';
    html += '<select name="term">';
    html += '<option value="F">Fall</option>';
    html += '<option value="W">Winter</option>';
    html += '<option value="S">Spring</option>';
    html += '<option value="X">Summer</option>';
    html += '</select>';
    html += '<select name="year">';
    for (key in years) {
        year = years[key];
        html += '<option value="' + year+ '">' + year+ '</option>';
    }
    html += '</select>';
    return html;
}

function generate_input_field_time() {
    times = ['8', '9', '9L', '9S', '10', '11', '12', '2', '10A', '2A', '3A', '3B', ];
    html = '';
    html += '<span style="font-size: .7em;">';
    for (key in times) {
        time = times[key];
        html += '<input type="checkbox" name="period_' + time + '" id="period_' + time + '" value="1" /><label for="period_'+time+'">'+time+'</label>';
    }
    html += '&nbsp;&nbsp;&nbsp;';
    html += '<a href="#" class="check_all">ALL</a>';
    html += '&nbsp;&nbsp;&nbsp;';
    html += '<a href="#" class="check_none">NONE</a>';
    html += '</span>';
    return html;
}

function generate_input_field_distrib() {
    distribs = ['ART', 'LIT', 'TMV', 'INT', 'SOC', 'QDS', 'SCI', 'SLA', 'TAS', 'TLA', ];
    html = '';
    html += '<span style="font-size: .7em;">';
    for (key in distribs) {
        distrib = distribs[key];
        html += '<input type="checkbox" name="distrib_' + distrib + '" id="distrib_' + distrib + '" value="1" /><label for="distrib_'+distrib+'">'+distrib+'</label>';
    }
    html += '&nbsp;&nbsp;&nbsp;';
    html += '<a href="#" class="check_all">ALL</a>';
    html += '&nbsp;&nbsp;&nbsp;';
    html += '<a href="#" class="check_none">NONE</a>';
    html += '</span>';
    return html;
}

function make_left_side_dropdown() {
    var dropdown = $('<select name="criteria"></select>');
    var first_option = $('<option value="null">---Choose Criteria---</option>');
    dropdown.append(first_option);
    for (var key in search_options) {
        var settings = search_options[key];
        var option_tag = $('<option></option>');
        option_tag.attr('value', key);
        option_tag.html(settings['long_name']);
        dropdown.append(option_tag);
    }
    dropdown.change(function () {
        choice = $(this).val();
        old_value = dropdown.data('old_value');
        dropdown.data('old_value', choice);
        if (choice == 'null') {
            var right_side_html = '';
            if (!$(this).data('is_empty')) {
                empty_rows++;
                $(this).data('is_empty', true);
            }
        } else {
            $(this).children('[value="null"]').hide();
            search_options[choice]['in_use'] = true;
            var right_side_html = search_options[choice]['input_field'];
            if ($(this).data('is_empty')) {
                empty_rows--;
                $(this).data('is_empty', false);
            }
        }
		/*
        if(!old_value){
            $(this).parent().children('.close_row').show();
        }
		*/
        if (old_value) {
            search_options[old_value]['in_use'] = false;
        }
        var right_side = $(this).parents('fieldset.search_row').find('.right_side')
        right_side.html(right_side_html);
        add_search_row_if_we_need_one();
    });
    dropdown.data('is_empty', true);
    dropdown.mouseenter(function () {
        for (key in search_options) {
            if (search_options[key]['in_use']) {
                $(this).find("option[value='" + key + "']").hide();

            } else {
                $(this).find("option[value='" + key + "']").show();
            }
        }
    });
    return dropdown;
}

function add_search_row_if_we_need_one() {
  while (empty_rows <= 0) {
    insert_search_row_dom_element();
  }
  $(".check_all").click(function () {
    $(this).parent().children("input").attr('checked', true);
  });
  $(".check_none").click(function () {
    $(this).parent().children("input").attr('checked', false);
  });
  $(".close_row").click(function () {
    left_side = $(this).parent();
    // choose "null" in the dropdown--just to make sure that the option that had been selected gets added back to the set of available options
    left_side.find("select option:selected").removeAttr('selected');
    left_side.find("select option[value='title']").attr('selected', 'selected');
    left_side.find("select").change();
    left_side.parent().hide();
  });
    $('input[id="title"]').autocomplete({
      source: '/courses.json',
    });
    $('input[id="prof"]').autocomplete({
      source: '/professors.json',
    });
    $('input[id="dept"]').autocomplete({
      source: '/departments.json',
    });
}

function make_search_row_dom_element() {
    row = $(' <fieldset class="search_row"> </fieldset> ');
    left_side = $(' <fieldset class="left_side"> </fieldset> ');
    close_link = $('<a href="#" class="close_row">X</a>');
    // left_side.append(close_link);
    // close_link.hide();
	dropdown = make_left_side_dropdown();
    left_side.append(dropdown);
    right_side = $(' <fieldset class="right_side"></fieldset> ');
    row.append(left_side);
    row.append(right_side);
    row.append(close_link)
	return row[0];
}

function get_search_form() {
    return $('#search_form');
}

function insert_search_row_dom_element() {
    row = make_search_row_dom_element();
    get_search_form().find('.rows').append(row);
	$(row).wrap("<p>");
    /*
    if (row.find('#Professors')) {
        $('#Professors').focus();
    }
    else if (row.find('#title')) {
        $('#title').focus();
    }
    */
    empty_rows++;
    return row;
}


function removeDups(arrVal) {
    var uniqueArr = [];
    for (var i = arrVal.length; i--; ) {
        var val = arrVal[i];
        if ($.inArray(val, uniqueArr) === -1) {
            uniqueArr.unshift(val);
        }
    }
    return uniqueArr;
}

// implement JSON.stringify serialization for browsers that don't have
JSON = {};
JSON.stringify = JSON.stringify || function (obj) {
    var t = typeof (obj);
    if (t != "object" || obj === null) {
        // simple data type
        if (t == "string") obj = '"'+obj+'"';
        return String(obj);
    }
    else {
        // recurse array or object
        var n, v, json = [], arr = (obj && obj.constructor == Array);
        for (n in obj) {
            v = obj[n]; t = typeof(v);
            if (t == "string") v = '"'+v+'"';
            else if (t == "object" && v !== null) v = JSON.stringify(v);
            json.push((arr ? "" : '"' + n + '":') + String(v));
        }
        return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
    }
};
// implement JSON.parse de-serialization
JSON.parse = JSON.parse || jsonParse

// search options
var search_options = {
    'Professors': {
        'long_name': 'Professor',
        'input_field': '<input type="text" name="Professors" id="Professors" value=""/>'
    },
    'title': {
        'long_name': 'Title',
        'input_field': '<input type="text" name="title" id="title" value=""/>'
    },
    'department': {
        'long_name': 'Department',
        'input_field': '<input type="text" name="department" id="dept" value=""/>'
    },
    'Number': {
        'long_name': 'Course Number',
        'input_field': '<input type="text" name="Number" id="Number" value=""/>'
    },
    'description': {
        'long_name': 'Course Description',
        'input_field': '<input type="text" name="description" id="description" value=""/>'
    },
    'median_grade': {
        'long_name': 'Average Median',
        'input_field': ' \
<select name="avg_median" > \
<option value="4.00">A</option> \
<option value="3.66">A- or higher</option> \
<option value="3.33" selected>B+ or higher</option> \
<option value="3.0">B or higher</option> \
<option value="2.66">B- or higher</option> \
</select> \
'
    },
    // 'time': {
    //     'long_name': 'Meeting Time',
    //     'input_field': generate_input_field_time()
    // },
    // 'term': {
    //     'long_name': 'Quarter',
    //     'input_field': generate_input_field_quarter()
    // },
    // 'dist': {
    //     'long_name': 'Distrib',
    //     'input_field': generate_input_field_distrib()
    // },
    'wc': {
        'long_name': 'World Culture',
        'input_field': '\
<select name="wc"><option value="W">W</option><option value="NW">NW</option><option value="CI">CI</option></select>'
    },
    'nro': {
        'long_name': 'Can NRO?',
        'input_field': '<input type="checkbox" name="nro" value="true" checked="true"/>Heck Yeah'
    }
/*
'enrollment_cap':  {
'long_name' : 'Enrollment Cap',
'input_field' : '<input type="text" name="" id="" value="" />'
},
*/
    /*
    'space_left': {
        'long_name': 'Space Left?',
        'input_field': '<input type="checkbox" checked="checked" />Heck Yeah'
    },
    */
};

//RUN THIS STUFF AT PAGE LOAD
$().ready(function () {
    if($.browser.msie) {
        $('#results_container').append('<h1><a href="http://getfirefox.com">Get Firefox</a> or <a href="http://google.com/chrome">Get Chrome</a></h1>');
        alert("Course picker isn't written for Internet Explorer and may not work correctly.");
    }

    // hide the three results boxes (loading, results, no_results)
    loading();
    hide_loading();

    search_params = {
        "size": 9000
    };

    // prof and title autocomplete
    $.ajax({
        dataType: "json",
        type: "POST",
        url: search_query_url,
        data: JSON.stringify(search_params),
        success: function (data) {
            profs = removeDups($.map(data , function(x){ return x['_source']['Professors']}));
            titles = removeDups($.map(data , function(x){ return x['_source']['title']}));
        },
        error: function (e) {
            //console.log(JSON.stringify(e));
        }
    });

    // department autocomplete
    dept_abbrevs = []
    for (key in dept_map) {
        dept_abbrevs.push(key);
        dept_abbrevs.push(dept_map[key]['name']);
    }

    for (key in search_options) {
        search_options[key]['in_use'] = false;
    }

    row1 = insert_search_row_dom_element();
    row1 = $(row1);

    row1.find("select option:selected").removeAttr('selected');
    row1.find("select option[value='title']").attr('selected', 'selected');
    row1.find("select").change(); // TODO: removing this line breaks autocomplete. HOW.

    //show_favorites();
    $("#search_form").submit(function(event) {
        event.preventDefault();
    	try{
            the_form = $('#search_form');
            loading();
            $.ajax({
                dataType: "html",
                type: "GET",
                url: search_query_url,
                data: the_form.serialize(),
                success: function (data) {
                    show_results($(data).children('div.post'));
                },
                error: function (e) {
                    show_error(e);
                }
            });
        }catch(e){
        	console.log(e.message)
        }
        return false;
    });


    // bind sort by preferences
    $("input:radio[name=sortby]").change(function() {
            sortby = $(this).val();
            if (last_result) {
                loading();
                show_results(last_result);
            }
    });

    // // if they already have a search encoded in the URL, execute it
    // if(window.location.hash){
    //     the_params = JSON.parse(window.location.hash);
    //     do_search(the_params);
    // } else {
    //     hide_loading();
    // }
});
