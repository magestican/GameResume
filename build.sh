#!/bin/bash

# SASS

echo "Compiling Style Sheets...";
sass --style compressed --compass assets/styles/sass/styles.scss:assets/styles/css/styles.css

# GRUNT

echo "Running Grunt..."
grunt production

# ZIP

echo "Zipping Static Resources...";
rm slic_assets.zip
cd assets
zip -r -q ../slic_assets.zip js/ styles/css/ img/ templates/ fonts/ swf/ vendor/

# FINISH

echo "Finished";
