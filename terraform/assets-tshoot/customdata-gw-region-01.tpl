enable secret 9 $9$8FLFJuoXtuIDg.$NZvwCF9avCuCykWSaMXJXDJ5XN7sN.6ijOMravwNXlE
!
aaa new-model
!
!
aaa authentication login default local
aaa authorization exec default local none 
!
!
!
ip domain name skillscloud.company

username ${adminuser} privilege 15 view admin secret ${password}
username superadmin privilege 15 secret 9 $9$X5rZGldee5ub4U$obsPWWvVo6KdhfbmFjtgw03FGcYSH/9P3PUxFL69PIc

parser view admin inclusive
 secret 9 $9$bQL1/3ivTsbcuE$3ia.lc5FnKSnnnp6C.VrL6MjzMkGicRwyl2Dsybmb3g
 commands configure exclude all line
 commands configure exclude all parser
 commands configure exclude all username
 commands exec exclude copy
 commands exec exclude more
 commands exec exclude show startup-config
 commands exec exclude show running-config
 commands exec exclude show configuration
 commands exec include show

banner motd c ___ ___       __                               __                                                            
 |   Y   .-----|  .----.-----.--------.-----.   |  |_.-----.                                                   
 |.  |   |  -__|  |  __|  _  |        |  -__|   |   _|  _  |                                                   
 |. / \  |_____|__|____|_____|__|__|__|_____|   |____|_____|                                                   
 |:      |                                                                                                     
 |::.|:. |                                                                                                     
 `--- ---'                                                                                                     
  _______ __    __ __ __       _______ __                __     _______                                        
 |   _   |  |--|__|  |  .-----|   _   |  .-----.--.--.--|  |   |   _   .-----.--------.-----.---.-.-----.--.--.
 |   1___|    <|  |  |  |__ --|.  1___|  |  _  |  |  |  _  |   |.  1___|  _  |        |  _  |  _  |     |  |  |
 |____   |__|__|__|__|__|_____|.  |___|__|_____|_____|_____|   |.  |___|_____|__|__|__|   __|___._|__|__|___  |
 |:  1   |                    |:  1   |                        |:  1   |              |__|              |_____|
 |::.. . |                    |::.. . |                        |::.. . |                                       
 `-------'                    `-------'    __     __           `-------'                                       
 .-----.-----.--.--.--.-----.----.-----.--|  |   |  |--.--.--.                                                 
 |  _  |  _  |  |  |  |  -__|   _|  -__|  _  |   |  _  |  |  |                                                 
 |   __|_____|________|_____|__| |_____|_____|   |_____|___  |                                                 
 |__|                                                  |_____|                                                 
  ______  _______ _______ ___     _______ _______                                                              
 |   _  \|   _   |   _   |   |   |   _   |   _   \                                                             
 |.  |   |   1___|.  1   |.  |   |.  1   |.  1   /                                                             
 |.  |   |____   |.  _   |.  |___|.  _   |.  _   \                                                             
 |:  |   |:  1   |:  |   |:  1   |:  |   |:  1    \                                                            
 |::.|   |::.. . |::.|:. |::.. . |::.|:. |::.. .  /                                                            
 `--- ---`-------`--- ---`-------`--- ---`-------'                                                             c

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