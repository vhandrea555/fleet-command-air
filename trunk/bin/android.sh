export PATH=$PATH:/Users/davdeev/Programs/adobe/air_sdk/bin/
echo $PATH
adt -package -target apk-debug -storetype pkcs12 -keystore certificate/p12.p12 -storepass 1234 fc.apk app.xml Application.swf "Default.png" "icon29.png" "icon57.png" "icon72.png" "icon512.png"
cp -rf fc.apk "/Users/davdeev/Google Drive/apps/"