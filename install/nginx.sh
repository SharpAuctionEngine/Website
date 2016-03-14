#!/bin/bash
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

set -x #echo on

DOMAIN="dev.com"
D_SLUG="devcom"
DIRECTORY="nginx"
DETECTED_EDITOR="${EDITOR:-nano}"
SITE_AVAILABLE="/etc/nginx/sites-available/${D_SLUG}"
SITE_ENABLED="/etc/nginx/sites-enabled/${D_SLUG}"
# PROJECT_DIR=$(pwd)

DIRECTORY="nginx"

rm $SITE_ENABLED ;
rm $SITE_AVAILABLE ;

if [ -d "$DIRECTORY" ]; then
    cd $DIRECTORY
else
    sudo -H -u $SUDO_USER -s bash -c "mkdir $DIRECTORY"
    cd $DIRECTORY
fi

if [ -f "$SITE_AVAILABLE" ]; then

    echo "You might want to verify your nginx virtual host: $DETECTED_EDITOR $SITE_AVAILABLE"

    nginx -t && service nginx reload

    wait

    tmux kill-pane

    exit
fi

# echo "Waiting for $PROJECT_DIR/lsae/public to exist..."

# wait

touch $SITE_AVAILABLE

echo "sudo ln -s $SITE_AVAILABLE $SITE_ENABLED"

echo "nano $SITE_AVAILABLE"
cat <<EOF

# this file is already saved
# exit and we'll see if nginx passes a config test
# then will restart automatically

upstream ${D_SLUG}mainstatic {
    server 127.0.0.1:8080;
    #server 127.0.0.1:8081;
}
upstream ${D_SLUG}nodeasu {
    server 127.0.0.1:9000;
    #server 127.0.0.1:9001;
}
upstream ${D_SLUG}nodecontactus {
    server 127.0.0.1:9100;
    #server 127.0.0.1:9101;
}

server {
    listen 80 ;
    server_name ${DOMAIN} www.${DOMAIN};
    index index.html index.html index.php;
    charset utf-8;

    ## Block download agents
    if (\$http_user_agent ~* LWP::Simple|wget|libwww-perl) {
        return 403;
    }
    ## Block some nasty robots
    if (\$http_user_agent ~ (msnbot|Purebot|Baiduspider|Lipperhey|Mail.Ru|scrapbot) ) {
        return 403;
    }

    access_log $PROJECT_DIR/nginx/access.log combined buffer=32k;

    location ~* \.(png|jpg|jpeg|gif|ico)\$ {
        access_log off;
        log_not_found off;
        expires 1y;
    }

    location / {
        root $PROJECT_DIR/main_static;
        try_files \$uri \$uri/ index.html;
    }

    location ~ ^/auctioneer-signup {
        root $PROJECT_DIR/node_asu/public;
        try_files \$uri \$uri/ index.html;
    }

    location /auctioneer-signup/submit {
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_pass http://${D_SLUG}nodeasu;
        # proxy_pass http://${DOMAIN}:9080;
    }

    location ~ ^/contact-us {
        root $PROJECT_DIR/node_contactus/public;
        try_files \$uri \$uri/ index.html;
    }

    location /contact-us/submit {
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$host;
        proxy_http_version 1.1;
        proxy_pass http://${D_SLUG}nodecontactus;
        # proxy_pass http://${DOMAIN}:9180;
    }

}
EOF

echo "You might want to verify your nginx virtual host: $DETECTED_EDITOR $SITE_AVAILABLE"

nginx -t && service nginx reload
# tmux kill-pane

exit
