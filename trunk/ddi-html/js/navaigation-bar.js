$(document).ready(function(){
    if($("#navigation").length === 0){
        var languageSwitchTmp = '';
        
        if(languageSwitch){
            var currentLang = getURLParameter('lang');
            var languages = languageSwitch.split(',');
            
            languageSwitchTmp = '<div class="languageSwitch">';
            languageSwitchTmp += '<span>'+i18n.language+'</span>: ';
            
            var total = languages.length;
            $.each(languages, function(i, lang) { 
                var newUrl = window.location.href.replace(/(lang=).*?(&)/,'$1' + lang + '$2');
                
                if(lang == currentLang){
                    languageSwitchTmp += '<span class="language active">'+lang+'</span>';
                }else{
                    languageSwitchTmp += '<a class="language" href="'+newUrl+'">'+lang+'</a>';
                }
            
                if(i < total-1){
                    languageSwitchTmp += ' | ';
                }
            });
            languageSwitchTmp += '</div>';
        }
    
        $('<div id="navigration">\n\
            '+languageSwitchTmp+'\n\
            <input class="filter" name="livefilter" type="text" placeholder="'+i18n.filter+'" />\n\
            <div class="tabs">\n\
                <ul class="tabNavigation">\n\
                    <li class="option variables active" id="tab1" tab="#variable-list-wrapper">'+i18n.variables+'</li>\n\
                    <li class="option questions" id="tab2" tab="#question-list-wrapper">'+i18n.questions+'</li>\n\
                </ul>\n\
            </div>\n\
            <div id="variable-list-wrapper" class="tab-content">\n\
                <span class="count"></span>\n\
                <ul id="variable-list"></ul>\n\
            </div>\n\
            <div id="question-list-wrapper" class="tab-content hide">\n\
                <span class="count"></span>\n\
                <ul id="question-list"></ul>\n\
            </div>\n\
           </div>').insertBefore('#study');
        
        //when clicked navigate to the most recent url (including fragment)
        $(".languageSwitch .language").click(function(e){	
            e.preventDefault();
            window.location =  window.location.href.replace(/(lang=).*?(&)/,'$1' + $(this).text() + '$2');
        });
    }

    menuTabs();
    pupulateVariableList();
    pupulateVariableQuestionList();
    
    if($("#question-list li").length == 0){
        pupulateQuestionList();
    }
    
    $('.filter').keyup(function(e){
        updateCount();
    });    
    
    $('#navigration').css('width', '15%');
    $('#study').css('margin-left', $('#navigration').width());
    
});

function updateCount(){
    var totalVariables   = $('#variable-list li').length;
    var hiddenVariables  = $('#variable-list li:hidden').length;
    
    if(hiddenVariables < totalVariables){
        $('#variable-list-wrapper .count').html((totalVariables-hiddenVariables)+'/'+totalVariables+' '+i18n.variables.toLowerCase());        
    }else{
        $('#variable-list-wrapper .count').html(totalVariables+' '+i18n.variables.toLowerCase()); 
    }

    var totalQuestions   = $('#question-list li').length;
    var hiddenQuestions  = $('#question-list li:hidden').length;
    
    if(hiddenQuestions < totalQuestions){
        $('#question-list-wrapper .count').html((totalQuestions-hiddenQuestions)+'/'+totalQuestions+' '+i18n.questions.toLowerCase());
    }else{
        $('#question-list-wrapper .count').html(totalQuestions+' '+i18n.questions.toLowerCase());
    }   
}

function menuTabs(){
    /* Default active tab */
    activeTab = "#tab1";
    activeTabContent = "#variable-list-wrapper";

    $(".option").click(function(){	
        var deactivatedTab = "#" + $(this).attr('id');
        var deactivatedTabContent = $(deactivatedTab).attr('tab');

        var id= $(this).attr('tab');

        /* Deactivate current tab using css */
        $(activeTab).removeClass('active');
        $(activeTabContent).addClass('hide');

        /* Activate tab that was clicked on */
        $(deactivatedTab).addClass('active');
        $(deactivatedTabContent).removeClass('hide');

        /* Set the new activated tab */
        activeTab = deactivatedTab;
        activeTabContent = deactivatedTabContent;
        
        updateCount();
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
    
    var varaibleCount = $('#variable-list li').length;
    
    $('#variable-list-wrapper .count').html(varaibleCount+' '+i18n.variables.toLowerCase());
    
    //If study does not contain variables, show question tab
    if(varaibleCount === 0){
        $('.tabNavigation .variables').hide();
        $('.tabNavigation .questions').trigger('click');
    }
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
    
    $('#question-list-wrapper .count').html($('#question-list li').length+' '+i18n.questions.toLowerCase());
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
    
    $('#question-list-wrapper .count').html($('#question-list li').length+' '+i18n.questions.toLowerCase());
}


function getURLParameter(name) {
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}

/*********************** [plugins] ********************************************/

/***********************************************************/
/*                    LiveFilter Plugin                    */
/*                      Version: 1.1                       */
/*                      Mike Merritt                       */
/*             	    Updated: Feb 2nd, 2010                 */
/***********************************************************/

(function($) {
    $.fn.liveFilter = function(wrapper) {

        // Grabs the id of the element containing the filter
        var wrap = '#' + $(this).attr('id');

        // Make sure we're looking in the correct sub-element
        if (wrapper === 'table') {
            var item = 'tr';
        } else {
            var item = 'li';
        }

        // Listen for the value of the input to change
        $('input.filter').keyup(function() {
            var filter = $(this).val();

            if(filter === ''){
                $(wrap + ' ' + wrapper + ' ' + item).show();
            }else{
                // Hide all the items and then show only the ones matching the filter
                $(wrap + ' ' + wrapper + ' ' + item).hide();

                if (wrapper === 'table') {
                    $(wrap + ' ' + wrapper + ' ' + 'tr.header').show();
                }
                $(wrap + ' ' + wrapper + ' ' + item + ':Contains("' + filter + '")').show();                
            }

        });

        // Custom expression for case insensitive contains()
        jQuery.expr[':'].Contains = function(a, i, m) {
            return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
        };
    };
})(jQuery);