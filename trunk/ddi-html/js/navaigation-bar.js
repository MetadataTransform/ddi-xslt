$(document).ready(function(){

    $('<div id="navigration">\n\
        <input class="filter" name="livefilter" type="text" placeholder="filter" />\n\
        <div id="question-list-wrapper">\n\
            <ul id="question-list"></ul>\n\
        </div>\n\
        <div id="variable-list-wrapper">\n\
            <ul id="variable-list"></ul>\n\
        </div>\n\
       </div>').insertBefore('#study');
    pupulateVariableList();
});

function pupulateVariableList(){
    var container = $("#variable-list");
    $('.variableScheme .variables').each(function(index, variableScheme) {
        console.log('variableScheme '+variableScheme);
        $(variableScheme).children().each(function(i, variable){
            console.log('variable '+$(variable).children('.label').text());
            var name  = $(variable).children('.variableName').text();
            var label =  $(variable).children('.label').text();
            var href = $(variable).children('a').attr('name')
            
            $(container).append('<li><a href="#'+href+'"><strong class="variableName">'+name+'</strong><span class="variablel-label">'+label+'</span></a></li>');
            
        });
    });
    
    $('#study').css('margin-left', $('#navigration').width());
    $('#variable-list-wrapper').liveFilter('ul');
}

/***** [plugins] ****/

/***********************************************************/
/*                    LiveFilter Plugin                    */
/*                      Version: 1.1                       */
/*                      Mike Merritt                       */
/*             	    Updated: Feb 2nd, 2010                 */
/***********************************************************/

(function($){  
	$.fn.liveFilter = function (wrapper) {
		
		// Grabs the id of the element containing the filter
		var wrap = '#' + $(this).attr('id');
		
		// Make sure we're looking in the correct sub-element
		if (wrapper == 'table') {
			var item = 'tr';
		} else {
			var item = 'li';
		}
		
		// Listen for the value of the input to change
		$('input.filter').keyup(function() {
			var filter = $(this).val();
			
			// Hide all the items and then show only the ones matching the filter
			$(wrap + ' ' + wrapper + ' ' + item).hide();
			
			if (wrapper == 'table') {
				$(wrap + ' ' + wrapper + ' ' + 'tr.header').show();
			}
			$(wrap + ' ' + wrapper + ' ' + item + ':Contains("' + filter + '")').show();
			
		});
		
		// Custom expression for case insensitive contains()
		jQuery.expr[':'].Contains = function(a,i,m){
		    return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase())>=0;
		};

	}

})(jQuery);