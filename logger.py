# 日志配置模块
# 提供统一的日志记录功能

import logging
import logging.config
import os

# 创建日志目录
LOG_DIR = os.path.join(os.path.dirname(__file__), "logs")
os.makedirs(LOG_DIR, exist_ok=True)

# 日志配置
LOGGING_CONFIG = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "simple": {"format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"},
        "detailed": {
            "format": "%(asctime)s - %(name)s - %(levelname)s - %(module)s - %(funcName)s - %(lineno)d - %(message)s"
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "level": "WARNING",
            "formatter": "simple",
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "level": "DEBUG",
            "formatter": "detailed",
            "filename": os.path.join(LOG_DIR, "scraper.log"),
            "maxBytes": 10 * 1024 * 1024,  # 10MB
            "backupCount": 5,
        },
        "error_file": {
            "class": "logging.handlers.RotatingFileHandler",
            "level": "ERROR",
            "formatter": "detailed",
            "filename": os.path.join(LOG_DIR, "scraper_error.log"),
            "maxBytes": 10 * 1024 * 1024,  # 10MB
            "backupCount": 5,
        },
    },
    "loggers": {
        "scraper": {
            "level": "DEBUG",
            "handlers": ["file", "error_file"],
            "propagate": False,
        },
        "api": {
            "level": "DEBUG",
            "handlers": ["file", "error_file"],
            "propagate": False,
        },
        "main": {
            "level": "DEBUG",
            "handlers": ["file", "error_file"],
            "propagate": False,
        },
    },
    "root": {"level": "ERROR", "handlers": ["file"]},
}

# 配置日志
logging.config.dictConfig(LOGGING_CONFIG)


# 创建日志记录器
def get_logger(name):
    """
    获取日志记录器

    Args:
        name: 日志记录器名称

    Returns:
        logging.Logger: 日志记录器实例
    """
    return logging.getLogger(name)
