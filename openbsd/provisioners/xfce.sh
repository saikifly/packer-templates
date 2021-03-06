#!/bin/sh -ex
pkg_add xfce-4.12p3 slim-1.3.6p10 slim-themes-1.2.3p5 toad-1.4
echo '/usr/local/bin/slim -d' >> /etc/rc.local

cat >> /etc/rc.conf.local << EOF
pkg_scripts="dbus_daemon avahi_daemon"
dbus_enable=YES
multicast_host=YES
hotplugd_flags=""    ## needed to start hotplugd for toad
apmd_flags="-A"      ## enables suspend and power mgmt
# messagebus is the new name for dbus_daemon in 5.8
pkg_scripts="${pkg_scripts} messagebus toadd slim"
EOF

echo "exec /usr/local/bin/startxfce4 --with-ck-launch" > /home/$VAGRANT_USER/.xinitrc
cat > /home/$VAGRANT_USER/.xsession << EOF
#!/bin/sh
exec /usr/local/bin/startxfce4 --with-ck-launch
EOF

sed -i.orig '/current_theme/s/default/openbsd-simple/' /etc/slim.conf
