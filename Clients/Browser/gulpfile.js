'use strict';
// gulp-webapp 0.0.4 / drano

var gulp           = require('gulp');
var cached         = require('gulp-cached');
var es             = require('event-stream');
var seq            = require('run-sequence');
var lazypipe       = require('lazypipe');
var mainBowerFiles = require('main-bower-files');
var pngcrush       = require('imagemin-pngcrush');

// for deployment
var env             = (process.env.NODE_ENV || 'development').toLowerCase();
var tag             = env + '-' + new Date().getTime();
var DIST_DIR        = 'dist';
var LIVERELOAD_PORT = 35729;

if (process.env.NODE_ENV) {
  DIST_DIR += '-'+process.env.NODE_ENV.toLowerCase();
}

// Load plugins
var $ = require('gulp-load-plugins')();


// JS
gulp.task('js', function () {
  return gulp.src(['app/scripts/**/*.js', 'app/scripts/*.js'])
    .pipe(cached('js'))
    .pipe($.jshint('.jshintrc'))
    .pipe($.jshint.reporter('default'))
    .pipe(gulp.dest('.tmp/scripts'))
    .pipe($.size());
});

// Bower
gulp.task('bowerjs', function() {
  return gulp.src('app/bower_components/**/*.js')
    .pipe(gulp.dest('.tmp/bower_components'))
    .pipe($.size());
});

gulp.task('bowercss', function() {
  return gulp.src('app/bower_components/**/*.css')
    .pipe(gulp.dest('.tmp/bower_components'))
    .pipe($.size());
});


gulp.task('bower-fonts', function() {
  return gulp.src('app/bower_components/font-awesome/fonts/*.*')
    .pipe(gulp.dest('.tmp/fonts'))
    .pipe($.size());
})

// CoffeeScript
gulp.task('coffee', function() {
  return gulp.src('app/scripts/*.coffee')
    .pipe(cached('coffee'))
    .pipe($.coffee({bare: true}))
    .on('error', function(e) {
      $.util.log(e.toString());
      this.emit('end');
    })
    .pipe(gulp.dest('.tmp/scripts'))
    .pipe($.size());
});

// Images
gulp.task('images', function () {
  return gulp.src('app/images/*')
    .pipe($.cache($.imagemin({
      progressive: true,
      svgoPlugins: [{removeViewBox: false}],
      use: [pngcrush()]
    })))
    .pipe(gulp.dest('.tmp/images'));
});


// Clean
gulp.task('clean', function () {
  return gulp.src(['dist/*', '.tmp/*'], {read: false}).pipe($.rimraf());
});

// Transpile
gulp.task('transpile', ['coffee', 'js', 'bowerjs', 'bowercss', 'bower-fonts']);

// jade -> html
var jadeify = lazypipe()
  .pipe($.jade, {
    pretty: true
  });

// Jade to HTML
gulp.task('base-tmpl', function() {
  return gulp.src('app/index.jade')
    .pipe($.changed('.tmp'))
    .pipe(jadeify())
    .pipe($.inject(gulp.src(mainBowerFiles({read: false})), {
      ignorePath: ['app'],
      starttag: '<!-- bower:{{ext}}-->',
      endtag: '<!-- endbower-->'
    }))
    .pipe($.inject(gulp.src(
      [
        '.tmp/views/**/*.js',
        '.tmp/scripts/**/*.js',
        '.tmp/styles/**/*.css'
      ],
      {read: false}
    ), {
      ignorePath: ['.tmp'],
      starttag: '<!-- inject:{{ext}}-->',
      endtag: '<!-- endinject-->'
    }))
    .pipe(gulp.dest('.tmp'))
    .pipe($.size());
});

// Jade to JS
var baseFld = "app/views/*";

gulp.task('js-tmpl', function() {
  return gulp.src([baseFld+'*/*.jade', baseFld+".jade"])
    .pipe(cached('js-tmpl'))
    .pipe(jadeify())
    .pipe(gulp.dest('.tmp/views'));
});

gulp.task('js-tmpl-html', function() {
  return gulp.src([baseFld+'*/*.html', baseFld+".html"])
    .pipe(cached('js-tmpl-html'))
    .pipe(gulp.dest('.tmp/views'));
});

