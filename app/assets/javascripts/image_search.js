// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function($) {

    $.fn.imageSearch = function( options ) {

        var opts = $.extend( {}, $.fn.imageSearch.defaults, options );

        return this.each( function() {
            var self = $(this);
            $.fn.imageSearch.load(self, opts, opts.endpoint);
            $.fn.imageSearch.initializeSearch(self, opts);
            $.fn.imageSearch.initializeRefreshElement(self, opts);
        });
    };

    $.fn.imageSearch.load = function(element, options, url)
    {
        // Clear all previous images.
        element.find('.image-container').remove();
        // Show loading indicator.
        element.find('.loading-indicator').show();
        // Hide refresh element
        if(options.refreshElement) $(options.refreshElement).hide();
        // Fetch images
        $.getJSON(url, function(data)
        {
            // Hide loading indicator.
            element.find('.loading-indicator').hide();
            // Show refresh element
            if(options.refreshElement) $(options.refreshElement).show();
            // Render images.
            $.each(data, function(key, image)
            {
                var imageId = 'image-' + image.id;
                element.append('<div class="col-md-3 col-sm-4 col-xs-6 image-container"><img id="' + imageId + '" src="' + image.thumb_url + '"/></div>')
                $('#' + imageId).click(function()
                {
                    options.onImageClick(image)
                });
            });
        });
    };

    $.fn.imageSearch.initializeSearch = function(element, options)
    {
        $.each(options.searchFields, function(key, searchFieldId)
        {
            $('#' + searchFieldId).focusout(function()
            {
                $.fn.imageSearch.onSearchTriggered(element, options);
            });
        });
    };

    $.fn.imageSearch.buildSearchQuery = function(element, options)
    {
        var query = '';
        $.each(options.searchFields, function(key, searchFieldId)
        {
            var searchFieldValue = $('#' + searchFieldId).val();
            if(searchFieldValue) // Skip empty search fields.
            {
                if(query) query = query + ' '; // Append comma only after the first element.
                query = query + searchFieldValue;
            }
        });
        return query;
    };

    $.fn.imageSearch.onSearchTriggered = function(element, options) {
        var searchQuery = $.fn.imageSearch.buildSearchQuery(element, options);
        if (element.data('last-search-query') != searchQuery)
        {
            // TODO: Implement search.
            //$.fn.imageSearch.load(element, options, '/image_search?query=' + searchQuery);
            element.data('last-search-query', searchQuery);
        }
    };

    $.fn.imageSearch.initializeRefreshElement = function(element, options)
    {
        if(options.refreshElement)
        {
            $(options.refreshElement).click(function(event)
            {
                event.preventDefault();
                $.fn.imageSearch.load(element, options, options.endpoint);
            });
        }
    };

    $.fn.imageSearch.defaults = {
        endpoint: '/image_search',
        refreshElement: null,
        searchFields: [],
        onImageClick: jQuery.noop()
    };

}(jQuery));

$(function () {

    $('.image-search').imageSearch({
        refreshElement: '#image-search-refresh-button',
        onImageClick: function(image) {
            $('#trip_image').val(image.url);
        }
    });

});
