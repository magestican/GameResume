angular.module('Filters')
    
    ////////////////////////////////////////////////////////////
    // Utility
    ////////////////////////////////////////////////////////////

    .filter('backgroundImage', function() {
        return function(url, type) {
            type = type === undefined ? 'object' : type;
            if (type === 'string') {
                return 'background-image: url(' + url + ');';
            } else {
                return {
                    'background-image': 'url(' + url + ')'
                };
            }
        };
    })

    .filter('date', function() {
        return function(input) {
            return input ? moment(input).format('MMM DD, YYYY') : input;
        };
    })

    .filter('getById', function() {
        return function(input, id) {
            var i = 0, len = input.length;
            for (; i < len; i++) {
                if (input[i].id === id) {
                    return input[i];
                }
            }
            return null;
        };
    })

    .filter('markdown', function() {
        return function(input) {
            return input ? markdown.toHTML(input) : '';
        };
    })

    .filter('newlines', function() {
        return function(input) {
            return input !== null ? input.replace(/\n/g, '<br/>') : '';
        };
    })

    .filter('rendition', function() {
        var sizes = {
            small: 'THUMB120BY90',
            medium: 'THUMB240BY180',
            large: 'THUMB720BY480'
        };
        return function(id, size, defaultImg) {
            size = size === undefined ? 'medium' : size;
            if (id !== null) {
                return {
                    'background-image': 'url(/sfc/servlet.shepherd/version/renditionDownload?rendition=' + sizes[size] + '&versionId=' + id + ')'
                };
            } else {
                return {};
            }
        };
    })

    .filter('styleString', ['Utilities', function(Utilities) {
        return function(styleObject) {
            return Utilities.styleString(styleObject);
        };
    }])

    .filter('url', function() {
        return function(url) {
            if (url) {
                return url.match(/^http(s)?:\/\//) ? url : 'http://' + url;
            }
            return url;
        };
    });