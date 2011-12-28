$(document).ready(function(){

    $('<div id="variable-navigration"></div>').insertBefore('#study');
    pupulateVariableList();
});

function pupulateVariableList(){
    $('.variableScheme').each(function(index) {
        var variableScheme = $(this);
        console.log('variableScheme '+index);
    });
  
}