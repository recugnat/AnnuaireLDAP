#Informations à renseigner dans le terminal
read -p 'Entrez le nom de domaine : ' domaine
read -p 'Entrez le nom du fchier : ' fichier
file=$fichier
structure=$domaine

# Ensemble des lignes à supprimer car elle ne sont pas prises en compte par phpldapadmin
sed -i '/mozillaAbPersonAlpha/d' $file
sed -i '/mozillaWorkUrl/d' $file
sed -i "s/mozillaSecondEmail/mail/g" "$file"
sed -i "s/mozillaNickname/sn/g" $file
sed -i "s/mozillaHomeStreet/Street/g" $file
sed -i "s/mozillaHomeStreet2/Street/g" $file
sed -i '/birthyear/d' $file



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

ligneDn=$(sed -n '/dn/=' $file ) # ligne ou se trouve dn
#echo $ligne
ligneSn=$(sed -n '/sn: /=' $file ) # ligne ou se trouve sn
#echo $ligneSn
ligneCn=$(sed -n '/cn: /=' $file ) # ligne ou se trouve cn
#echo $ligneNm
ligneModify=$(sed -n '/modifytimestamp/=' $file )
echo $ligneModify

# ___________________________________________________________________ #


ligneSurnom=$(echo $ligneSn | cut -d" " -f$i1) #recupere numero de ligne surnom
ligneDomaine=$(echo $ligneDn | cut -d" " -f$i1) #recupere le numero de ligne domaine
ligneCommonName=$(echo $ligneCn | cut -d" " -f$i1) #recupere numero de ligne nom

#echo $ligneCommonName
#echo $ligneSurnom
#echo $ligneDomaine
let i1++

# ___________________________________________________________________ #

#recupere contenu des lignes sn
chaineSurnom=`sed -n ${ligneSurnom}p ${file}`
#recupere contenu des lignes cn
chaineCommonName=`sed -n ${ligneCommonName}p ${file}`
ligneModification=$(echo $ligneModify | cut -d" " -f1)
echo $ligneModification

# ___________________________________________________________________ #

ligneExtractionNom=$(echo $chaineNom | cut -c4- )
#Pour récuppérer uniquempent le surnom sans le sn :
ligneExtractionSurnom=$(echo $chaineSurnom | cut -c4- )

# ___________________________________________________________________ #
# Modifie les lignes dn en ajoutant le prenom au cn= et en isérant la structure

sed -i "$ligneDomaine s/,mail=[a-zA-Z].*/$ligneExtractionSurnom,$structure/g" "$file"

#ligneExtractionCommonName=$(echo $chaineCommonName | cut -c4- )
#sed -i "$ligneCommonName s/cn:[a-zA-Z].*/$ligneExtractionSurnom,$chaineCommonName/g" "$file"

sed -i "$ligneModification s/modifytimestamp: 0/givenName:$ligneExtractionSurnom/g" "$file"

done





