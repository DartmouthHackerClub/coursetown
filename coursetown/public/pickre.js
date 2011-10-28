var profs = null;
var dept_abbrevs = null;
var titles = null;
var empty_rows = 0;
var query_url = 'http://hacktown.cs.dartmouth.edu/search/courses/courses/_search';
//TODO: delete the above when we're fully transitioned off of couch
var search_query_url = '/search_json';

function show_error(e) {
    //console.log(e);
    the_results_div = get_or_create_results_div().find('#the_results');
    the_results_div.empty();
    result_div = $('<div class="error_msg"><h3>OH NOES! AN ERROR!</h3><h4>Shield Your Eyes:</h4><div>');
    result_div.append(JSON.stringify(e));
    the_results_div.append(result_div);
    return true;
}

var last_result = null;     // used for re-sorting 
var sortby = "course";
function sort_results(data) {
    var f;
    switch(sortby) {
        case "course":
            f = function(a,b) {
                var keya = a['department'];
                var keyb = b['department'];
                if (keya < keyb) {
                    return -1;
                }
                else if (keya > keyb) {
                    return 1;
                }
                else {
                    return a['Number'] - b['Number'];
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
                    }
                }
                return score(a['period']) - score(b['period']);
            }
            break;
        case "median":
            // highest first
            f = function(a,b) {
                if (!a['avg_median'])
                    return 1;
                if (!b['avg_median'])
                    return -1;
                return b['avg_median'] - a['avg_median'];
            }
            break;

        default: alert('invalid sorting id, something went wrong');
    }
    return data.sort(f);
}

function show_results(results) {
    results = sort_results(results);

    the_results_div = get_or_create_results_div().find('#the_results');
    the_results_div.empty();
    if(!results || results == '' || results == {}){
        result_div = $('<div class="error_msg">No results :(</div>');
        the_results_div.append(result_div);
        return false;
    }
    /*
		dept_num_title
		term
		profs
		time
		distrib
		wcult
		crn
		nro
    */
    for (key in results) {
        result = results[key];
        if (!result) continue;
        result_div = generate_result_div(result);
        the_results_div.append(result_div);
    }
    last_result = results;
}

