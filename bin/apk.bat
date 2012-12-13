set PACKAGER_PATH="C:\Program Files (x86)\Adobe\AdobeAIRSDK\bin"
set PATH=%PATH%;%PACKAGER_PATH%
adt -package -target apk-debug -storetype pkcs12 -keystore certificate/p12.p12 -storepass 1234 fc.apk app.xml Application.swf "Default.png" "icon29.png" "icon57.png" "icon72.png" "icon512.png"