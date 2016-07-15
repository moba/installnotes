# create

vmbuilder kvm ubuntu --suite xenial --flavour virtual --addpkg linux-image-generic --addpkg=unattended-upgrades --addpkg=openssh-server -addpkg=acpid --arch amd64 --libvirt qemu:///system --user $USERNAME --name $HOSTNAME --hostname=$HOSTNAME --pass $PASSWORD

# mount

modprobe nbd max_part=16
qemu-nbd -c /dev/nbd0 /vpool/KVM/image.qcow2
mount /dev/nbd0p1 /mointpoint

umount /mountpoint
qemu-nbd -d /dev/nbd0 # disconnect

# ip assignment

virsh net-update default add ip-dhcp-host "<host mac='$MAC' name='$NAME' ip='$IP' />" --live --config

# fix virsh console

 - mount filesystem

## /etc/default/grub

GRUB_CMDLINE_LINUX_DEFAULT="serial=tty0 console=tty0 console=ttyS0"
GRUB_TERMINAL="serial console"

# clone

virt-clone -o this-vm -n that-vm --auto-clone -f new_diskfile

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
