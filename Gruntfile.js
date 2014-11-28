module.exports = function (grunt) {

    exec = require('child_process').exec;

    // Project configuration.
    grunt.initConfig({

        pkg: grunt.file.readJSON('package.json'),

        watch: {
            js: {
                files: 'src/**/*.js',
                tasks: ['concat', 'exec:reload']
            }
        },

        concat: {
            options: {
                separator: ';'
            },
            lib: {
                src: [
                    'src/api/_/**/*.js'
                ],
                dest: 'build/lib.js'
            },
            game: {
                src: [
                   'src/*.js', 'src/api/**/*.js', 'src/game/**/*.js', '!src/api/_/**/*.js', '!src/**/*.js.map', '!src/**/*.min.js'
                ],
                dest: 'build/main.js'
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
    grunt.registerTask('build', ['concat', 'uglify']);
    grunt.registerTask('test', [ 'jasmine']);
    grunt.registerTask('production', ['jasmine', 'ngtemplates', 'concat', 'uglify']);

};