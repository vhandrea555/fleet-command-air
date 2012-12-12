set PACKAGER_PATH="C:\Program Files (x86)\Adobe\AdobeAIRSDK\lib\aot\bin\iOSBin"
set PATH=%PATH%;%PACKAGER_PATH%

call idb -devices
call idb -forward 7936 16000 14