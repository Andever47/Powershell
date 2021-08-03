clear

# le mot de passe qui sera pour les comptes des utilisateurs 
#$password = 

# le groupe dans lequel vous souhaitez rajouter les utilisateurs
$group = "Administrators"

# le tableau qui servira a contenir les nom des utilisateurs
$users = @(
	# la liste des utilisateurs à créé
	"ING_SRV"
	"ING_INFRA"
	"ING_INDUS"
	"OPS_WIN"
)

# Va parcourir le tableau $user pour ajouter tous les utilisateurs 1 a 1
foreach ($user in $users) {
	
	# Créations des utilisateurs et les ajouts au groupes admins
    NET USER $user "P@ssword1586" /ADD
    NET LOCALGROUP $group $users /add
	
	}
# Pour Afficher tous les membres du groupes Admin
#net localgroup "Administrators"