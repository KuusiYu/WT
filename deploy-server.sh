#!/bin/bash

# 部署脚本 - 适用于腾讯云轻量应用服务器 Ubuntu 22.04 LTS
# 此脚本用于直接上传并部署乌龙足球应用

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}===== 乌龙足球应用部署脚本 =====${NC}"

# 1. 更新系统
echo -e "${YELLOW}1. 更新系统软件包...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. 安装依赖
echo -e "${YELLOW}2. 安装必要依赖...${NC}"
sudo apt install -y python3.10 python3.10-venv python3-pip nginx supervisor unzip

# 3. 创建应用目录
echo -e "${YELLOW}3. 创建应用目录...${NC}"
sudo mkdir -p /opt/wulong-football
sudo chown -R $USER:$USER /opt/wulong-football

# 4. 确保在正确的目录
cd /opt/wulong-football

# 5. 创建虚拟环境并安装Python依赖
echo -e "${YELLOW}5. 安装Python依赖...${NC}"
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple flask requests beautifulsoup4 lxml
deactivate

# 6. 配置Nginx
echo -e "${YELLOW}6. 配置Nginx反向代理...${NC}"
sudo tee /etc/nginx/sites-available/wulong-football > /dev/null << 'EOF'
server {
    listen 80;
    server_name _;  # 匹配所有域名，适合直接IP访问

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /opt/wulong-football/static;
        expires 30d;
    }
}
EOF

# 启用Nginx配置
sudo ln -sf /etc/nginx/sites-available/wulong-football /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default  # 删除默认配置
sudo nginx -t && sudo systemctl restart nginx

# 7. 配置Supervisor
echo -e "${YELLOW}7. 配置Supervisor进程管理...${NC}"
sudo tee /etc/supervisor/conf.d/wulong-football.conf > /dev/null << 'EOF'
[program:wulong-football]
directory=/opt/wulong-football
command=/opt/wulong-football/venv/bin/python3 main.py
autostart=true
autorestart=true
user=$USER
redirect_stderr=true
stdout_logfile=/var/log/wulong-football.log
environment=FLASK_HOST=0.0.0.0,FLASK_PORT=5000,FLASK_DEBUG=False
EOF

# 重启Supervisor
sudo systemctl restart supervisor

# 8. 配置防火墙
echo -e "${YELLOW}8. 配置防火墙...${NC}"
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 80/tcp  # HTTP
sudo ufw --force enable

# 9. 创建日志目录和清理脚本
echo -e "${YELLOW}9. 创建日志目录和清理脚本...${NC}"
mkdir -p /opt/wulong-football/logs

sudo tee /opt/clean-logs.sh > /dev/null << 'EOF'
#!/bin/bash
# 清理旧日志，保留最近7天的日志
truncate -s 0 /var/log/wulong-football.log
find /opt/wulong-football/logs -name "*.log*" -mtime +7 -delete
EOF

sudo chmod +x /opt/clean-logs.sh
# 添加到crontab，每天凌晨执行
sudo crontab -l | grep -q "clean-logs.sh" || echo "0 0 * * * /opt/clean-logs.sh" | sudo crontab -

# 10. 完成部署
echo -e "${GREEN}===== 基础环境部署完成 =====${NC}"
echo -e "${YELLOW}现在请上传项目文件到 /opt/wulong-football/ 目录${NC}"
echo -e "${YELLOW}上传完成后，重启应用：${NC} sudo supervisorctl restart wulong-football"
echo -e "${YELLOW}访问地址：${NC} http://$(curl -s ifconfig.me)"
echo -e "${GREEN}===================${NC}"