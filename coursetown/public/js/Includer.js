// overload jquery's onDomReady
if ( jQuery.browser.mozilla || jQuery.browser.opera ) {
        document.removeEventListener( "DOMContentLoaded", jQuery.ready, false );
        document.addEventListener( "DOMContentLoaded", function(){ jQuery.ready(); }, false );
}
jQuery.event.remove( window, "load", jQuery.ready );
jQuery.event.add( window, "load", function(){ jQuery.ready(); } );
jQuery.extend({
        includeStates: {},
        include: function(url, callback, dependency){
                if ( typeof callback != 'function' && ! dependency ) {
                        dependency = callback;
                        callback = null;
                }
                url = url.replace('\n', '');
                jQuery.includeStates[url] = false;
                var script = document.createElement('script');
                script.type = 'text/javascript';
                script.onload = function () {
                        jQuery.includeStates[url] = true;
                        if ( callback )
                                callback.call(script);
                };
                script.onreadystatechange = function () {
                        if ( this.readyState != "complete" && this.readyState != "loaded" ) return;
                        jQuery.includeStates[url] = true;
                        if ( callback )
                                callback.call(script);
                };
                script.src = url;
                if ( dependency ) {
                        if ( dependency.constructor != Array )
                                dependency = [dependency];
                        setTimeout(function(){
                                var valid = true;
                                $.each(dependency, function(k, v){
                                        if (! v() ) {
                                                valid = false;
                                                return false;
                                        }
                                })
                                if ( valid )
                                        document.getElementsByTagName('head')[0].appendChild(script);
                                else
                                        setTimeout(arguments.callee, 10);
                        }, 10);
                }
                else
                        document.getElementsByTagName('head')[0].appendChild(script);
                return function(){
                        return jQuery.includeStates[url];
                }
        },
        readyOld: jQuery.ready,
        ready: function () {
                if (jQuery.isReady) return;
                imReady = true;
                $.each(jQuery.includeStates, function(url, state) {
                        if (! state)
                                return imReady = false;
                });
                if (imReady) {
                        jQuery.readyOld.apply(jQuery, arguments);
                } else {
                        setTimeout(arguments.callee, 10);
                }
        }
});

///// include js files ////////////
$.include('/js/cufon/FrancophilSans_500-FrancophilSans_700.font.js');
$.include('/js/jquery.easing.1.3.js');

	// Dropdown Menu Plugin
	if (jQuery(".ddsmoothmenu").length) {
		$.include('/js/ddsmoothmenu.js');
	}

	// jQuery flexible columns
	if (jQuery("#fsb, .column").length) {
		$.include('/js/jquery.flexibleColumns.min.js');
		jQuery(function(){
			jQuery("#fsb").autoColumn(50, ".widget-container");
			jQuery("#fsb").autoHeight(".widget-container");
			
			jQuery(".columns").autoColumn(50, ".column");
			jQuery(".columns").autoHeight(".column");
			
			jQuery(".columns2").autoColumn(50, ".column");
			jQuery(".columns2").autoHeight(".column");
			
			jQuery(".columns3").autoColumn(33, ".column");
			jQuery(".columns3").autoHeight(".column");
			
			jQuery(".columns4").autoColumn(33, ".column");
			jQuery(".columns4").autoHeight(".column");
			
			jQuery(".columns5").autoColumn(33, ".column");
			jQuery(".columns5").autoHeight(".column");
			
			jQuery(".columns6").autoColumn(33, ".column");
			jQuery(".columns6").autoHeight(".column");
			
			jQuery(".columns7").autoColumn(33, ".column");
			jQuery(".columns7").autoHeight(".column");
			
			jQuery(".columns8").autoColumn(33, ".column");
			jQuery(".columns8").autoHeight(".column");
			
			jQuery(".columns9").autoColumn(33, ".column");
			jQuery(".columns9").autoHeight(".column");
			
			jQuery(".columns10").autoColumn(33, ".column");
			jQuery(".columns10").autoHeight(".column");
			
			jQuery(".columns11").autoColumn(33, ".column");
			jQuery(".columns11").autoHeight(".column");
			
			jQuery(".columns12").autoColumn(33, ".column");
			jQuery(".columns12").autoHeight(".column");
			
			jQuery(".columns13").autoColumn(33, ".column");
			jQuery(".columns13").autoHeight(".column");
			
			jQuery(".columns14").autoColumn(33, ".column");
			jQuery(".columns14").autoHeight(".column");
			
			jQuery(".columns15").autoColumn(33, ".column");
			jQuery(".columns15").autoHeight(".column");
			
			jQuery(".columns16").autoColumn(33, ".column");
			jQuery(".columns16").autoHeight(".column");
		
		});
	}

