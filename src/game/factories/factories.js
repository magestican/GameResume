angular.module('SlicFactories')

    .factory('Manager', ['$rootScope', '$q', 'FileType', function($rootScope, $q, fileTypeFactory) {
        return {
            addFile: {},
            addProject: {},

            applicationScope: undefined,

            currentPage: 'default',
            currentTeam: undefined,
            currentUser: undefined,
            currentViewMode: undefined,

            editFile: undefined,
            editProject: undefined,
            editUser: undefined,

            headerContextual: {
                display: {
                    current: undefined,
                    items: []
                },
                displayCache: {},
                endDatePicker: undefined,
                filter: false,
                filterFunction: window.Slic.K,
                projects: [],
                projectsShow: false,
                projectStatuses: {
                    items: []
                },
                title: undefined,
                titleLink: '#',
                titleType: undefined,
                tags: [],
                tagCategories: [],
                tagsMerged: [],
                tagsInput: undefined,
                tagCategoriesShow: false,
                tagsCache: {},
                sort: {
                    current: undefined,
                    items: []
                },
                sortCache: {},
                users: [],
                usersShow: false
            },

            project: undefined,

            message: {
                show: false,
                type: 'simple',
                text: undefined,
                display: {},
                showMessage: function(msg) {
                    this.show = true;
                    this.text = msg;
                }
            },

            salesforce: window.Slic !== undefined ? window.Slic.Salesforce : {},

            sidebar: {
                drawer: false,
                drawerItems: [],
                items: [],
                navItems: {},
                scrollable: undefined,
                show: false
            },

            settings: {
                sidebar: {
                    pinned: false
                },
                viewModes: {
                    assets: 'expanded',
                    projects: 'expanded',
                    people: 'expanded',
                    personas: 'expanded'                }
            },

            teams: [],
            teamsLoaded: jQuery.Deferred(),

            $html: $('html,body'),
            $pageWrapper: $('#page-wrapper')
        };
    }])

    .factory('DataTemplates', function() {
        return {
            fileUpload: {
                baseUrl: window.Slic !== undefined ? window.Slic.Salesforce.baseUrl : '/',
                focus: false,
                id: undefined,
                imageOnly: false,
                name: undefined,
                onBlur: function() {},
                onUploadChange: function() {},
                required: false,
                server: false,
                sizeLimitTip: true,
                sizeLimitMessage: false,
                sizeLimitError: false,
                sizeLimitSolution: true,
                status: undefined,
                title: undefined,
                type: undefined,
                uploadEntity: 'File',
                uploadOnly: false,
                url: undefined,
                update: false,
                reset: function() {
                    angular.forEach(['id', 'name', 'status', 'title', 'type', 'url'], function(key) {
                        this[key] = undefined;
                    }, this);
                    angular.forEach(['server', 'sizeLimitMessage', 'update'], function(key) {
                        this[key] = false;
                    }, this);
                }
            },
            headerContextualTab: {
                filter: true,
                sort: true,
                viewModes: true,
                active: false
            },
            sidebarNavItem: {
                active: false,
                action: function() {},
                actionSecondary: function() {},
                actionSecondaryIcon: 'icon-breadcrumb',
                count: undefined,
                drawerItems: undefined,
                icon: undefined,
                label: undefined,
                link: undefined
            },
            sidebarDrawerItem: {
                id: undefined,
                label: undefined,
                link: undefined,
                hasItems: false,
                items: undefined,
                showItems: false
            }
        };
    })

    .factory('Utilities', ['$filter', '$route', '$location', 'Manager', function($filter, $route, $location, Manager) {

        function PromiseQueue(scope, queue) {
            this.scope = scope;
            angular.forEach(queue, function(promise) {
                promise.resolve(this.scope);
            }, this);
            queue = [];
        }

            PromiseQueue.prototype.push = function(promise) {
                promise.resolve(this.scope);
            };

        return {

            /**
             * applyRouteToTabs
             *
             * @param {Object} scope - Angular Scope
             * @param {Array} tabs - array of tabs
             * @param {String} defaultTab - the default tab to call if no route was matched
             * @return {Object} currentTab
             */

            applyRouteToTabs: function(params) {

                var defaults = {
                    history: true
                };

                params = angular.extend(defaults, params);

                var path        = $location.path().replace(/^\//, '');
                    path        = path === '' ? null : path;
                var currentTab  = $filter('getById')(params.tabs, path);

                // Get the default tab is no tab was matched by the route
                if (!currentTab) {
                    currentTab = $filter('getById')(params.tabs, params.defaultTab);
                    if (!currentTab) { throw new Error('Tab not found and no default was specified'); }
                }

                if (params.scope.currentTab === currentTab) return;

                // Save the current tags for this tab
                if (Manager.headerContextual.currentTab) {
                    Manager.headerContextual.sortCache[Manager.headerContextual.currentTab.id] = angular.copy(Manager.headerContextual.sort);
                    Manager.headerContextual.tagsCache[Manager.headerContextual.currentTab.id] = angular.copy(Manager.headerContextual.tags);
                }

                // Clear the tags or get them from the cache
                Manager.headerContextual.sort = angular.copy(Manager.headerContextual.sortCache[currentTab.id]) || Manager.headerContextual.sort;
                Manager.headerContextual.tags = angular.copy(Manager.headerContextual.tagsCache[currentTab.id]) || [];

                // Deactivate tabs
                angular.forEach(params.tabs, function(tab) {
                    tab.active = false;
                });

                // Active the current tab
                currentTab.active = true;

                // View Modes
                this.setCurrentViewMode(currentTab);

                // Call the method
                try { currentTab.action.call(); } catch(e) {}

                // Update the factory
                Manager.currentPage = currentTab.id;

                // Save the tab to the scope
                params.scope.currentTab = Manager.headerContextual.currentTab = currentTab;

                return currentTab;

            },

            setCurrentViewMode: function(tab) {
                if (Manager.settings.viewModes[tab.id]) {
                    Manager.currentViewMode = Manager.settings.viewModes[tab.id];
                }
            },

            getValueFromKeys: function(obj, keys) {
                keys = keys.split('.');
                while (keys.length > 1) {
                    obj = obj[keys.shift()];
                }
                return obj[keys.shift()];
            },

            loadScript: function(src, callback) {
                var deferred    = jQuery.Deferred();
                var body        = document.getElementsByTagName('body')[0];
                var script      = document.createElement('script');

                script.type     = 'text/javascript';
                script.src      = src;
                script.async    = true;
                script.onload   = function() { deferred.resolve(); };

                body.appendChild(script);

                return deferred;
            },

            PromiseQueue: PromiseQueue,

            safeApply: function($scope, fn) {
                var phase = $scope.$root.$$phase;
                if(phase == '$apply' || phase == '$digest') {
                    if (fn) {
                        $scope.$eval(fn);
                    }
                } else {
                    if (fn) {
                        $scope.$apply(fn);
                    } else {
                        $scope.$apply();
                    }
                }
            },

            scrollTop: function(duration) {
                duration = duration === undefined ? 400 : duration;
                Manager.$html.animate({ scrollTop: 0 }, { duration: duration });
            },

            setValueFromKeys: function (obj, keys, value) {
                keys = keys.split('.');
                while (keys.length > 1) {
                    obj = obj[keys.shift()];
                }
                obj[keys.shift()] = value;
            },

            styleString: function(styles) {
                var styleString = '';
                var style;
                for (style in styles) {
                    styleString += style + ':' + styles[style] + ';';
                }
                return styleString;
            },
            unescape : function(string){
              if(string != "" && string != null){
                string = string.replace(/&#39;/g, "'");
                string = string.replace(/&amp;#39;/g, "'");
                string = string.replace(/&quot;/g, '"');
                string = string.replace(/&amp;/g, "&");
                string = string.replace(/&gt;/g, ">");
                string = string.replace(/&lt;/g, "<");
              }
              return string;
            }

        };
    }])

    .factory('FileType', ['$filter', function($filter) {

        var types = [{
            label: 'Vector',
            extensions: ['ai', 'eps', 'ait', 'svg', 'svgs'],
            styles: {
                'background-color': '#FFBE55'
            }
        },{
            label: 'Adobe Photoshop',
            extensions: ['psd', 'pdb'],
            styles: {
                'background-color': '#7ED0FC'
            }
        },{
            label: 'Adobe PDF',
            extensions: ['pdf'],
            styles: {
                'background-color': '#D82610'
            }
        },{
            label: 'Adobe Flash',
            extensions: ['fla', 'flv', 'swf', 'xfl', 'as', 'jsfl', 'asc', 'f4v'],
            styles: {
                'background-color': '#FA3725'
            }
        },{
            label: 'Adobe Premiere',
            extensions: ['prproj'],
            styles: {
                'background-color': '#E58AF9'
            }
        },{
            label: 'Adobe Indesign',
            extensions: ['indd', 'indl', 'indt', 'indp', 'inx', 'idml', 'xqx'],
            styles: {
                'background-color': '#F66FB8'
            }
        },{
            label: 'Adobe After Effects',
            extensions: 'aep',
            styles: {
                'background-color': '#E58AF9'
            }
        },{
            label: 'Sketch',
            extensions: 'sketch',
            styles: {
                'background-color': '#BF8FF9'
            }
        },{
            label: 'Microsoft Word',
            extensions: ['doc', 'docx', 'dot', 'dotx'],
            styles: {
                'background-color': '#14A9DA'
            }
        },{
            label: 'Microsoft Excel',
            extensions: ['xls', 'xlsx', 'csv', 'xlt', 'xltx', 'xml'],
            styles: {
                'background-color': '#45B058'
            }
        },{
            label: 'Microsoft PowerPoint',
            extensions: ['pptx', 'ppt', 'potx', 'pot'],
            styles: {
                'background-color': '#E34221'
            }
        },{
            label: 'Visio',
            extensions: ['vsd', 'vss', 'vst', 'vsw', 'vsdx', 'vssx', 'vstx'],
            styles: {
                'background-color': '#496AB3'
            }
        },{
            label: 'Axure',
            extensions: ['rp'],
            styles: {
                'background-color': '#1AB6D9'
            }
        },{
            label: 'OmniGraffle',
            extensions: ['graffle'],
            styles: {
                'background-color': '#26C587'
            }
        },{
            label: 'Keynote',
            extensions: ['key'],
            styles:  {
                'background-color': '#F2B854'
            }
        },{
            label: 'Pages',
            extensions: ['pages'],
            styles: {
                'background-color': '#2C2181'
            }
        },{
            label: 'Numbers',
            extensions: ['numbers'],
            styles: {
                'background-color': '#19A13B'
            }
        },{
            label: 'Final Cut Pro',
            extensions: ['fcp'],
            styles: {
                'background-color': '#5096D6'
            }
        },{
            label: 'Motion',
            extensions: ['motn'],
            styles: {
                'background-color': '#45BFBF'
            }
        },{
            label: 'Garage Band',
            extensions: ['band'],
            styles: {
                'background-color': '#F9CB4B'
            }
        },{
            label: 'Balsamiq',
            extensions: ['bmml'],
            styles: {
                'background-color': '#760209'
            }
        },{
            label: 'Audio',
            extensions: ['wav', 'mp3', 'wma', 'm4a', 'm4p', 'aac', 'alac'],
            styles: {
                'background-color': '#379FD3'
            }
        },{
            label: 'Video',
            extensions: ['mpg', 'mpeg', 'mov', 'qt', 'avi', 'dv', 'dvi', 'flv', 'mp4', 'm2v', 'm4v', 'wmv'],
            styles: {
                'background-color': '#8E4C9E'
            }
        },{
            label: 'Image',
            extensions: ['jpg', 'jpeg', 'jfif', 'png', 'tiff', 'tif', 'gif', 'bmp', 'pict', 'raw', 'ico'],
            styles: {
                'background-color': '#49C9A7'
            }
        },{
            label: 'Code',
            extensions: ['html', 'htm', 'css', 'sass', 'scss', 'less', 'js', 'coffee', 'php', 'hbs'],
            styles: {
                'background-color': '#505050'
            }
        },{
            label: 'Text',
            extensions: ['txt', 'rtf'],
            styles: {
                'background-color': '#B58D61'
            }
        },{
            label: 'Program',
            extensions: ['dmg', 'exe'],
            styles: {
                'background-color': '#C7C9CA'
            }
        },{
            label: 'Font',
            extensions: ['ttf', 'otf'],
            styles: {
                'background-color': '#AEB0B3'
            }
        },{
            label: 'Zip',
            extensions: ['zip', 'zipx'],
            styles: {
                'background-color': '#97999C'
            }
        }];

        var sites = [{
            labe: 'General URL',
            type: 'url',
            styles: {
                'background': 'url(../../img/icon-url.png) center no-repeat',
                'background-color': '#3ABAE9',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Document',
            pattern: /docs\.google\.com.*document/,
            type: 'google-doc',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-doc.png) center no-repeat',
                'background-color': '#3C8CEA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Spreadsheet',
            pattern: /docs\.google\.com.*spreadsheet/,
            type: 'google-spreadsheet',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-spreadsheet.png) center no-repeat',
                'background-color': '#20A971',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Presentation',
            pattern: /docs\.google\.com.*presentation/,
            type: 'google-presentation',
            group: 'google-drive',
            styles: {
                'background': 'url(../../img/icon-google-presentation.png) center no-repeat',
                'background-color': '#F8BE46',
                'text-indent': '-1000px'
            }
        },{
            label: 'Solidify',
            pattern: /solidifyapp\.com/,
            type: 'slfy',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-solidify.png) center no-repeat',
                'background-color': '#CD135C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Influence',
            pattern: /influenceapp\.com/,
            type: 'infl',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-influence.png) center no-repeat',
                'background-color': '#16AEBE',
                'text-indent': '-1000px'
            }
        },{
            label: 'Verify',
            pattern: /verifyapp\.com/,
            type: 'vrfy',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-verify.png) center no-repeat',
                'background-color': '#B2D448',
                'text-indent': '-1000px'
            }
        },{
            label: 'Notable',
            pattern: /notableapp\.com/,
            type: 'ntbl',
            group: 'zurb',
            styles: {
                'background': 'url(../../img/icon-notable.png) center no-repeat',
                'background-color': '#FEB043',
                'text-indent': '-1000px'
            }
        },{
            label: 'Dropbox',
            pattern: /dropbox\.com/,
            type: 'drbx',
            styles: {
                'background': 'url(../../img/icon-dropbox.png) center no-repeat',
                'background-color': '#3ABAE9',
                'text-indent': '-1000px'
            }
        },{
            label: 'Youtube',
            pattern: /youtube\.com/,
            type: 'tube',
            styles: {
                'background': 'url(../../img/icon-youtube.png) center no-repeat',
                'background-color': '#D6423C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Vimeo',
            pattern: /vimeo\.com/,
            type: 'vmeo',
            styles: {
                'background': 'url(../../img/icon-vimeo.png) center no-repeat',
                'background-color': '#4AC7FD',
                'text-indent': '-1000px'
            }
        },{
            label: 'Flickr',
            pattern: /flickr\.com/,
            type: 'flkr',
            styles: {
                'background': 'url(../../img/icon-flickr.png) center no-repeat',
                'background-color': '#f1f1f1',
                'text-indent': '-1000px'
            }
        },{
            label: 'Dribbble',
            pattern: /dribbble\.com/,
            type: 'drbl',
            styles: {
                'background': 'url(../../img/icon-dribbble.png) center no-repeat',
                'background-color': '#F56398',
                'text-indent': '-1000px'
            }
        },{
            label: 'Twitter',
            pattern: /twitter\.com/,
            type: 'twtr',
            styles: {
                'background': 'url(../../img/icon-twitter.png) center no-repeat',
                'background-color': '#00D4FA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Instagram',
            pattern: /instagram\.com/,
            type: 'inst',
            styles: {
                'background': 'url(../../img/icon-instagram.png) center no-repeat',
                'background-color': '#5589AA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Github',
            pattern: /git/,
            type: 'gh',
            styles: {
                'background': 'url(../../img/icon-github.png) center no-repeat',
                'background-color': '#555555',
                'text-indent': '-1000px'
            }
        },{
            label: 'Proto',
            pattern: /proto/,
            type: 'prto',
            styles: {
                'background': 'url(../../img/icon-salesforce.png) center no-repeat',
                'background-color': '#027BD2',
                'text-indent': '-1000px'
            }
        },{
            label: 'Asana',
            pattern: /asana\.com/,
            type: 'asna',
            styles: {
                'background': 'url(../../img/icon-asana.png) center no-repeat',
                'background-color': '#15A2DA',
                'text-indent': '-1000px'
            }
        },{
            label: 'Basecamp',
            pattern: /basecamp\.com/,
            type: 'base',
            styles: {
                'background': 'url(../../img/icon-basecamp.png) center no-repeat',
                'background-color': '#77CA8C',
                'text-indent': '-1000px'
            }
        },{
            label: 'Delicious',
            pattern: /delicious\.com/,
            type: 'deli',
            styles: {
                'background': 'url(../../img/icon-delicious.png) center no-repeat',
                'background-color': '#285da7',
                'text-indent': '-1000px'
            }
        },{
            label: 'Google Plus',
            pattern: /plus\.google\.com/,
            type: 'g+',
            styles: {
                'background': 'url(../../img/icon-google.png) center no-repeat',
                'background-color': '#DE4436',
                'text-indent': '-1000px'
            }
        },{
            label: 'Pinterest',
            pattern: /pinterest\.com/,
            type: 'pint',
            styles: {
                'background': 'url(../../img/icon-pinterest.png) center no-repeat',
                'background-color': '#C93339',
                'text-indent': '-1000px'
            }
        },{
            label: 'Kontiki',
            pattern: /videocenter\.kontiki\.com/,
            type: 'ktik',
            styles: {
                'background': 'url(../../img/icon-kontiki.png) center no-repeat',
                'background-color': '#25a7d4',
                'text-indent': '-1000px'
            }
        },{
            label: 'Facebook',
            pattern: /facebook\.com/,
            type: 'fb',
            styles: {
                'background': 'url(../../img/icon-facebook.png) center no-repeat',
                'background-color': '#43609c',
                'text-indent': '-1000px'
            }
        },{
            label: 'Flinto',
            pattern: /flinto\.com/,
            type: 'flto',
            styles: {
                'background': 'url(../../img/icon-flinto.png) center no-repeat',
                'background-color': '#333940',
                'text-indent': '-1000px'
            }
        }];

        var releases = [{
            label: "170 (Spring '11)",
            dateRange: moment().range(moment('7/30/2010'), moment('12/3/2010'))
        },{
            label: "172 (Summer '11)",
            dateRange: moment().range(moment('12/6/2010'), moment('3/31/2011'))
        },{
            label: "174 (Winter '12)",
            dateRange: moment().range(moment('3/31/2011'), moment('7/22/2011'))
        },{
            label: "176 (Spring '12)",
            dateRange: moment().range(moment('7/22/2011'), moment('11/18/2011'))
        },{
            label: "178 (Summer '12)",
            dateRange: moment().range(moment('11/18/2011'), moment('3/29/2012'))
        },{
            label: "180 (Winter '13)",
            dateRange: moment().range(moment('3/30/2012'), moment('7/26/2012'))
        },{
            label: "182 (Spring '13)",
            dateRange: moment().range(moment('7/27/2012'), moment('11/15/2012'))
        },{
            label: "184 (Summer '13)",
            dateRange: moment().range(moment('11/16/2012'), moment('3/28/2013'))
        },{
            label: "186 (Winter '14)",
            dateRange: moment().range(moment('3/29/2013'), moment('7/25/2013'))
        },{
            label: "188 (Spring '14)",
            dateRange: moment().range(moment('7/26/2013'), moment('11/14/2013'))
        },{
            label: "190 (Summer '14)",
            dateRange: moment().range(moment('11/22/2013'), moment('3/27/2014'))
        },{
            label: "192 (Winter '15)",
            dateRange: moment().range(moment('3/28/2014'), moment('7/31/2014'))
        },{
            label: "194 (Spring '15)",
            dateRange: moment().range(moment('8/1/2014'), moment('11/20/2014'))
        },{
            label: "196 (Summer '15)",
            dateRange: moment().range(moment('11/21/2014'), moment('3/26/2015'))
        },{
            label: "198 (Winter '16)",
            dateRange: moment().range(moment('3/27/2015'), moment('7/30/2015'))
        },{
            label: "200 (Spring '16)",
            dateRange: moment().range(moment('7/31/2015'), moment('11/19/2015'))
        },{
            label: "202 (Summer '16)",
            dateRange: moment().range(moment('11/20/2015'), moment('3/31/2016'))
        },{
            label: "204 (Winter '17)",
            dateRange: moment().range(moment('4/1/2016'), moment('7/28/2016'))
        },{
            label: "206 (Spring '17)",
            dateRange: moment().range(moment('7/29/2016'), moment('11/17/2016'))
        },{
            label: "208 (Summer '17)",
            dateRange: moment().range(moment('11/18/2016'), moment('3/30/2017'))
        },{
            label: "210 (Winter '18)",
            dateRange: moment().range(moment('3/31/2017'), moment('7/27/2017'))
        }];

        var styleString = '';
        var styleTag = document.createElement('style');
            styleTag.type = 'text/css';

        angular.forEach(types, function(type) {
            angular.forEach(type.extensions, function(extension) {
                styleString += '[data-content-type="'+ extension +'"],';
            });
            styleString = styleString.replace(/,$/g, ' {');
            angular.forEach(type.styles, function(value, property) {
                value = value.replace(/\.\.\/\.\./, window.Slic.Salesforce.assetsURL);
                styleString += '' + property + ':' + value + ';';
            });
            styleString += '}';
        });

        angular.forEach(sites, function(site) {
            styleString += '[data-content-type="'+ site.type +'"] {';
            angular.forEach(site.styles, function(value, property) {
                value = value.replace(/\.\.\/\.\./, window.Slic.Salesforce.assetsURL);
                styleString += '' + property + ':' + value + ';';
            });
            styleString += '}';
        });

        styleTag.innerHTML = styleString;
        document.head.appendChild(styleTag);

        return {
            types: types,
            sites: sites,
            releases: releases,
        };

    }])

    .factory('AutoTag', ['$filter', 'FileType', function($filter, FileType) {
        return function(params) {
            return function() {
                var findTag, addTag, checkFileForTag, checkDateForTag;
                findTag = function(label) {
                    return $filter('filter')(params.tagsMerged, { Title__c: label })[0];
                };
                addTag = function(newTag) {
                    var i, tag;
                    for (i = 0; i < params.tags.length; i++) {
                        tag = params.tags[i];
                        if (tag.Id === newTag.Id) return;
                    }
                    params.tags.push(newTag);
                };
                checkFileForTag = function(fileUpload) {
                    var i, site, type, extension;
                    if ('url' === fileUpload.type) {
                        for (i = 0; i < FileType.sites.length; i++) {
                            site = FileType.sites[i];
                            if (site.pattern && fileUpload.url.match(site.pattern)) {
                                addTag(findTag(site.label));
                                break;
                            }
                        }
                    }
                    if ('upload' === fileUpload.type) {
                        extension = fileUpload.name.split('.');
                        extension = extension[extension.length - 1];
                        for (i = 0; i < FileType.types.length; i++) {
                            type = FileType.types[i];
                            if (type.extensions.indexOf(extension) !== -1) {
                                addTag(findTag(type.label));
                                break;
                            }
                        }
                    }
                };
                checkDateForTag = function(moment) {
                    angular.forEach(FileType.releases, function(release) {
                        if (release.dateRange.contains(moment)) {
                            addTag(findTag(release.label));
                        }
                    });
                };
                params.callback.call(this, findTag, addTag, checkFileForTag, checkDateForTag);
            };
        };
    }]);
