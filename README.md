# 乌龙足球应用部署指南

## 项目介绍

这是一个基于Flask开发的足球比赛数据应用，用于展示足球比赛的实时数据和赔率信息。

## 部署环境要求

- **操作系统**：Ubuntu 22.04 LTS
- **CPU**：1核
- **内存**：2GB
- **系统盘**：40GB SSD
- **带宽**：2Mbps

## 一键部署脚本

### 使用方法

1. 在腾讯云轻量应用服务器上，确保已安装Git：
   ```bash
   sudo apt update && sudo apt install -y git
   ```

2. 克隆项目代码：
   ```bash
   git clone <your-git-repo-url> wulong-football
   cd wulong-football
   ```

3. 运行部署脚本：
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

### 脚本功能

- 更新系统软件包
- 安装Python和必要依赖
- 配置Nginx反向代理
- 配置Supervisor进程管理
- 配置防火墙规则
- 创建日志清理脚本

## 手动部署步骤

### 1. 安装依赖

```bash
# 更新系统
apt update && apt upgrade -y

# 安装Python和必要工具
apt install python3.10 python3.10-venv python3-pip git nginx supervisor -y
```

### 2. 部署应用

```bash
# 创建应用目录
mkdir -p /opt/wulong-football
cd /opt/wulong-football

# 克隆代码
git clone <your-git-repo-url> .

# 创建虚拟环境并安装依赖
python3 -m venv venv
source venv/bin/activate
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
deactivate
```

### 3. 配置Nginx

```bash
# 创建Nginx配置文件
cat > /etc/nginx/sites-available/wulong-football << 'EOF'
server {
    listen 80;
    server_name _;

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

# 启用配置
ln -sf /etc/nginx/sites-available/wulong-football /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx
```

### 4. 配置Supervisor

```bash
# 创建Supervisor配置文件
cat > /etc/supervisor/conf.d/wulong-football.conf << 'EOF'
[program:wulong-football]
directory=/opt/wulong-football
command=/opt/wulong-football/venv/bin/python3 main.py
autostart=true
autorestart=true
user=www-data
redirect_stderr=true
stdout_logfile=/var/log/wulong-football.log
EOF

# 重启Supervisor
systemctl restart supervisor
```

### 5. 配置防火墙

```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw --force enable
```

## 环境变量配置

| 环境变量 | 默认值 | 描述 |
|---------|--------|------|
| FLASK_HOST | 0.0.0.0 | 应用监听地址 |
| FLASK_PORT | 5000 | 应用监听端口 |
| FLASK_DEBUG | False | 是否开启调试模式 |

## 应用管理

### 查看应用状态
```bash
sudo supervisorctl status wulong-football
```

### 重启应用
```bash
sudo supervisorctl restart wulong-football
```

### 停止应用
```bash
sudo supervisorctl stop wulong-football
```

### 查看应用日志
```bash
tail -f /var/log/wulong-football.log
```

## 访问应用

部署完成后，可以通过以下方式访问应用：
```
http://your-server-ip
```

## 日志管理

- 应用日志：`/var/log/wulong-football.log`
- 数据抓取日志：`/opt/wulong-football/logs/`
- 日志清理：系统每天凌晨自动清理7天前的日志

## 常见问题

### 1. 应用无法访问

- 检查Nginx状态：`systemctl status nginx`
- 检查应用状态：`sudo supervisorctl status wulong-football`
- 检查防火墙规则：`ufw status`
- 检查应用日志：`tail -f /var/log/wulong-football.log`

### 2. 应用运行缓慢

- 检查服务器资源使用情况：`top`
- 检查应用日志中的错误信息
- 考虑升级服务器配置

### 3. 数据抓取失败

- 检查网络连接
- 检查日志文件：`tail -f /opt/wulong-football/logs/scraper_error.log`
- 应用会自动重试，无需手动干预

## 技术支持

如果遇到部署问题，可以通过以下方式获取帮助：

- 查看应用日志
- 检查Nginx和Supervisor配置
- 联系技术支持
