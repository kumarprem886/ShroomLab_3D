@echo off
title ShroomLab 3D — Local Preview
color 0A
echo.
echo  =============================================
echo   ShroomLab 3D ^| Local Preview Server
echo   URL: http://localhost:5500
echo  =============================================
echo.
echo  Starting server... (close this window to stop)
echo.

:: Change to the folder where this .bat file lives
cd /d "%~dp0"

:: Open browser after a short delay (1 second)
start "" /b cmd /c "timeout /t 1 /nobreak >nul && start http://localhost:5500"

:: Start Node.js HTTP server (preferred)
where node >nul 2>&1
if %errorlevel%==0 (
  echo  Using Node.js server...
  node -e "const h=require('http'),f=require('fs'),p=require('path');h.createServer((q,s)=>{let u=q.url.split('?')[0];if(u==='/'||u==='')u='/index.html';const fp=p.join('.',u);const ext=p.extname(fp).slice(1).toLowerCase();const mime={html:'text/html',css:'text/css',js:'application/javascript',jpg:'image/jpeg',jpeg:'image/jpeg',png:'image/png',gif:'image/gif',webp:'image/webp',svg:'image/svg+xml',ico:'image/x-icon'};f.readFile(fp,(e,d)=>{if(e){s.writeHead(404);s.end('404 Not Found');}else{s.writeHead(200,{'Content-Type':mime[ext]||'application/octet-stream'});s.end(d);}});}).listen(5500,()=>console.log(' Server running at http://localhost:5500\n Press Ctrl+C to stop\n'));"
  goto :done
)

:: Fallback: Python
where py >nul 2>&1
if %errorlevel%==0 (
  echo  Using Python server...
  py -m http.server 5500
  goto :done
)

:: Fallback: python3
where python3 >nul 2>&1
if %errorlevel%==0 (
  echo  Using python3 server...
  python3 -m http.server 5500
  goto :done
)

:: Nothing found
echo  ERROR: Neither Node.js nor Python found.
echo  Please install Node.js from https://nodejs.org/
echo.
pause

:done
