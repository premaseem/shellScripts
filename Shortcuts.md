# Short cuts for productivity 
All different code snippets and examples would help to get optmized result in less steps. 

### Command to get just the internal ip address of host 
ip route get 8.8.8.8 | awk '{print $NF; exit}'

Would return internal ip. The advantage of that command is that you don't have to know which interface you are using (eth0? eth1? or maybe wlan0?), you don't have to filter out localhost addresses, or Docker addresses, or VPN tunnels etc. and you will always get the IP address that is currently used for Internet connections at that very moment (important when e.g. you are connected with both ethernet and wifi or via VPN etc.).

### Command to get ip address of box 