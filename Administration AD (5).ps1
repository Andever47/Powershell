Import-Module ActiveDirectory
function Main-Menu
{
     param (
           [string]$Title = 'ActiveDirectory'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: DomainFRA."
     Write-Host "2: DomainEURO."
     Write-Host "3: DomainONED."
     Write-Host "Q: 'Q' pour quitter."
     Write-Host "================================================="
}

function Test-Cred {
           
    [CmdletBinding()]
    [OutputType([String])] 
       
    Param ( 
        [Parameter( 
            Mandatory = $false, 
            ValueFromPipeLine = $true, 
            ValueFromPipelineByPropertyName = $true
        )] 
        [Alias( 
            'PSCredential'
        )] 
        [ValidateNotNull()] 
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()] 
        $Credentials
    )
    $Domain = $null
    $Root = $null
    $Username = $null
    $Password = $null
      
    If($Credentials -eq $null)
    {
        Try
        {
            $Credentials = Get-Credential "domain\$env:username" -ErrorAction Stop
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Warning "Failed to validate credentials: $ErrorMsg "
            Pause
            Break
        }
    }
      
    # Checking module
    Try
    {
        # Split username and password
        $Username = $credentials.username
        $Password = $credentials.GetNetworkCredential().password
  
        # Get Domain
        $Root = "LDAP://" + ([ADSI]'').distinguishedName
        $Domain = New-Object System.DirectoryServices.DirectoryEntry($Root,$UserName,$Password)
    }
    Catch
    {
        $_.Exception.Message
        Continue
    }
  
    If(!$domain)
    {
        Write-Warning "Something went wrong"
    }
    Else
    {
        If ($domain.name -ne $null)
        {
            return "Authenticated"
        }
        Else
        {
            return "Not authenticated"
        }
    }
}

function menu
{
     param (
           [string]$Title = 'DomainFRA'
     )
          cls
     Write-Host "================ $env:UserDomain ================"
    
     Write-Host "1: Lister un utilisateur de l'ad"
     Write-Host "2: reset password."
     Write-Host "3: Ajout de droit AD."
     Write-Host "4: Pour retourner au menu principal"
     Write-Host "Q: 'Q' pour quitter."
     write-Host "================================================="
 }
 

 function Get-ADUserFromDomain
 {
    param([string]$DomainUser)

    If ($DomainName -eq "EURO"){
        Get-ADUser -Server "euro.net.intra" -Identity $DomainUser -Properties * -Credential $Domaincred
    ElseIf ($DomainName -eq "ONED")
        Get-ADUser -Server "oned.net.intra" -Identity $DomainUser -Properties * -Credential $Domaincred
    Else
        Get-ADUser -Identity $DomainUser -Properties *
    }
 }

function Give-ADGroup
{
	param([string]$GroupAD)
	
	 If ($DomainName -eq "EURO"){
		Get-ADGroup -Server "euro.net.intra" -Identity $GroupAD -Credential $Domaincred
	 }
	 ElseIf ($DomainName -eq "ONED"){
		Get-ADGroup -Server "oned.net.intra" -Identity $GroupAD -Credential $Domaincred
	 }
	 Else{
		 Get-ADGroup -Identity $GroupAD
	 }

	if ( $? -ne $true){

	 Write-Warning " Groupe inexistant ou vérifiez l'orthographe du nom du groupe "
	Give-ADGroup (Read-Host " Veuillez saisir le nom du groupe ")
	}
	else{
		$user2=Read-Host "Veuillez saisir le de l'utilisateur: "
		If ($DomainName -eq "EURO"){
			Add-ADGroupMember -Server "euro.net.intra" -Identity $GroupAD -Members $users2 -Credential $Domaincred
		 }
		 ElseIf ($DomainName -eq "ONED"){
			Add-ADGroupMember -Server "oned.net.intra" -Identity $GroupAD -Members $users2 -Credential $Domaincred
		 }
		 Else{
			Add-ADGroupMember -Identity $GroupAD -Members $users2	
		}
	Write-Warning " Utilisateur rajouté au group "
	}
}


 function Set-ADPasswordFromDomain
 {
    $user=(Read-Host "Veuillez saisir le de l'utilisateur : ")
    $NewPasswd=Read-Host "Veuillez saisir le nouveau mot de passe : " –AsSecureString

    If ($DomainName -eq "EURO"){
        Set-ADAccountPassword -Server "euro.net.intra"  $user -Reset –NewPassword $NewPasswd –PassThru | Set-ADuser -ChangePasswordAtLogon $True
    ElseIf ($DomainName -eq "ONED")
        Set-ADAccountPassword -Server "oned.net.intra"  $user -Reset –NewPassword $NewPasswd –PassThru | Set-ADuser -ChangePasswordAtLogon $True
    Else
        Set-ADAccountPassword  $user -Reset –NewPassword $NewPasswd –PassThru | Set-ADuser -ChangePasswordAtLogon $True
    }
 }
             
 }

 function Get-DomainCred
{
    param([string]$DomainName)

        
    if (-not $Domaincred -or $CredCheck -ne "Authenticated") {
    $Domaincred = Get-Credential
    $CredCheck = Test-Cred $Domaincred
    If($CredCheck -ne "Authenticated")
{
    Write-Warning "Credential validation failed"
    Return Main-Menu
}
    }
 do
{
     menu
     
    
     $test = Read-Host "Faites vos choix"
switch ($test)
     {
         '1' {
            Get-ADUserFromDomain (Read-Host "Nom de l'utilisateur")

         } '2' {
            cls
            Set-ADPasswordFromDomain
         } '3' {
            Give-ADGroup (Read-Host "Saisir le nom du groupe : ")
                 }
        '4' {
             return Main-Menu
         }
     }
     pause
 }
 until ($test -eq 'q')
 }

do
 {
     Main-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' {
            cls
            Get-DomainCred "FRA"
         } '2' {
            Get-DomainCred "EURO"
         } '3' {
            Get-DomainCred "ONED"
         }
     }
     pause
 }
 until ($selection -eq 'q')