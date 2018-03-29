#Informations à renseigner dans le terminal
read -p 'Entrez le nom de domaine : ' domaine
read -p 'Entrez le nom du fchier : ' fichier
file=$fichier
structure=$domaine

# Ensemble des lignes à supprimer car elle ne sont pas prises en compte par phpldapadmin
sed -i '/mozillaAbPersonAlpha/d' $file
sed -i '/modifytimestamp: 0/d' $file
sed -i '/mozillaWorkUrl/d' $file
sed -i '/birthyear/d' $file

# Ensemble des chaine de caractère à remplacer car elle ne sont pas prises en compte par phpldapadmin
sed -i "s/mozillaSecondEmail/mail/g" "$file"
sed -i "s/mozillaNickname/sn/g" $file
sed -i "s/mozillaHomeStreet/Street/g" $file
sed -i "s/mozillaHomeStreet2/Street/g" $file



ligne1=$(cut -d\| -f2 $file| grep -o "dn" | wc -l) # nombre de fois ou il y a dn
#echo $ligne1
#let ligne1--
i1=1

#---------Cette boucle while permet d'ajouter 
#--------------l'élément contenu dans sn à la fin à l'ément 
#-------------------contenu dans cn sur la ligne dn, et rajouter la structure à la ligne du dn en suprimant à partir de mail.

while test $ligne1 != 0
do
# Permet de décrémenter
let ligne1--

ligneDn=$(sed -n '/dn/=' $file ) # ensemble des ligne ou se trouve dn
#echo $ligne
ligneSn=$(sed -n '/sn: /=' $file ) # ensemble des ligne ou se trouve sn
#echo $ligneSn
ligneCn=$(sed -n '/cn: /=' $file ) # ensemble des ligne ou se trouve cn
#echo $ligneNm

# ___________________________________________________________________ #


ligneSurnom=$(echo $ligneSn | cut -d" " -f$i1) #recupere un des numero de ligne ou se trouve surnom 
ligneDomaine=$(echo $ligneDn | cut -d" " -f$i1) #recupere un des numero de ligne ou se trouve domaine
ligneCommonName=$(echo $ligneCn | cut -d" " -f$i1) #recupere un des numero de ligne ou se trouve nom
#echo $ligneCommonName
#echo $ligneSurnom
#echo $ligneDomaine
let i1++

# ___________________________________________________________________ #

#recupere contenu d’une ligne ou se trouve sn
chaineSurnom=`sed -n ${ligneSurnom}p ${file}`
#recupere contenu d’une lignes ou se trouve cn
chaineCommonName=`sed -n ${ligneCommonName}p ${file}`


# ___________________________________________________________________ #
