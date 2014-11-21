module.exports = function(grunt) {

    exec = require('child_process').exec;

    // Project configuration.
    grunt.initConfig({

        pkg: grunt.file.readJSON('package.json'),

        watch: {
            js: {
                files: 'src/game/**/*.js',
                tasks: ['browserify', 'exec:reload']
            }
        },

        browserify: {
            'build/main.js': ['src/game/browserifyWire.js'],
            options: {
                debug: true
            }
        },

        concat: {
            options: {
                separator: ';'
            },
            lib: {
                src: [
                    'src/api/jquery.js',
                    'src/api/angular.js',
                    'src/api/angular-sanitize.js',
                    'src/api/jquery.slimscroll.js'
                ],
                dest: 'build/lib.js'
            }
        },

        uglify: {
            options: {
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
                mangle: false
            },
            lib: {
				options: {
					mangle: false
				},
                files: {
                    'build/lib.min.js': ['build/lib.js']
                }
            },
            app: {
                options: {
                    mangle: false,
                    define: {
                        DEBUG: false
                    }
                },
                files: {
                    'build/main.min.js': ['build/main.js']
                }
            }
        },

        jasmine: {
            app: {
                src: [
                    'build/main.js'
                ],
                options: {
                    specs: 'src/tests/*js',
                    vendor: [
                        'build/lib.js'
                    ],
                    helpers: [
                        'src/api/angular-mocks.js'
                    ],
                    keepRunner: true
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-browserify');
    grunt.loadNpmTasks('grunt-exec');

    // Default task(s)
    grunt.registerTask('default', []);
    grunt.registerTask('build', [ 'browserify', 'concat', 'uglify']);
    grunt.registerTask('test', ['browserify', 'jasmine']);
    grunt.registerTask('production', ['browserify', 'jasmine', 'ngtemplates', 'concat', 'uglify']);

};