// in: a json object representing a single result (one offering)
// out: a jquery DOM object of that result
function generate_result_div(result) {
    result_div = $('<div class="result"></div>');

    // title
    title = $('<span class="dept_num_title">' + result['department'] + ' ' + result['number'] + ': ' + result['title'] + '</span>');
    // crn
    if(result['crn']){
        crn = $('<span class="crn">CRN ' + result['CRN'] + '</span>');
        title.append(crn);
    }
    result_div.append(title);

    // Course guide link
    var deptnum = get_department_number(result['department']);
    var link = 'http://hacktown.cs.dartmouth.edu/gudru/index.php?become=view&year=&term=&number='+result['number']+'&prof=&action=selectcourses2&dept='+deptnum
    var cglink_div = $('<a class="cglink" href="'+link+'" target="_blank">read reviews</a>');
    result_div.append(cglink_div);

    // term
    term = $('<span class="term"><span class="fieldname">term </span>' + result['term'] + ' ' + result['year'] + '<a href="http://www.dartmouth.edu/~reg/calendars/acad_11_12.html">(?)</a></span>');
    result_div.append(term);

    /*
    // profs
    profs_div = $('<span class="profs"></span>');
    if (result['Professors'].length <= 1) {
        profs_div.append($('<span class="fieldname">prof </span>'));
    }
    else {
        profs_div.append($('<span class="fieldname">profs </span>'));
    }
    if (result['Professors'].length > 0) {
        var first = true;
        var html = '';
        for (key in result['Professors']) {
            if (!first) {
                html += ', ';
            }
            first = false;
    var prof = result['Professors'][key];
            //html += "<a href='http://dartwiki.org/w/" + prof.replace(' ', '_') + "'>" + prof + "</a>"
            html += '<a href="http://hacktown.cs.dartmouth.edu/gudru/index.php?become=view&year=&term=&dept=&number=&prof=' + prof.replace(' ', '+') + '&action=selectcourses2">' + prof + '</a>';
        }
        profs_div.append(html);
    }
    else {
        profs_div.append($('<span class="notfound">none listed</span>'));
    }
    result_div.append(profs_div);
    */

    // Period
    time = $('<span class="time"><span class="fieldname">period </span>' + result['period'] + ' <a href="http://oracle-www.dartmouth.edu/dart/groucho/timetabl.diagram">(?)</a></span>');
    result_div.append(time);


    /*
    // Distribs
    distrib = $('<span class="distrib"><span class="fieldname">distrib </span></span>');
    if(result['dist'] && result['dist'].length > 0){
        var first = true;
        var html = '';
        // TODO at the moment we bundle distribs together into a string
        // so this is unnecessary
        for (key in result['dist']) {
            if (!first) {
                html += ', ';
            }
            first = false;
            html += result['dist'][key];
        }
        distrib.append(html);
    }
    else{
        distrib.append($('<span class="notfound">none</span>'));
    }
    result_div.append(distrib);
    */

    /*
    // WCULT
    wcult = $('<span class="wcult"><span class="fieldname">wcult </span></span>');
    if(result['wc']){
        wcult.append(result['wc']);
    }
    else{
        wcult.append($('<span class="notfound">none</span>'));
    }
    result_div.append(wcult);

    // Can NRO?
    nro = $('<span class="nro"><span class="fieldname">nro </span></span>');
    if(result['nro'] == 'true'){
        nro.append($('<span>yes</span>')); // TODO why is this not displaying w/o <span>?
    }
    else if(result['nro'] == 'false'){
        nro.append($('<span class="notfound">no</span>'));
    }
    result_div.append(nro);
    */

    /*
    // Median
    var median_div = $('<span class="median"><span class="fieldname">avg median </span></span>');
    if (result['avg_median']) {
        var avg = result['avg_median'].toFixed(2);
        median_div.append($('<span>' + avg + '</span>'));
    }
    else {
        median_div.append($('<span class="notfound">not available</span>'));
    }
    result_div.append(median_div);
    */


    /*
    //ORC STUFF
    // Header
    if (result['note'] || result['offered'] || result['description']) {
        var orc_header_div = $('<h4>From the <a href="http://www.dartmouth.edu/~reg/courses/desc/' + result['department'] + '.html"> ' + result['department'] + ' ORC</a> <small>(may be out of date)</small></h4>:');
    result_div.append(orc_header_div);
    }
    // Link to ORC
    else{
    var dept_orc_div = $('<span class="dept_orc"><span class="fieldname">dept ORC</span><a href="http://www.dartmouth.edu/~reg/courses/desc/'+result['department']+'.html">' + result['department'] + ' ORC</a<</span>');
    result_div.append(dept_orc_div);
    }

    // Note
    if (result['note']) {
        var note_div = $('<span class="note"><span class="fieldname">note </span>'+result['note']+'</span>');
        result_div.append(note_div);
    }

    // offered
    if (result['offered']) {
        offered = $('<span class="offered"><span class="fieldname">offered </span>' + result['offered'] + '</span>');
        result_div.append(offered);
    }

    // Description
    if (result['description']) {
        var description_div = $('<span class="description"><span class="fieldname">description </span>'+ result['description'].replace(/\n/g, '<br />') +'</span>');
        result_div.append(description_div);
    }
    */
    return result_div;
}

// course guide defines depts by number
function get_department_number(dept) {
    if (dept_map && dept_map[dept])
        return dept_map[dept]['id'];
    return -1;
}

function get_or_create_results_div() {
    results_div = $('#results');
    if (results_div.length < 1) {
        results_div = $('\
            <div id="results"> \
            <h3> \
            Results \
            </h3> \
            <div id="the_results"> \
            </div> \
            ');
    }
    $('#results_container').html(results_div);
    return results_div;
}

function generate_input_field_quarter() {
    quarters = ['Fall', 'Winter', 'Spring', 'Summer'];
    date = new Date();
    this_year = date.getFullYear();
    years = [this_year, this_year+1]
    var html = '';
    html += '<select name="term">';
    for (key in quarters) {
        quarter = quarters[key];
        html += '<option value="' + quarter + '">' + quarter + '</option>';
    }
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
        if(!old_value){
            $(this).parent().children('.close_row').show();
        }
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
    return dropdown
}

