chrootsystem(){  
    PS3='Enter a number for your time standard: '
    timestandard=("localtime" "UTC")
    select reply in "${timestandard[@]}"
    do
        case $reply in
            "localtime")
                hwclock --systohc --localtime
                break;;     
            "UTC")
                hwclock --systohc --utc
                break;;
        *) echo "invalid option";;
        esac
    done
        
    read -rp "Enter in the hostname of the computer (e.g archlinuxpc): " host
    echo $host > /etc/hostname
    
    echo -e "Creating initial ramdisk environment and setting up kernel modules for init\n"
    mkinitcpio -p linux 
    
    echo
    read -rsp $'Press any key to set the root passwd...\n' -n1 key
    passwd
    echo
    
    PS3='Enter 1 to install Syslinux or another key to install different boot loader: '
    timestandard=("Syslinux")
    select reply in "${timestandard[@]}"
    do
        case $reply in    
            "Syslinux")
                echo -e "y" | pacman -S syslinux gptfdisk
                syslinux-install_update -i -a -m
                echo
                lsblk /dev/sda
                read -rsp $'Add the root partition number after /dev/   For example -->  LABEL arch  APPEND root=/dev/(ROOT PARTITION NUMBER GOES HERE) rw. Once you hit a key, the terminal will automatically switch to the file...\n' -n1 key
                nano /boot/syslinux/syslinux.cfg 
                break;;
        *) break;;
        esac
    done
}
chrootsystem
