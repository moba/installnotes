# create

virt-install --name template-yakkety --ram 2048 --disk path=/vpool/KVM/templates/yakkety-base.qcow2,size=30,bus=virtio --vcpus 2 --cpu host --os-type linux --os-variant ubuntu16.04 --network bridge=br0,model=virtio --graphics none --console pty,target_type=serial --extra-args 'console=ttyS0,115200n8 serial' --location 'http://de.archive.ubuntu.com/ubuntu/dists/yakkety/main/installer-amd64/'

in VM:

ip address add 217.197.90.xx peer 217.197.91.137 dev eth0
ip route add default via 217.197.91.137 dev eth0 onlink

# virsh

virsh shutdown $name
virsh start $name --console
virsh destroy $name # immediately, rip power cord

# mount container

modprobe nbd max_part=16
qemu-nbd -c /dev/nbd0 /vpool/KVM/image.qcow2
kpartx -a /dev/nbd0
mount /dev/nbd0p1 /mointpoint

umount /mountpoint
qemu-nbd -d /dev/nbd0 # disconnect

# ip assignment

virsh net-update default add ip-dhcp-host "<host mac='$MAC' name='$NAME' ip='$IP' />" --live --config

# fix virsh console

## mount filesystem

## /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="serial=tty0 console=tty0 console=ttyS0"
GRUB_TERMINAL="serial console"

# clone

virt-clone -o this-vm -n new-vm --auto-clone -f new_diskfile
virt-sysprep -d new-vm --hostname newhostname
...
new-vm# dpkg-reconfigure openssh-server

# cpu passthrough

    <cpu mode='host-passthrough'/>

# file system passthrough

virsh edit $guest

<devices>
    <filesystem type='mount' accessmode='mapped'>
      <source dir='/vpool/KVM/guest/data'/>
      <target dir='data'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </filesystem>
</devices>

mount -t 9p -o trans=virtio data /mnt
