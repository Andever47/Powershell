Write-Host " =========================================== " 
Write-Host " service exploitable "
Write-Host " =========================================== " 

Get-CimInstance Win32_Service |
  Where-Object { $_.PathName -like '*.exe*'} | 
    Select-Object Name, State, Pathname, StartName |
      ForEach-Object {
        $_.PathName = ($_.PathName -split '(?<=\.exe\b)')[0].Trim('"')
        Add-Member -PassThru -InputObject $_ Acl (Get-Acl -LiteralPath $_.PathName)
      } | 
        Where-Object { 
          $_.Acl.Access | Where-Object {
             $_.IdentityReference -ceq 'BUILTIN\Administrateurs' -and 
              $_.FileSystemRights -eq 'FullControl' 
          }
        }
