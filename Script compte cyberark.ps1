# Importation du module Active directory

Import-Module activedirectory

#Création du tableau contenant les comptes Cyberark
$attribut=@("ING_INFRA",
            "ING_SRV",
            "OPS_WIN")
clear

foreach ($user in $attribut) {
net user $user >$null

if($? -eq ($true)){

echo "Compte existant"
break
}else{
NET USER $user "P@ssword1586" /add
net localgroup "Administrators"
echo " Compte créés et ajoute au groupe Admin"
break
}
}