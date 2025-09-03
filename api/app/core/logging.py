import logging
import sys
from app.core.config import settings

def setup_logging():
    """Configure logging for the application"""
    
    # Create formatter
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    # Configure root logger
    root_logger = logging.getLogger()
    
    # Set level based on environment - minimize production logging for cost
    if settings.environment == "production":
        root_logger.setLevel(logging.WARNING)  # Only warnings and errors
    else:
        root_logger.setLevel(logging.DEBUG)
    
    # Console handler (goes to CloudWatch in App Runner)
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    root_logger.addHandler(console_handler)
    
    # Prevent duplicate logs
    root_logger.propagate = False
    
    return root_logger

# Create application logger
logger = setup_logging()