function add_search_row_if_we_need_one() {
    while (empty_rows <= 0) {
        insert_search_row_dom_element();
    }
    $(".check_all").click(function () {
        $(this).parent().children("input").attr('checked', 'checked');
    });
    $(".check_none").click(function () {
        $(this).parent().children("input").attr('checked', '');
    });
    $(".close_row").click(function () {
        left_side = $(this).parent();
        // choose "null" in the dropdown--just to make sure that the option that had been selected gets added back to the set of available options
        left_side.find("select option:selected").removeAttr('selected');
        left_side.find("select option[value='term']").attr('selected', 'selected');
        left_side.find("select").change();
        left_side.parent().hide();
    });
    $('input[name="Professors"]').autocomplete(profs,
            {
                matchContains: true,
                //autoFill: true,
                selectFirst: false
            });
    $('input[name="title"]').autocomplete(titles,
            {
                matchContains: true,
                //autoFill: true,
                selectFirst: false
            });
    $('input[name="department"]').autocomplete(dept_abbrevs,
            {
                //autoFill: true,
                multiple: true,
                selectFirst: false
            });
}

function make_search_row_dom_element() {
    row = $(' <fieldset class="search_row"> </fieldset> ');
    left_side = $(' <fieldset class="left_side"> </fieldset> ');
    close_link = $('<a href="#" class="close_row">X</a>');
    left_side.append(close_link);
    close_link.hide();
    left_side.append(make_left_side_dropdown());
    right_side = $(' <fieldset class="right_side"></fieldset> ');
    row.append(left_side);
    row.append(right_side);
    return row[0];
}

function get_search_form() {
    return $('#search_form');
}

