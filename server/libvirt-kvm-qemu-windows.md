# Windows 10 via libvirt

https://blog.pcfe.net/hugo/posts/2018-10-20-win10-under-kvm/

https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win_amd64.vfd

## install

    virt-install --name=windows10 --ram=8192 --cpu=host --vcpus=2 --os-type=windows --os -variant=win10 --disk vm-win10i.qcow2,bus=virtio,size=150 --disk /home/mo/Win10_1809Oct_v2_German_x64.iso,device=cdrom,bus=ide --disk virtio-win-0.1.164_amd64.vfd,device=floppy --network bridge=virbr0 --graphics sprice,listen=0.0.0.0,passwd=PASSWORD,port=5900,autoport=no

## fix mouse over sprice

    virsh edit windows10

       <input type='tablet' bus='usb'>
        <address type='usb' bus='0' port='1'/>
       </input>

## windows

    * install driver from floppy for disk/network virtio during install
    * privacy/cleaning tool, which one? used winprivacy.de

## client (sprice)

    apt install sprice-client-gtk
    spricy IP:PORT
