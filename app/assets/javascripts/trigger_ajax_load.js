jQuery(document).ready(function($) {
    
    $("a.ajax_load_trigger").click(function(event) {
        event.preventDefault();
        event.stopPropagation();        
        BentoSearch.ajax_load( $(this).next(".bento_search_ajax_wait") );
        $(this).fadeOut('fast');
    });
});
