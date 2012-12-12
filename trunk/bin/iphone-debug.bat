set PACKAGER_PATH="C:\Program Files (x86)\Adobe\AdobeAIRSDK\bin"
set PATH=%PATH%;%PACKAGER_PATH%

call adt -package -Xverbose -target ipa-debug-interpreter -connect 192.168.201.21 -provisioning-profile certificate\mobileprovision.mobileprovision -storetype pkcs12 -keystore certificate\p12.p12 -storepass 1234 fc.ipa app.xml Application.swf "Default.png" "icon29.png" "icon57.png" "icon72.png" "icon512.png"