@echo off
chcp 65001 >nul
title 万象 MyriadAI 服务 (端口 8001)
cd /d "D:\PythonProject\万象"
echo ============================================
echo   正在启动 万象 MyriadAI ...
echo   网页地址: http://127.0.0.1:8001
echo   首次对话会加载模型，请耐心等待
echo   关闭本窗口即可停止服务
echo ============================================
echo.
".venv\Scripts\python.exe" -m uvicorn main:app --host 127.0.0.1 --port 8001
echo.
echo 服务已退出，按任意键关闭窗口...
pause >nul