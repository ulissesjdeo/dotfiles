@echo off

SET NEWLINE=^& echo.

ECHO %NEWLINE%^127.0.0.1 localhost>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^::1 localhost>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 data.microsoft.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 msftconnecttest.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 azureedge.net>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 activity.windows.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 bingapis.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 msedge.net>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 assets.msn.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 scorecardresearch.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 edge.microsoft.com>>%WINDIR%\System32\drivers\etc\hosts
ECHO %NEWLINE%^127.0.0.1 data.msn.com>>%WINDIR%\System32\drivers\etc\hosts