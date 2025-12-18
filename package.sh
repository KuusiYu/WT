#!/bin/bash

# 打包脚本 - 将乌龙足球项目打包以便上传

echo "正在打包乌龙足球项目..."

# 排除不需要的文件和目录
tar --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='logs/*.log*' \
    --exclude='.gitignore' \
    -czf wulong-football.tar.gz .

echo "打包完成！文件已保存为 wulong-football.tar.gz"
echo "请将此文件上传到服务器并解压到 /opt/wulong-football/ 目录"