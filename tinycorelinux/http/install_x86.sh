tce-load -wi grub-0.97-splash.tcz

sudo fdisk /dev/sda << EOF
n
p
1


a
1
w
EOF

sudo mkfs.ext4 /dev/sda1

sudo rebuildfstab
 
sudo mount /mnt/sda1
sudo mkdir -p /mnt/sda1/boot/grub
sudo mount /mnt/sr0
sudo cp -p /mnt/sr0/boot/* /mnt/sda1/boot/

sudo mkdir -p /mnt/sda1/tce
sudo touch /mnt/sda1/tce/mydata.tgz
sudo cp -p /usr/lib/grub/i386-pc/* /mnt/sda1/boot/grub/
sudo sh -c 'cat > /mnt/sda1/boot/grub/menu.lst' << EOF
default 0
timeout 10
title $GRUB_ENTRY_NAME
kernel /boot/vmlinuz restore=sda1/tce quiet
initrd /boot/core.gz
EOF

sudo grub << EOF
root (hd0,0)
setup (hd0)
quit
EOF

tce-load -wil curl.tcz make.tcz

tce-setdrive

tce-load -wi openssh.tcz
sudo sh -c 'echo "usr/local/etc/ssh" >> /opt/.filetool.lst'

sudo sh -c "sed 's/^#PermitEmptyPasswords no$/PermitEmptyPasswords yes/' /usr/local/etc/ssh/sshd_config.example > /usr/local/etc/ssh/sshd_config"
sudo sh -c 'echo "usr/local/etc/ssh" >> /opt/.filetool.lst'

tce-load -wi rsync.tcz nfs-utils.tcz

sudo /usr/local/etc/init.d/openssh start
sudo sh -c 'cat >> /opt/bootsync.sh' << EOF
ssh-keygen -A
/usr/local/etc/init.d/openssh start
EOF
