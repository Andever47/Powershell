gwmi win32_logicaldisk -Filter "drivetype=3" | Format-Table DeviceId,{$_.Size /1GB}, {$_.FreeSpace /1GB} -AutoSize 
get-wmiobject win32_logicaldisk -Filter "drivetype=3" | Format-Table DeviceId,{$_.Size /1GB}, {$_.FreeSpace /1GB} -AutoSize 

OSDDomainOUName LDAP://OU=Serveurs Corporate,OU=MEMBER Servers,OU=INFRA,DC=fra,DC=net,DC=intra

