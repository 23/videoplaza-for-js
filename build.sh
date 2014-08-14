#!/bin/sh

rm *swf
/Applications/Adobe\ Flash\ Builder\ 4/sdks/4.1.0/bin/mxmlc -target-player 10.1 -static-link-runtime-shared-libraries=true -include-libraries+=./videoplaza_lib_public_2.4.14.9.0.swc -debug=true -runtime-shared-library-path=/ VideoplazaJS.as
mv VideoplazaJS.swf VideoplazaJSDebug.swf

/Applications/Adobe\ Flash\ Builder\ 4/sdks/4.1.0/bin/mxmlc -target-player 10.1 -static-link-runtime-shared-libraries=true -include-libraries+=./videoplaza_lib_public_2.4.14.9.0.swc -debug=false -runtime-shared-library-path=/ VideoplazaJS.as

echo '' > ~/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt 
tail -f ~/Library/Preferences/Macromedia/Flash\ Player/Logs/flashlog.txt