// ========================================= Sliders ===================================================

	// jQuery Accordion
	if (jQuery("#accordion").length) {
		$.include('sliders/accordion-slider/jquery.elegantAccordion.js');
		jQuery(document).ready(function(){
			jQuery('#accordion').eAccordion ({
				easing: 'swing',                // Anything other than "linear" or "swing" requires the easing plugin
				autoPlay: true,                 // This turns off the entire FUNCTIONALY, not just if it starts running or not
				startStopped: false,            // If autoPlay is on, this can force it to start stopped
				stopAtEnd: false,				// If autoplay is on, it will stop when it reaches the last slide
				delay: 3000,                    // How long between slide transitions in AutoPlay mode
				animationTime: 600,             // How long the slide transition takes
				hashTags: true,                 // Should links change the hashtag in the URL?
				pauseOnHover: true,             // If true, and autoPlay is enabled, the show will pause on hover
				width: null,					// Override the default CSS width
				height: null,					// Override the default CSS height
				expandedWidth: '422px'			// Width of the expanded slide
			});
		});
	}

	// jQuery Nivo Slider
	if (jQuery("#nivo-slider").length) {
		$.include('sliders/nivo-slider/jquery.nivo.slider.js');
		jQuery(document).ready(function(){
			jQuery('#nivo-slider').nivoSlider({
				effect:'random', //Specify sets like: 'fold,fade,sliceDown'
				slices:40,
				animSpeed:600,
				pauseTime:3000,
				directionNav:true, //Next and Prev
				directionNavHide:false,
				controlNav:true //1,2,3...
			});
		});
	}

	// jQuery Coin Slider
	if (jQuery("#coin-slider").length) {
		$.include('sliders/coin-slider/coin-slider.js');
		jQuery(document).ready(function(){
			jQuery('#coin-slider').coinslider({
				width: 952, // width of slider panel
				height: 392, // height of slider panel
				spw: 10, // squares per width
				sph: 5, // squares per height
				delay: 3000, // delay between images in ms
				sDelay: 30, // delay beetwen squares in ms
				opacity: 1, // opacity of title and navigation
				titleSpeed: 500, // speed of title appereance in ms
				effect: 'random', // random, swirl, rain, straight
				navigation: true, // prev next and buttons
				links : true, // show images as links 
				hoverPause: true // pause on hover
			});
		});
	}

	// jQuery Anything Slider
	if (jQuery("#anything").length) {
		$.include('sliders/anything-slider/jquery.anythingslider.js');
		jQuery(document).ready(function(){
			jQuery('#anything')
			  .anythingSlider({
			   width        : 952,
			   height       : 392,
			   startStopped : true
			  })
			  /* this code will make the caption appear when you hover over the panel
				remove the extra statements if you don't have captions in that location */
			  .find('.panel')
				.find('div[class*=caption]').css({ position: 'absolute' }).end()
				.hover(function(){ showCaptions( jQuery(this) ) }, function(){ hideCaptions( jQuery(this) ); });
			
			  showCaptions = function(el){
				var $this = el;
				if ($this.find('.caption-top').length) {
				  $this.find('.caption-top')
					.show()
					.animate({ top: 10, opacity: 0.8 }, 400);
				}
				if ($this.find('.caption-right').length) {
				  $this.find('.caption-right')
					.show()
					.animate({ right: 10, opacity: 0.8 }, 400);
				}
				if ($this.find('.caption-bottom').length) {
				  $this.find('.caption-bottom')
					.show()
					.animate({ bottom: 10, opacity: 0.8 }, 400);
				}
				if ($this.find('.caption-left').length) {
				  $this.find('.caption-left')
					.show()
					.animate({ left: 10, opacity: 0.8 }, 400);
				}
			  };
			  hideCaptions = function(el){
				var $this = el;
				if ($this.find('.caption-top').length) {
				  $this.find('.caption-top')
					.stop()
					.animate({ top: -50, opacity: 0 }, 350, function(){
					  $this.find('.caption-top').hide(); }); 
				}
				if ($this.find('.caption-right').length) {
				  $this.find('.caption-right')
					.stop()
					.animate({ right: -200, opacity: 0 }, 350, function(){
					  $this.find('.caption-right').hide(); });
				}
				if ($this.find('.caption-bottom').length) {
				  $this.find('.caption-bottom')
					.stop()
					.animate({ bottom: -50, opacity: 0 }, 350, function(){
					  $this.find('.caption-bottom').hide(); });
				}
				if ($this.find('.caption-left').length) {
				  $this.find('.caption-left')
					.stop()
					.animate({ left: -200, opacity: 0 }, 350, function(){
					  $this.find('.caption-left').hide(); });
				}
			  };
			
			  // hide all captions initially
			  hideCaptions( jQuery('#anything .panel') );
		});
	}

	// 3D Piecemaker Slider
	if (jQuery("#piecemaker").length) {
      $.include('piecemaker/scripts/swfobject/swfobject.js');
		jQuery(document).ready(function(){
			var flashvars = {};
			flashvars.cssSource = "piecemaker/piecemaker.css";
			flashvars.xmlSource = "piecemaker/piecemaker.xml";
			var params = {};
			params.play = "true";
			params.menu = "false";
			params.scale = "showall";
			params.wmode = "transparent";
			params.allowfullscreen = "true";
			params.allowscriptaccess = "always";
			params.allownetworking = "all";

			swfobject.embedSWF('piecemaker/piecemaker.swf', 'piecemaker', '1000', '600', '10', null, flashvars,    
			params, null);
		});
	}

	// jQuery Orbit Slider
	if (jQuery("#orbit-slider").length) {
		$.include('sliders/orbit-slider/jquery.orbit.js');
		jQuery(document).ready(function(){
			jQuery('#orbit-slider').orbit({
				 animation: 'fade',                 // fade, horizontal-slide, vertical-slide, horizontal-push
				 animationSpeed: 800,               // how fast animtions are
				 timer: true, 			 			// true or false to have the timer
				 advanceSpeed: 4000, 				// if timer is enabled, time between transitions 
				 pauseOnHover: false, 				// if you hover pauses the slider
				 startClockOnMouseOut: false,		// if clock should start on MouseOut
				 startClockOnMouseOutAfter: 1000,	// how long after MouseOut should the timer start again
				 directionalNav: true,				// manual advancing directional navs
				 captions: true,					// do you want captions?
				 captionAnimation: 'fade',			// fade, slideOpen, none
				 captionAnimationSpeed: 800,		// if so how quickly should they animate in
				 bullets: true,						// true or false to activate the bullet navigation
				 bulletThumbs: true,				// thumbnails for the bullets
				 bulletThumbLocation: 'sliders/orbit-slider/orbit/',		// location from this file where thumbs will be
				 afterSlideChange: function(){}		// empty function 
			});
			
		});
	}

	// jQuery Serie3 Slider
	if (jQuery("#s3slider").length) {
		$.include('sliders/serie3-slider/s3Slider.js');
		jQuery(document).ready(function(){
			jQuery('#s3slider').s3Slider({
				timeOut: 3000
			});
		});
	}

	// jQuery Roundabout Plugin
	if (jQuery("#roundabout").length) {
		$.include('sliders/roundabout-slider/jquery.roundabout.js');
		$.include('sliders/roundabout-slider/jquery.roundabout-shapes.min.js');
		jQuery(document).ready(function(){
			jQuery('#roundabout ul').roundabout({
				bearing: 0.0, // The starting direction in which the Roundabout should point.
				tilt: 0.0, // The starting angle at which the Roundabout’s plane should be tipped.
				minZ: 80, // The lowest z-index value that a moveable item can be assigned. (Will be the z-index of the item farthest from the focusBearing.)
				maxZ: 100, // The greatest z-index value that a moveable item can be assigned. (Will be the z-index of the item in focus.)
				minOpacity: 0.7, // The lowest opacity value that a moveable item can be assigned. (Will be the opacity of the item farthest from the focus bearing.)
				maxOpacity: 1.0, // The greatest opacity value that a moveable item can be assigned. (Will be the opacity of the item in focus.)
				minScale: 0.4, // The lowest percentage of font-size that a moveable item can be assigned. (Will be the scale of the item farthest from the focus bearing.)
				maxScale: 1.3, // The greatest percentage of font-size that a moveable item can be assigned. (Will be the scale of the item in focus.)
				duration: 800, // The length of time (in milliseconds) that all animations take to complete by default.
				easing: 'easeOutExpo', // The easing method to be used for animations by default. jQuery comes with “linear” and “swing,” although any of the jQuery Easing plugin’s values can be used if the easing plugin is included.
				clickToFocus: true, // When an item is not in focus, should it be brought into focus via an animation? If true, will disable any click events on elements within the moving element that was clicked. Once the element is in focus, click events will no longer be blocked.
				focusBearing: 0.0, // The bearing at which a moving item’s position must match on the Roundabout to be considered “in focus.”
				shape: 'square', // For use with the Roundabout Shapes plugin. Sets the shape of the path over which moveable items will travel.
				childSelector: 'li', // Changes the set of elements Roundabout will look for within the holding element for moving.
				startingChild: 6, // Starts a given child at the focus of the Roundabout. This is a zero-based number positioned in order of appearance in the HTML file.
				reflect: false // Setting to true causes the elements to be placed around the Roundabout in reverse order. Also flips the direction of “next” and ”previous” buttons. 
			});
		});
	}

	// jQuery Cycle
	if (jQuery(".widget_recent_projects").length) {
		$.include('/js/jquery.cycle.all.min.js');
		jQuery(function(){
			jQuery('.widget_recent_projects ul').cycle({
				fx: 'scrollLeft',
				timeout: 5000,
				delay: -1000
			});
		});
	}

	// jQuery PrettyPhoto
	if (jQuery("a[data-rel^='prettyPhoto']").length) {
		$.include('/js/jquery.prettyPhoto.js');
	}

	// jQuery Tinycarousel
	if (jQuery("#slider-code").length) {
		$.include('/js/jquery.tinycarousel.js');
		jQuery(document).ready(function(){
			jQuery.fn.showFeatureText = function() {
			  return this.each(function(){    
				var box = jQuery(this);
				var text = jQuery('h4',this);    
			
				text.css({ position: 'absolute', bottom: '0px' }).hide();
			
				box.hover(function(){
				  text.slideDown("fast");
				},function(){
				  text.slideUp("fast");
				});
			
			  });
			}
				
			// jQuery text slide up / slide down effect
			jQuery('#slider-code .overview li').showFeatureText();
			
			// jQuery Tinycarousel
			jQuery('#slider-code').tinycarousel({
				start: 2, // where should the carousel start?
				display: 4, // how many blocks do you want to move at 1 time?
				axis: 'x', // vertical or horizontal scroller? ( x || y ).
				controls: true, // show left and right navigation buttons.
				pager: false, // is there a page number navigation present?
				interval: false, // move to another block on intervals.
				intervaltime: 3000, // interval time in milliseconds.
				rewind: false, // If interval is true and rewind is true it will play in reverse if the last slide is reached.
				animation: true, // false is instant, true is animate.
				duration: 1000, // how fast must the animation move in ms?
				callback: null // function that executes after every move
			});
		});
	}

	// jQuery tipsy
	if (jQuery(".social").length) {
		$.include('/js/jquery.tipsy.js');
	}

	// jQuery Watermark Plugin
	if (jQuery(".widget_search").length) {
		$.include('/js/jquery.watermarkinput.js');
	}

	if (jQuery(".gototop").length) {
		$.include('/js/jquery.localscroll-min.js');
		$.include('/js/jquery.scrollTo-min.js');
	}
	
	// Contact Form Plugin
	if (jQuery("#contact").length) {
		$.include('/js/jquery.jigowatt.js');
	}

	// jQuery Uniform Plugin
	if (jQuery("select, input:checkbox, input:radio").length) {
		$.include('/js/jquery.uniform.min.js');
	}

	// jQuery Roundabout Plugin for portfolio page
	if (jQuery(".portfolio_rotator").length) {
		$.include('sliders/roundabout-slider/jquery.roundabout.js');
		$.include('sliders/roundabout-slider/jquery.roundabout-shapes.min.js');
		jQuery(document).ready(function(){
			jQuery('.portfolio_rotator ul').roundabout({
				bearing: 0.0,			// The starting direction in which the Roundabout should point.
				tilt: 0.0,				// The starting angle at which the Roundabout’s plane should be tipped.
				minZ: 10,				// The lowest z-index value that a moveable item can be assigned. (Will be the z-index of the item farthest from the focusBearing.)
				maxZ: 100,				// The greatest z-index value that a moveable item can be assigned. (Will be the z-index of the item in focus.)
				minOpacity: 0.3,		// The lowest opacity value that a moveable item can be assigned. (Will be the opacity of the item farthest from the focus bearing.)
				maxOpacity: 1.0,		// The greatest opacity value that a moveable item can be assigned. (Will be the opacity of the item in focus.)
				minScale: 0.6,			// The lowest percentage of font-size that a moveable item can be assigned. (Will be the scale of the item farthest from the focus bearing.)
				maxScale: 1.0,			// The greatest percentage of font-size that a moveable item can be assigned. (Will be the scale of the item in focus.)
				duration: 600,			// The length of time (in milliseconds) that all animations take to complete by default.
				btnNext: null,			// A jQuery selector of elements that will have a click event assigned to them. On click, the Roundabout will move to the next child (counterclockwise).
				btnPrev: null,			// A jQuery selector of elements that will have a click event assigned to them. On click, the Roundabout will move to the previous child (clockwise).
				easing: 'swing',		// The easing method to be used for animations by default. jQuery comes with “linear” and “swing,” although any of the jQuery Easing plugin’s values can be used if the easing plugin is included.
				clickToFocus: true,		// When an item is not in focus, should it be brought into focus via an animation? If true, will disable any click events on elements within the moving element that was clicked. Once the element is in focus, click events will no longer be blocked.
				focusBearing: 0.0,		// The bearing at which a moving item’s position must match on the Roundabout to be considered “in focus.”
				shape: 'waterWheel',	// For use with the Roundabout Shapes plugin. Sets the shape of the path over which moveable items will travel.
				debug: false,			// Changes the HTML within moving elements into a list of information about that element. Helpful for advanced configurations.
				childSelector: 'li',	// Changes the set of elements Roundabout will look for within the holding element for moving.
				startingChild: 0,		// Starts a given child at the focus of the Roundabout. This is a zero-based number positioned in order of appearance in the HTML file.
				reflect: false			// Setting to true causes the elements to be placed around the Roundabout in reverse order. Also flips the direction of “next” and ”previous” buttons. 
			});
		});
	}

	// Scripts Initials
	if (jQuery("body").length) {
		$.include('/js/common.js');
	}