function insert_search_row_dom_element() {
    row = make_search_row_dom_element();
    get_search_form().find('.rows').append(row);
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


function do_search(form_params) {
    window.location.hash = JSON.stringify(form_params);
    periods = [];
    distribs = [];

    queries = {};
    for (key in form_params) {
        if (form_params[key]['name'] == 'department' && form_params[key]['value'] != '') {
            var vals = form_params[key]['value'].split(',');

            depts = [];
            for (var k in vals) {
                var val = $.trim(vals[k]);
                if (val == '') continue;

                // resolve dept
                if (!dept_map[val]) {
                    //try to resolve it
                    for (key in dept_map) {
                        if (dept_map[key]['name'].toLowerCase() == val.toLowerCase()) {
                            val = key;
                            break;
                        }
                    }
                }
                depts.push(val);
            }

            queries['department'] = depts;
        }
        else if (form_params[key]['name'] == 'description' && form_params[key]['value'] != '') {
            var val = form_params[key]['value'];
            splits = val.split(' ');
            words = [];
            for (s in splits) {
                if (splits[s] != '')
                    words.push(splits[s]);
            }
            queries['description'] = words;
        }
        /*
        else if (form_params[key]['name'] == 'Professors' && form_params[key]['value'] != '') {
            var val = form_params[key]['value'];
            splits = val.split(' ');
            joinme = [];
            for (s in splits) {
                if (splits[s] != '')
                    joinme.push(splits[s]);
            }
            val = joinme.join(' AND ');

            i = {}; //hash needs to be built at runtime
            i['Professors'] = val;
            queries.push({
                "field": i
            });
        }
        else if (form_params[key]['name'] == 'title' && form_params[key]['value'] != '') {
            var val = form_params[key]['value'];
            splits = val.split(' ');
            joinme = [];
            for (s in splits) {
                if (splits[s] != '')
                    joinme.push(splits[s]);
            }
            val = joinme.join(' AND ');

            i = {}; //hash needs to be built at runtime
            i['title'] = val;
            queries.push({
                "field": i
            });
        }
        else if (form_params[key]['name'] == 'Number' && form_params[key]['value'] != '') {
            var val = parseInt(form_params[key]['value']);
            if (isNaN(val))
                continue;

            // course numbers are length 3, padded by 0s
            var pad = val+'';
            while (pad.length < 3) {
                pad = '0'+pad;
            }

            i = {}; //hash needs to be built at runtime
            i['Number'] = pad;
            queries.push({
                "field": i
            });
        }
        else if (form_params[key]['name'] == 'avg_median' && form_params[key]['value'] != '') {
            var val = parseFloat(form_params[key]['value']);
            i = {}; //hash needs to be built at runtime
            i['avg_median'] = pad;
            // http://www.elasticsearch.org/guide/reference/query-dsl/range-query.html
            queries.push({
                    "range": {
                        "avg_median": {
                            "from": val,
                            "to": 5
                        }
                    }
            });
        }
        else if (form_params[key]['name'] == 'criteria') {
            continue;
        } else if (form_params[key]['name'].substring(0, 7) == 'period_') {
            // grab the period param
            if (form_params[key]['value'] == '1') {
                periods.push(form_params[key]['name'].substring(7));
            }
        } else if (form_params[key]['name'].substring(0, 8) == 'distrib_') {
            // grab the distrib param
            if (form_params[key]['value'] == '1') {
                distribs.push(form_params[key]['name'].substring(8));
            }
        }  else if(form_params[key]['value'] && form_params[key]['value'] != ''){
            i = {}; //hash needs to be built at runtime
            i[form_params[key]['name']] = form_params[key]['value'];
            queries.push({
                "field": i
            });
        }
        */
    }

    if (periods.length > 0) {
    	i = {
            "field": {
                "period": periods.join(' ')
            }
       };
        queries.push(i);
    }
    if (distribs.length > 0) {
    	i = {
            "field": {
                "dist": distribs.join(' ')
            }
       };
        queries.push(i);
    }
    search_params = {
        "queries": queries
    };
    //console.log(JSON.stringify(search_params));
    $('#results_container').html('<h1>Loading...</h1>');
    $.ajax({
        dataType: "json",
        type: "GET",
        url: search_query_url,
        //when we're ready to query the new database, uncomment the below
        //url: search_query_url,
        data: search_params,
        success: function (data) {
            //console.log(JSON.stringify(data));
            show_results(data);
        },
        error: function (e) {
            show_error(e);
        }
    });
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
    'time': {
        'long_name': 'Meeting Time',
        'input_field': generate_input_field_time()
    },
    'term': {
        'long_name': 'Quarter',
        'input_field': generate_input_field_quarter()
    },
    'dist': {
        'long_name': 'Distrib',
        'input_field': generate_input_field_distrib()
    },
    'wc': {
        'long_name': 'World Culture',
        'input_field': '\
<select name="wc"><option value="W">W</option><option value="NW">NW</option><option value="CI">CI</option></select>'
    },
    'nro': {
        'long_name': 'Can NRO?',
        'input_field': '<input type="checkbox" name="nro" value="true" checked="checked"/>Heck Yeah'
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
        $('#results_container').html('<h1><a href="http://getfirefox.com">Get Firefox</a> or <a href="http://google.com/chrome">Get Chrome</a></h1>');
        alert("Course picker isn't written for Internet Explorer and may not work correctly.");
    }

    search_params = {
        "size": 9000
    };

    // prof and title autocomplete
    $.ajax({
        dataType: "json",
        type: "POST",
        url: query_url,
        data: JSON.stringify(search_params),
        success: function (data) {
            data = data['hits']['hits'];
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
    row1.find("select option[value='term']").attr('selected', 'selected');
    row1.find("select").change();

    //show_favorites();
    $("form#search_form input[type='submit']").click(function () {
    	try{
            the_form = $('#search_form');
            form_params = the_form.serializeArray();
            do_search(form_params);
        }catch(e){
        	console.log(e.message)
        }
        return false;
    });


    // bind sort by preferences
    $("input:radio[name=sortby]").change(function() {
            sortby = $(this).val();
            if (last_result) {
                $('#results_container').html('Loading...');
                show_results(last_result);
            }
    });

    // if they already have a search encoded in the URL, execute it
    if(window.location.hash){
        the_params = JSON.parse(window.location.hash);
        do_search(the_params);
    }
});
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
