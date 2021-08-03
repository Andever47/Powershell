$Groups = Get-ADGroup -Filter * -SearchBase "OU=CyberArk,OU=Administration,OU=INFRA,OU=ABPI,DC=fra,DC=net,DC=intra"

$Results = foreach( $Group in $Groups ){

    Get-ADGroupMember -Identity $Group | foreach {

    [pscustomobject]@{
            GroupName = $Group.Name
            Name = $_.Name
            }
    }
 }
$Results| Export-Csv -Path "C:\TEMP\test5896.csv" -NoTypeInformation -Encoding unicode