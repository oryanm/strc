@ECHO OFF
cd E:\Oryan\Software\Programming\Java\IdeaProjects\STRC
7z a -tzip strc.love E:\Oryan\Software\Programming\Java\IdeaProjects\STRC\source\*

copy /b love.exe+strc.love STRC.exe

@ECHO ON

STRC.exe
