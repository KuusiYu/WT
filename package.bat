@echo off
echo 正在打包乌龙足球项目...

REM 创建临时目录
if not exist temp mkdir temp

REM 复制所有必要的文件到临时目录
xcopy /E /I /Q static temp\static
xcopy /E /I /Q templates temp\templates
copy *.py temp\
copy requirements.txt temp\
copy *.js temp\
copy *.html temp\
copy *.sh temp\
copy *.md temp\

REM 排除__pycache__和.pyc文件
for /d /r temp %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d"
del /s /q temp\*.pyc

REM 打包成zip文件
cd temp
powershell -command "Compress-Archive -Path * -DestinationPath ..\wulong-football.zip -Force"
cd ..

REM 清理临时目录
rmdir /S /Q temp

echo 打包完成！文件已保存为 wulong-football.zip
echo 请将此文件上传到服务器并解压到 /opt/wulong-football/ 目录
pause