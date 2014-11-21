describe('Filters', function() {

    beforeEach(module('Slic'));

    ////////////////////////////////////////////////////////////
    // Utility
    ////////////////////////////////////////////////////////////

    describe('Date', function() {

        it('formats the date correctly', inject(function(dateFilter) {

            expect(dateFilter('2013-05-01')).toBe('May 01, 2013');

        }));

    });

    describe('URL', function() {

        it('formats the ur correctly', inject(function(urlFilter) {

            expect(urlFilter('www.google.com')).toBe('http://www.google.com');
            expect(urlFilter(undefined)).toBe(undefined);

        }));

    });

    ////////////////////////////////////////////////////////////
    // File
    ////////////////////////////////////////////////////////////

    describe('File Path', function() {

        it('returns the correct file path', inject(function(filePathFilter) {

            var file;

            file = {
                contentVersion: {
                    PathOnClient: 'myFile.jpg'
                },
                slicContentVersion: {
                    Url__c: null
                }
            };

            expect(filePathFilter(file)).toBe('myFile.jpg');

            file = {
                contentVersion: null,
                slicContentVersion: {
                    Url__c: 'http://www.google.com'
                }
            };

            expect(filePathFilter(file)).toBe('http://www.google.com');

        }));

    });

    describe('File Preview', function() {

        it('returns the correct url', inject(function(filePreviewFilter) {

            var file = {
                contentVersion: {
                    PathOnClient: 'myFile.jpg',
                    Id: 'a00i0000003BydFAAS'
                },
                slicContentVersion: {
                    ContentVersionId__c: 'a00i0000003BydFAAS'
                }  
            };

            expect(filePreviewFilter(file)['background-image']).toContain('/sfc/servlet.shepherd/');
            expect(filePreviewFilter(file)['background-image']).toContain('a00i0000003BydFAAS');

        }));

    });

    describe('File Type', function() {

        it('returns the correct file extension', inject(function(fileTypeFilter) {

            var fileType;

            fileType = fileTypeFilter('Screen Shot 2013-05-20 at 9.20.32 PM.png', 'upload');
            expect(fileType.type).toBe('png');

            fileType = fileTypeFilter('http://www.dribbble.com', 'url');
            expect(fileType.type).toBe('drbl');

        }));

    });

});