// Dropdown Menu Plugin
// ddsmoothmenu.init({
// 	mainmenuid: "menu", //menu DIV id
// 	orientation: 'h', //Horizontal or vertical menu: Set to "h" or "v"
// 	classname: 'ddsmoothmenu', //class added to menu's outer DIV
// 	contentsource: "markup" //"markup" or ["container_id", "path_to_menu_file"]
// })

jQuery(document).ready(function(){

	// Cufon Font Load
	//Cufon.replace('h1, h2, h3, h4', { fontFamily: 'FrancophilSans', hover: false, color: '-linear-gradient(#ffffff, #bababa)' });	// Only for dark theme color
	Cufon.replace('h1, h2, h3, h4', { fontFamily: 'FrancophilSans', hover: false, color: '-linear-gradient(#727171, #020202)' });	// Only for light theme color
	Cufon.replace('.big_btn', { fontFamily: 'FrancophilSans', hover: true });
	Cufon.replace('#fsb h3', { fontFamily: 'FrancophilSans', hover: true, textShadow: '1px 1px rgba(0, 0, 0, 0.8)', color: '-linear-gradient(#FCFCFC, #B8B8B8)' });
	Cufon.replace('#fsb h4, .gallery h4, .partners h4, .header_full h2, .header_full h3, .overview h4', { fontFamily: 'FrancophilSans', hover: true, color: '-linear-gradient(#ffffff, #bababa)' });

	// Fluid Menu
	if (jQuery(".ddsmoothmenu").length) {
		jQuery('.ddsmoothmenu li').click(function(){
			var url = jQuery(this).find('a').attr('href');
			document.location.href = url;
		});
		jQuery('.ddsmoothmenu li').hover(function(){
			jQuery(this).find('.menuslide').slideDown();
		},
		function(){
			jQuery(this).find('.menuslide').slideUp();
		});
	}

	// *************************************** Images ******************************************************//
	
	//Horizontal Sliding
	if (jQuery(".gallery_item").length) {
		jQuery('.gallery_item').hover(function(){
			jQuery(".cover", this).stop().animate({left:'214px'},{queue:false,duration:250});
		}, function() {
			jQuery(".cover", this).stop().animate({left:'0px'},{queue:false,duration:900});
		});
	}
	
	// find the div.fade elements and hook the hover event
	if (jQuery(".portfolio_thumb").length) {
		jQuery('.portfolio_thumb a').hover(function() {
			// on hovering over find the element we want to fade *up*
			var fade = jQuery('> .hover_img, > .hover_vid', this);
			// if the element is currently being animated (to fadeOut)...
			if (fade.is('img')) {
				// ...stop the current animation, and fade it to 1 from current position
				fade.stop().fadeTo(300, 1);
			} else {
				fade.fadeIn(300);
			}
		}, function () {
			var fade = jQuery('> .hover_img, > .hover_vid', this);
			if (fade.is('img')) {
				fade.stop().fadeTo(300, 0);
			} else {
				fade.fadeOut(300);
			}
		});

		// get rid of the text
		jQuery('.portfolio_thumb a > .hover_img, .portfolio_thumb a > .hover_img').empty();
	}
	
	// Partners Page
	if (jQuery(".partner_item").length) {
		//move the image in pixel
		var move = -15;
		//zoom percentage, 1.2 =120%
		var zoom = 1.2;
		//On mouse over those thumbnail
		jQuery('.partner_item').hover(function() {
			
			//Set the width and height according to the zoom percentage
			width = jQuery('.partner_item').width() * zoom;
			height = jQuery('.partner_item').height() * zoom;
			
			//Move and zoom the image
			jQuery(this).find('img').stop(false,true).animate({'width':width, 'height':height, 'top':move, 'left':move}, {duration:200});
			
			//Display the caption
			jQuery(this).find('div.caption').css({"visibility":"visible",opacity:0.8});
		},
		function() {
			//Reset the image
			jQuery(this).find('img').stop(false,true).animate({'width':jQuery('.partner_item').width(), 'height':jQuery('.partner_item').height(), 'top':'0', 'left':'0'}, {duration:100});	
	
			//Hide the caption
			jQuery(this).find('div.caption').css({"visibility":"hidden",opacity:0});
		});
	}
	
		// *************************************** Shortcodes ******************************************************//

	// jQuery Toggle
	if (jQuery(".toggle_container").length) {
		jQuery(".toggle_container").hide(); //Hide (Collapse) the toggle containers on load
		//Switch the "Open" and "Close" state per click then slide up/down (depending on open/close state)
		jQuery("b.trigger").click(function(){
			jQuery(this).toggleClass("active").next().slideToggle("slow");
			return false; //Prevent the browser jump to the link anchor
		});
	}

	// jQuery Accordion
	if (jQuery(".acc_container").length) {
		//Set default open/close settings
		jQuery('.acc_container').hide(); //Hide/close all containers
		jQuery('.acc_trigger:first').addClass('active').next().show(); //Add "active" class to first trigger, then show/open the immediate next container
		
		//On Click
		jQuery('.acc_trigger').click(function(){
			if( jQuery(this).next().is(':hidden') ) { //If immediate next container is closed...
				jQuery('.acc_trigger').removeClass('active').next().slideUp(); //Remove all "active" state and slide up the immediate next container
				jQuery(this).toggleClass('active').next().slideDown(); //Add "active" state to clicked trigger and slide down the immediate next container
			}
			return false; //Prevent the browser jump to the link anchor
		});
	}

	// jQuery Tabs
	if (jQuery(".tab_content").length) {
		//When page loads...
		jQuery(".tab_content").hide(); //Hide all content
		jQuery("ul.tabs li:first").addClass("active").show(); //Activate first tab
		jQuery(".tab_content:first").show(); //Show first tab content
	
		//On Click Event
		jQuery("ul.tabs li").click(function() {
	
			jQuery("ul.tabs li").removeClass("active"); //Remove any "active" class
			jQuery(this).addClass("active"); //Add "active" class to selected tab
			jQuery(".tab_content").hide(); //Hide all tab content
	
			var activeTab = jQuery(this).find("a").attr("href"); //Find the href attribute value to identify the active tab + content
			jQuery(activeTab).fadeIn(); //Fade in the active ID content
			return false;
		});
	}

	// Sliding menu items in sidebar
	if (jQuery("#sidebar").length) {
		slide("#sidebar .widget_categories", 10, 0, 150, .8);
		slide("#sidebar .widget_archive", 10, 0, 150, .8);
		slide("#sidebar .widget_nav_menu", 10, 0, 150, .8);
		slide("#sidebar .widget_links", 10, 0, 150, .8);
		slide("#sidebar .widget_recent_entries", 10, 0, 150, .8);
		slide("#sidebar .widget_recent_comments", 10, 0, 150, .8);
	}
	
	// go to top scroll effect
	if (jQuery(".gototop").length) {
		jQuery.localScroll();
	}
	
	// tabbed widget
	if (jQuery(".widget_tabbed").length) {
		jQuery(".widget_tabbed").tabs({ fx: { height: 'toggle', opacity: 'toggle' } });
	}
	
	// jQuery data-rel to rel
	if (jQuery("a[data-rel]").length) {
		jQuery('a[data-rel]').each(function() {jQuery(this).attr('rel', jQuery(this).data('rel'));});
	}
	
	// PrettyPhoto
	if (jQuery().prettyPhoto) {
		pp_lightbox(); 
	}

});

