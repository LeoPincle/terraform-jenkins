resource "aws_lb" "app-tier-internal-lb" {
  name               = "app-tier-internal-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.internal-lb-sg]
  subnets            = [ var.pri_sub_3a_id, var.pri_sub_4b_id]

  enable_deletion_protection = false

  tags = {
    Environment = "app-tier-lb"
  }
}

locals {
  nginx_config = <<-EOT
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;

    # Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
    include /usr/share/nginx/modules/*.conf;

    events {
        worker_connections 1024;
    }

    http {
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile            on;
        tcp_nopush          on;
        tcp_nodelay         on;
        keepalive_timeout   65;
        types_hash_max_size 4096;

        include             /etc/nginx/mime.types;
        default_type        application/octet-stream;

        include /etc/nginx/conf.d/*.conf;

        server {
            listen       80;
            listen       [::]:80;
            server_name  _;

            #health check
            location /health {
            default_type text/html;
            return 200 "<!DOCTYPE html><p>Web Tier Health Check</p>\n";
            }

            #react app and front end files
            location / {
            root    /home/ec2-user/web-tier/build;
            index index.html index.htm
            try_files $uri /index.html;
            }

            #proxy for internal lb
            location /api/{
                    proxy_pass http://[${aws_lb.app-tier-internal-lb.dns_name}]:80/;
            }


        }

    }
  EOT
}

resource "local_file" "nginx_configuration" {
  filename = "./nginx.conf"
  content = local.nginx_config
}