describe('Factories', function() {

    beforeEach(module('Slic'));

    describe('Manager', function() {

        it('exists', inject(function(Manager) {

            expect(Manager).not.toBeNull();

        }));

    });

    describe('DataTemplates', function() {

        describe('File', function() {

            it('can be extended and reset', inject(function(DataTemplates) {

                expect(DataTemplates.fileUpload).not.toBeUndefined();

                var fileUpload = angular.extend({}, DataTemplates.fileUpload, {
                    type: 'upload'
                });

                expect(fileUpload.type).toEqual('upload');

                fileUpload.reset();

                expect(fileUpload.type).toBeUndefined();

            }));

        });

    });

    describe('Utilities', function() {

        describe('setValueFromKeys', function() {

            it('can be extended and reset', inject(function(Utilities) {
                    
                var obj1 = {
                    foo: 'oldValue'
                };

                var obj2 = {
                    foo: {
                        bar: 'oldValue'
                    }
                };

                Utilities.setValueFromKeys(obj1, 'foo', 'newValue');
                expect(obj1.foo).toEqual('newValue');

                Utilities.setValueFromKeys(obj2, 'foo.bar', 'newValue');
                expect(obj2.foo.bar).toEqual('newValue');

            }));

        });

    });

});