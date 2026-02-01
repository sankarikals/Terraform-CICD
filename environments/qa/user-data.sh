#!/bin/bash

# Update system
yum update -y

# Install nginx
amazon-linux-extras install nginx1 -y

# Start and enable nginx
systemctl start nginx
systemctl enable nginx

# Create custom index.html for QA
cat > /usr/share/nginx/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${environment} Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
            background-color: #e8f4f8;
        }
        .message {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            margin: 20px auto;
            max-width: 600px;
        }
        h1 {
            color: #333;
        }
        .env-qa {
            color: #2196F3;
        }
        .details {
            text-align: left;
            margin-top: 30px;
            padding: 20px;
            background-color: #f0f8ff;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div class="message">
        <h1>Welcome to <span class="env-qa">${environment}</span> Environment</h1>
        <h2>${message}</h2>
        <p>This server is provisioned with Terraform</p>
        
        <div class="details">
            <h3>Server Information:</h3>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Region:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>Private IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
        </div>
        
        <div style="margin-top: 30px;">
            <p><strong>NGINX Version:</strong> $(nginx -v 2>&1 | cut -d'/' -f2)</p>
            <p><strong>Server Time:</strong> $(date)</p>
        </div>
    </div>
</body>
</html>
EOF

# Restart nginx to apply changes
systemctl restart nginx

# Create a health check file
cat > /usr/share/nginx/html/health.html << EOF
<!DOCTYPE html>
<html>
<body>
<h1>Health Check</h1>
<p>Status: OK</p>
<p>Environment: ${environment}</p>
<p>Timestamp: $(date)</p>
</body>
</html>
EOF