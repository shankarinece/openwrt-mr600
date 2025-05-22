# openwrt-image-mr600-V2
# Fix for Running OpenWRT on TP Link MR600 v2 without hanging issues
The Firmware for TP Link's MR600 V2 downloaded from the [Firmware Selector page](https://firmware-selector.openwrt.org/) often hangs/posses stability issues during boot and does not provide DHCP address to connected clients. This occues during power cycles and hard reboots. Could not make out the reason for this behavior from the boot logs. 

After upgrade, I could see very stable and fast LTE connections. 

# Fix
Fix for the above issue is that the image build did not had qmi related packages for 4G Modem. I have included the [config file](/.config) to include all the packages required for connecting to the 4G Modem.

# Additional Settings
In addition to the packages, I have included UCI default settings for 
- Routing/NAT Offloading - Set to Hardware Flow Offloading.
- Add WWAN0 interface to WAN firewall. 
- Delay the modem starting by 60s during booting.
- Disable IPV6 for LAN and WWAN0 devices. 
- Enable WLAN

# Built images (v24.10.1)
With these settings applied, I have built the image and available under [images](/images) directory. This can be used to flash the router.

# Flashing the Router
Required Items: 
1. Download all the files under [images](/images) directory. 
2. [TFTP Server](https://tftpd64.software.informer.com/download/). Download and install the file `tftpd64-4.51-setup.exe`
3. WinSCP or any SCP tool

Rename the file ending `initramfs-kernel.bin` to `initramfs-kernel.bin`
## Installation procedure
This applies for router running both `Factory Firmware` and `OpenWRT Firmware`

1. Open the Case and Locate the serial port headers
2. Using a USB to Serial TTL Converter connect the serial port to the converter and connect to computer
3. Locate the serial port and open it using Putty/Terra-term/Any other terminal. Set Baudrate, settings to `115200/8/N/1`. 
4. On the computer, set the Ethernet Adapter to Static IP address - `192.168.1.5` and Subnet Mask to `255.255.255.0`
5. Connect Router's LAN port number 2 to computer's ethernet port using a patch cable
6. Focus in the serial console by clicking the mouse curser in Putty/Terra-term window. Pressing numeric key `1` on the Keyboard, power ON the router
7. In the terraterm messages, when the message is prompting for setting IP addresses, release the number key and set the Device IP address to `192.168.1.1`. Set the Host Address to `192.168.1.5`. Set the file name to `initramfs-kernel.bin` and press enter. Now the router is ready to load the initramfs-kernel.bin from TFTP server
8. On Computer, open the TFTP Server and select the directory containing downloaded-renamed `initramfs-kernel.bin` file. Select the right network interface (the interface that has the IP address `192.168.1.5`). Now the RAM File System should load on to the router and the router should be booting from RAM FS. after ~15 seconds, on the Putty/Terra-term window press `Enter` key to get the openwrt shell. 
9. Do not reboot the router. 
10. On Computer, change the (previously set in step number 4)  ethernet interface IP address settings to fetch from DHCP. 
11. Now, the computer should be getting the IP address from Router (porbably `192.168.1.100` range)
12. Open the SCP tool (WinSCP in Windows). Set File Protocol to SCP. Under Host name, feed the router's IP address - `192.168.1.1`. Click Login. If prompted, click "Accept". When Username is prompted, feed `root` and click OK
13. Open /tmp directory on the router. Copy/Drag the downloaded file `openwrt-ramips-mt7621-tplink_mr600-v2-eu-squashfs-sysupgrade.bin` from computer to the router's /tmp directory
14. Come back to the Putty/Terra-term serial console, feed the below command and press `Enter` to start the flashing process. 
```
sysupgrade -v -n /tmp/openwrt-ramips-mt7621-tplink_mr600-v2-eu-squashfs-sysupgrade.bin
```
15. Wait for the upgrade to complete on the router. 
16. After complete, press `Enter` key to get the OpenWRT console. Reboot the router now.

This is fairly straight forward process and I found it very stable. 