// useref
gulp.task('useref', function () {
  $.util.log('running useref');
  var jsFilter = $.filter('.tmp/**/*.js');
  var cssFilter = $.filter('.tmp/**/*.css');

  return es.merge(
    gulp.src('.tmp/images/*.*', {base: '.tmp'}),
    gulp.src('.tmp/fonts/**/*.*', {base: '.tmp'}),
    gulp.src('.tmp/index.html', {base: '.tmp'})
      .pipe($.useref.assets())
      .pipe(jsFilter)
      .pipe($.uglify())
      .pipe(jsFilter.restore())
      .pipe(cssFilter)
      .pipe($.minifyCss())
      .pipe(cssFilter.restore())
      .pipe($.useref.assets().restore())
      .pipe($.useref())
    )
    .pipe(gulp.dest('.tmp'))
    .pipe($.if(/^((?!(index\.html)).)*$/, $.rev()))
    .pipe(gulp.dest('dist'))
    .pipe($.rev.manifest())
    .pipe(gulp.dest('.tmp'))
    .pipe($.size());
});


// // Push to heroku
// gulp.task('push', $.shell.task([
//   'git checkout -b '+tag,
//   'cp -R dist/ '+DIST_DIR,
//   'git add -u .',
//   'git add .',
//   'git commit -am "commit for '+tag+' push"',
//   'git push -f '+env+' '+tag+':master',
//   'git checkout master',
//   'git branch -D '+tag,
//   'rm -rf '+DIST_DIR
// ]));


// E2E Protractor tests
// gulp.task('protractor', function() {
//   require('coffee-script/register');
//   return gulp.src('test/e2e/**/*.coffee')
//     .pipe($.protractor.protractor({
//       configFile: 'protractor.conf.js'
//     }))
//     .on('error', function(e) {
//       $.util.log(e.toString());
//       this.emit('end');
//     });
// });

// gulp.task('test:e2e', ['protractor'], function() {
//   gulp.watch('test/e2e/**/*.coffee', ['protractor']);
// });

// Watch
gulp.task('watch', function () {
  var lr      = require('tiny-lr')();
  var nodemon = require('gulp-nodemon');

  // start node server
  $.nodemon({
    script: 'app.js',
    ext: 'html js',
    ignore: [],
    watch: []
  })
    .on('restart', function() {
      console.log('restarted');
    });



  // start livereload server
  lr.listen(LIVERELOAD_PORT);

  // Watch for changes in .tmp folder
  gulp.watch([
    '.tmp/*.html',
    '.tmp/views/*.html',
    '.tmp/views/**/*.html',
    '.tmp/styles/**/*.css',
    '.tmp/scripts/**/*.js',
    '.tmp/images/*.*'
  ], function(event) {
    gulp.src(event.path, {read: false})
      .pipe($.livereload(lr));
  });

  // Watch .js files
  gulp.watch(['app/scripts/**/*.js', 'app/scripts/*.js'], ['js']);

  // Watch .coffee files
  gulp.watch(['app/scripts/**/*.coffee', 'app/scripts/*.coffee'], ['coffee']);

  // Watch .jade files
  gulp.watch('app/index.jade', ['base-tmpl'])
  gulp.watch(['app/views/**/*.jade', 'app/views/*.jade'], ['reload-js-tmpl'])
  gulp.watch(['app/views/**/*.html', 'app/views/*.html'], ['reload-js-tmpl-html'])

  // Watch image files
  gulp.watch('app/images/*', ['images']);

  // Watch bower files
  gulp.watch('app/bower_components/*', ['bowerjs', 'bowercss']);
});

gulp.task('build-dev', function(cb) {
  seq(
    'clean',
    'images',
    'transpile',
    'js-tmpl',
    'js-tmpl-html',
    'base-tmpl',
    cb
  );
});

gulp.task('dev', function(cb) {
  seq('build-dev', 'watch', cb);
});

gulp.task('reload-js-tmpl', function(cb) {
  seq('js-tmpl', 'base-tmpl', cb);
});

gulp.task('reload-js-tmpl-html', function(cb) {
  seq('js-tmpl-html', 'base-tmpl', cb);
});

gulp.task('build-prod', function(cb) {
  seq(
    'build-dev',
    'useref',
    cb
  );
});

gulp.task('deploy', function(cb) {
  if (!env) {
    throw 'Error: you forgot to set NODE_ENV'
  }
  seq('build-prod', cb);
});
