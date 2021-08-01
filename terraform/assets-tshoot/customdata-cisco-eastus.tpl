crypto isakmp policy 100
 encryption aes
 hash md5
 authentication pre-share
 group 5
crypto isakmp key cisco123 address 0.0.0.0
!
!
crypto ipsec transform-set TSET esp-aes 256 esp-md5-hmac
 mode transport
!
crypto ipsec profile IPSEC
 set transform-set TSET
!
interface Tunnel12
 ip address 10.1.2.3 255.255.255.0
 tunnel source GigabitEthernet1
 tunnel destination ${westip}
 tunnel protection ipsec profile IPSEC
!
interface Tunnel13
 ip address 10.1.3.1 255.255.255.0
 tunnel source GigabitEthernet1
 tunnel destination ${southip}
 tunnel protection ipsec profile IPSEC
!
interface GigabitEthernet1
 ip nat outside
!
interface GigabitEthernet2
 ip nat inside
!
router eigrp 100
 network 10.1.2.0 0.0.0.255
 network 10.1.3.0 0.0.0.255
 network ${priv_network} 0.0.0.255
!
no ip http server
no ip http secure-server
!
ip nat inside source static tcp ${priv_ubuntu} 80 interface GigabitEthernet1 80
ip nat inside source static tcp  ${priv_ubuntu} 443 interface GigabitEthernet1 443
ip nat inside source list ACL_FOR_NAT interface GigabitEthernet1 overload
!
ip access-list standard ACL_FOR_NAT
 10 permit ${priv_network} 0.0.0.255