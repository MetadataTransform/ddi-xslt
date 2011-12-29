$(document).ready(function(){

    $('<div id="variable-navigration">Navigation<div id="variable-list"></div></div>').insertBefore('#study');
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
    
    $('#study').css('margin-left', $('#variable-navigration').width());
  
}