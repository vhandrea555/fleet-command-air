export PATH=$PATH:/Users/davdeev/Programs/adobe/air_sdk/bin/
echo $PATH
adt -package -Xverbose -target ipa-debug-interpreter -connect 192.168.1.3 -provisioning-profile certificate/mobileprovision.mobileprovision -storetype pkcs12 -keystore certificate/p12.p12 -storepass 1234 fc.ipa app.xml Application.swf "Default.png" "icon29.png" "icon57.png" "icon72.png" "icon512.png"
./copy-ipa.sh