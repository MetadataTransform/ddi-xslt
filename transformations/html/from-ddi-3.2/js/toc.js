
$(document).ready(function () {
    var container = $("#toc-list")
    // toc based on http://www.jankoatwarpspeed.com/automatically-generate-table-of-contents-using-jquery/
    $("h3, h4").each(function (i) {
        var current = $(this);
        // i18n.toc
        if (current.html() != i18n.toc) {
            current.attr("id", "title" + i);
            if ($(this).is('h3')) {
                $(container).append("<dt><a id='link" + i + "' href='#title" +
                i + "' title='" + current.attr("tagName") + "'>" +
                current.html() + "</a></dt>");
            } else if ($(this).is('h4')) {
                $(container).append("<dd><a id='link" + i + "' href='#title" +
                i + "' title='" + current.attr("tagName") + "'>" +
                current.html() + "</a></dd>");
            }
        }
    });
});
