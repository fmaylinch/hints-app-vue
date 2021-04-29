TARGET="../hints-app-api/src/main/resources/META-INF/resources"
rm -R $TARGET/css
rm -R $TARGET/js
rm $TARGET/index.html
rm $TARGET/favicon.ico
mv dist/* $TARGET
rmdir dist
