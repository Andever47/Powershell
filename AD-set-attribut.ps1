Import-Module activedirectory
#Variable tableau
$NameInError=@()
$attribut=@("extensionAttribute1",
            "extensionAttribute2",
            "extensionAttribute3",
            "extensionAttribute4")
#Import du CSV + fixe une variable tableau pour chaque colonne du csv
Import-Csv -Path C:\Users\c81056\Desktop\Test\update-ad.csv -Delimiter ";" | foreach {
    $value=@($_.name,
             $_.Environment,
             $_.Description,
             $_.Infra,
             $_.Site)
    #Gestion des erreurs
    Try {
        # Check l'existance de la machine dans AD
        If (Get-ADComputer -Identity $value[0]) {
            # Fixe les valeurs dans les attributs AD
            Set-ADComputer -Identity $value[0] -Add @{$attribut[0]=$value[1]}
            Set-ADComputer -Identity $value[0] -Add @{$attribut[1]=$value[2]}
            Set-ADComputer -Identity $value[0] -Add @{$attribut[2]=$value[3]}
            Set-ADComputer -Identity $value[0] -Add @{$attribut[3]=$value[4]}
        }
        # On recupère le nom de la machine en erreur + eventuellement le message d'erreur en sortie de commande.
    } catch {$NameInError+=$value[0]
             $_.Exception.Message}
}