jQuery(function(){
		
	// jQuery tipsy
	if (jQuery(".social").length) {
		jQuery('.social a').tipsy(
		{
			gravity: 's', // nw | n | ne | w | e | sw | s | se
			fade: true
		});
	}

	// jQuery Watermark Plugin
	if (jQuery(".widget_search").length) {
		jQuery('input[name="s"]').each(function() {
			jQuery(this).Watermark("Enter keywords");
		});
	}
	
	// jQuery Uniform Plugin
	if (jQuery("select, input:checkbox, input:radio").length) {
		jQuery("select, input:checkbox, input:radio").uniform();
	}
	
});

// *************************************** Functions ******************************************************//

function slide(navigation_id, pad_out, pad_in, time, multiplier)
{
	// creates the target paths
	var list_elements = navigation_id + " li";
	var link_elements = list_elements + " a";
	
	// initiates the timer used for the sliding animation
	var timer = 0;
	
	// creates the slide animation for all list elements 
	jQuery(list_elements).each(function(i)
	{
		// margin left = - ([width of element] + [total vertical padding of element])
		jQuery(this).css("margin-left","-15px");
		// updates timer
		timer = (timer*multiplier + time);
		jQuery(this).animate({ marginLeft: "0" }, timer);
		jQuery(this).animate({ marginLeft: "15px" }, timer);
		jQuery(this).animate({ marginLeft: "0" }, timer);
	});

	// creates the hover-slide effect for all link elements 		
	jQuery(link_elements).each(function(i)
	{
		jQuery(this).hover(
		function()
		{
			jQuery(this).animate({ paddingLeft: pad_out }, 150);
		},		
		function()
		{
			jQuery(this).animate({ paddingLeft: pad_in }, 150);
		});
	});
}

// PrettyPhoto
function pp_lightbox() {
	jQuery("a[rel^='prettyPhoto']").prettyPhoto({
		animation_speed: 'normal', /* fast/slow/normal */
		opacity: 0.70, /* Value between 0 and 1 */
		show_title: true, /* true/false */
		allow_resize: true, /* true/false */
		counter_separator_label: '/', /* The separator for the gallery counter 1 "of" 2 */
		theme: 'pp_default', /* light_rounded / dark_rounded / light_square / dark_square / facebook */
		overlay_gallery: true, /* display or hide the thumbnails on a lightbox when it opened */
		deeplinking: false,
		social_tools: false /* html or false to disable */
	});
}

// iPhone & iPad fix
function imageresize() {
	var contentwidth = $('body').width();
	if ((contentwidth) < '981'){
		jQuery('#sp .content_wrapper, #sp .content_wrapper_sbr, #sp .content_wrapper_sbl').css('background','url(images/subpage_content_bg_dark_ipad.png) 0 0 no-repeat');
		jQuery('#sp .content_wrapper, #sp .content_wrapper_sbr, #sp .content_wrapper_sbl').css('margin','-82px auto 0');
		jQuery('#sp .content_wrapper, #sp .content_wrapper_sbr, #sp .content_wrapper_sbl').css('padding','20px 10px');
		jQuery('#fsb').css('padding','4.5em 10px');
		jQuery('#fsb').css('width','940px');
		jQuery('#footer').css('padding','30px 10px');
		jQuery('#footer').css('width','940px');
	} else {}
	}

	imageresize();//Triggers when document first loads    
	jQuery(window).bind("resize", function(){//Adjusts image when browser resized
		imageresize();
	});