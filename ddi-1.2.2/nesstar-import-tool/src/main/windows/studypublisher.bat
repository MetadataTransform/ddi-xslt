@echo off

REM Usage: studypublisher.bat server_uri username password [ddi_files...]
REM If multiple DDI files are specified, they must describe the same study in
REM different languages. The first file specified is used as the default fallback
REM language.

REM Example: studypublisher.bat http://127.0.0.1:8080 admin pass123 study-en.xml study-sv.xml
 
java -jar "%~dp0studypublisher.jar" %* 