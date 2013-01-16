def create_test_for_mode(p)
  name = File.basename(p, '.html')
  test_name = "#{name}_test"
  source = File.read(p)

  appendScripts = %Q{
    <script>
      var modeIsReady = false;

      window.onModeReady = function(mode) {
        modeIsReady = mode;
      };

      function whenModeIsReady(onReady) {
        if (modeIsReady) {
          onReady(modeIsReady);
        } else {
          setTimeout(function() {
            whenModeIsReady(onReady);
          }, 100);
        }
      }

      function setUpPage() {
        setUpPageStatus = 'running';

        whenModeIsReady(function(m) {
          mode = m;
          setUpPageStatus = 'complete';
        });
      }

      function tearDownPage() {
        mode = null;
      }
    </script>
    <script src="app/jsUnitCore.js"></script>
    <script src="app_test.js"></script>
    <script src="#{test_name}.js"></script>
  }

  source.gsub!("../js/", "../")
  source.gsub!("../css/", "../../css/")
  source.gsub!(".min.js", ".test.js")
  
  source.sub!("</body>", "#{appendScripts}</body>")

  File.open("js/test/#{test_name}.html", 'w') do |f|
    f.write(source)
  end
end

def create_test_for_all_modes
  Dir["modes/*.html"].each do |p|
    create_test_for_mode(p)
  end
end

def build_css
  `bundle exec compass compile --force`
end

def build_js
  debug_flag = %Q{--define='DEBUG_MODE=true'}

  puts `gjslint -r js/ --exclude_directories="js/vendor,js/test" --exclude_files="js/app.min.js,js/mode.min.js,js/app.test.js,js/mode.test.js"`

  `closure-library-20121212-r2367/closure/bin/build/closurebuilder.py --root=closure-library-20121212-r2367/ --root=js/ --namespace="ww.app" --output_mode=compiled --compiler_flags="--externs='externs/jquery-1.6.js'" --compiler_flags="--externs='externs/tuna.js'" --compiler_flags="--externs='externs/audio.js'" --compiler_flags="--externs='externs/Physics.js'" --compiler_flags="--externs='externs/modernizr.js'" --compiler_flags="--externs='externs/Tween.js'" --compiler_flags="--compilation_level=ADVANCED_OPTIMIZATIONS" --compiler_flags="#{debug_flag}" --compiler_flags="--debug=true" --compiler_jar=compiler-latest/compiler.jar --output_file=js/app.min.js`
  
  `closure-library-20121212-r2367/closure/bin/build/closurebuilder.py --root=closure-library-20121212-r2367/ --root=js/ --namespace="ww.mode" --output_mode=compiled --compiler_flags="--externs='externs/jquery-1.6.js'" --compiler_flags="--externs='externs/tuna.js'" --compiler_flags="--externs='externs/audio.js'" --compiler_flags="--externs='externs/Physics.js'" --compiler_flags="--externs='externs/modernizr.js'" --compiler_flags="--externs='externs/Tween.js'" --compiler_flags="--compilation_level=ADVANCED_OPTIMIZATIONS" --compiler_flags="#{debug_flag}" --compiler_flags="--debug=true" --compiler_jar=compiler-latest/compiler.jar --output_file=js/mode.min.js`
end

def build_js_test
  debug_flag = %Q{--define='DEBUG_MODE=true'}
    
  `closure-library-20121212-r2367/closure/bin/build/closurebuilder.py --root=closure-library-20121212-r2367/ --root=js/ --namespace="ww.app" --output_mode=compiled --compiler_flags="--externs='externs/jquery-1.6.js'" --compiler_flags="--externs='externs/tuna.js'" --compiler_flags="--externs='externs/audio.js'" --compiler_flags="--externs='externs/Physics.js'" --compiler_flags="--externs='externs/modernizr.js'" --compiler_flags="--externs='externs/Tween.js'" --compiler_flags="--compilation_level=SIMPLE_OPTIMIZATIONS" --compiler_flags="--formatting=PRETTY_PRINT" --compiler_flags="#{debug_flag}" --compiler_jar=compiler-latest/compiler.jar --output_file=js/app.test.js`
  
  `closure-library-20121212-r2367/closure/bin/build/closurebuilder.py --root=closure-library-20121212-r2367/ --root=js/ --namespace="ww.mode" --output_mode=compiled --compiler_flags="--externs='externs/jquery-1.6.js'" --compiler_flags="--externs='externs/tuna.js'" --compiler_flags="--externs='externs/audio.js'" --compiler_flags="--externs='externs/Physics.js'" --compiler_flags="--externs='externs/modernizr.js'" --compiler_flags="--externs='externs/Tween.js'" --compiler_flags="--compilation_level=SIMPLE_OPTIMIZATIONS" --compiler_flags="--formatting=PRETTY_PRINT" --compiler_flags="#{debug_flag}" --compiler_jar=compiler-latest/compiler.jar --output_file=js/mode.test.js`

  `jscoverage js js-instrumented --no-instrument="vendor" --no-instrument="test"`
end