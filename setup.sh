#!/bin/bash

# Settings
SERVICE_NAME="raddetector"
INSTALL_DIR="/opt/raddetector"
SCRIPT_NAME="raddetect.py"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# Get current directory
CURRENT_DIR=$(pwd)

echo "======================================"
echo "   RadDetector Installation Script"
echo "======================================"

# Check if script is running in the correct directory
echo "Verifying current directory..."
if [ ! -f "$CURRENT_DIR/$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found in the current directory ($CURRENT_DIR)."
    echo "Please run the script from the directory where $SCRIPT_NAME is located."
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
sudo apt update && sudo apt install -y python3 python3-pip mysql-client python3-mysql.connector

# Create installation directory and copy files
echo "Copying files..."
sudo mkdir -p $INSTALL_DIR
sudo cp $CURRENT_DIR/$SCRIPT_NAME $CURRENT_DIR/config.ini $INSTALL_DIR/
sudo chmod +x $INSTALL_DIR/$SCRIPT_NAME

# Create service file
echo "Creating service file..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=RadDetector - Geiger Monitoring
After=network.target

[Service]
ExecStart=/usr/bin/python3 $INSTALL_DIR/$SCRIPT_NAME
WorkingDirectory=$INSTALL_DIR
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
echo "Enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

# Check if the service is running
echo "Installation complete!"
sudo systemctl status $SERVICE_NAME --no-pager
