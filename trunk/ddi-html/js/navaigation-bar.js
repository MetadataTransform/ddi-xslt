$(document).ready(function(){

    $('<div id="navigration">\n\
        <input class="filter" name="livefilter" type="text" placeholder="filter" />\n\
        <div class="tabs">\n\
            <ul class="tabNavigation">\n\
                <li class="option variables" id="tab2" tab="#variable-list-wrapper">Variables</li>\n\
                <li class="option questions" id="tab3" tab="#question-list-wrapper">Questions</li>\n\
            </ul>\n\
        </div>\n\
        <div id="variable-list-wrapper" class="tab-content hide">\n\
            <span class="count"></span>\n\
            <ul id="variable-list"></ul>\n\
        </div>\n\
        <div id="question-list-wrapper" class="tab-content hide">\n\
            <span class="count"></span>\n\
            <ul id="question-list"></ul>\n\
        </div>\n\
       </div>').insertBefore('#study');
    
    menuTabs();
    pupulateVariableList();
    pupulateVariableQuestionList();
    
    if($("#question-list li").length == 0){
        pupulateQuestionList();
    }
    
    $('.filter').keyup(function(e){
        var total   = $('#variable-list li').length;
        var hidden  = $('#variable-list li:hidden').length;
        $('#variable-list-wrapper .count').html((total-hidden)+'/'+total+' '+'variables');        
        
        total   = $('#question-list li').length;
        hidden  = $('#question-list li:hidden').length;
        $('#question-list-wrapper .count').html((total-hidden)+'/'+total+' '+'questions');
    });    
    
    $('#navigration').css('width', '15%');
    $('#study').css('margin-left', $('#navigration').width());
    
});

function menuTabs(){
	/* Default active tab */
	activeTab = "#tab1"
	activeTabContent = "#variable-list-wrapper";

	$(".option").click(function(){	
            deactivatedTab = "#" + $(this).attr('id');
            deactivatedTabContent = $(deactivatedTab).attr('tab');
		
	    id= $(this).attr('tab');
		
            /* Deactivate current tab using css */
            $(activeTab).removeClass('active');
            $(activeTabContent).addClass('hide');

            /* Activate tab that was clicked on */
            $(deactivatedTab).addClass('active');
            $(deactivatedTabContent).removeClass('hide');


            /* Set the new activated tab */
            activeTab = deactivatedTab;
            activeTabContent = deactivatedTabContent;
	});
};

function pupulateVariableList(){
    var container = $("#variable-list");
    $('.variableScheme .variables').each(function(index, variableScheme) {
        $(variableScheme).children().each(function(i, variable){
            var name  = $(variable).children('.variableName').text();
            var label =  $(variable).children('.label').text();
            var href = $(variable).children('a').attr('name');
            if(name) {
            	$(container).append('<li><a href="#'+href+'"><strong class="variableName">'+name+'</strong><span class="variablel-label">'+label+'</span></a></li>');
            }
        });
    });
    
    $('#variable-list-wrapper').liveFilter('ul');
    
    $('#variable-list-wrapper .count').html($('#variable-list li').length+' '+'variables');
}

function pupulateVariableQuestionList(){
    var container = $("#question-list");
    $('.variableScheme .variables').each(function(index, variableScheme) {
        $(variableScheme).children().each(function(i, variable){            
		var href  = $(variable).children('.questionsmargin').children('a').attr('name');   
		var qtext  = $(variable).children('.questionsmargin').text();
            if(qtext) {
            	$(container).append('<li><a href="#'+href+'"><span class="questionText">'+qtext+'</strong></a></li>');
            }
        });
    });
    
    $('#question-list-wrapper').liveFilter('ul');
    
    $('#question-list-wrapper .count').html($('#question-list li').length+' '+'questions');
}

function pupulateQuestionList(){
    var container = $("#question-list");
    $('.questionScheme .questions').each(function(index, questionScheme) {
        $(questionScheme).children().each(function(i, question){
            var name            = $(question).children('.questionName').text();
            var questionText    = $(question).children('.questionText').text();
            var href            = $(question).children('a').attr('name')
            
            if(questionText.length > 0){
                $(container).append('<li><a href="#'+href+'"><span class="questionText">'+questionText+'</span></a></li>');
            }
        });
    });
    
    $('#question-list-wrapper').liveFilter('ul');
    
    $('#question-list-wrapper .count').html($('#question-list li').length+' '+'questions');
}




/*********************** [plugins] ********************************************/

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


