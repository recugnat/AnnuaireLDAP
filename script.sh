read -p 'Entrez le nom de domaine : ' domaine
read -p 'Entrez le nom du fchier : ' fichier
file=$fichier
structure=$domaine

sed -i '/mozillaAbPersonAlpha/d' $file
#sed -i '/organizationalPerson/d' $file
#sed -i '/person/d' $file
sed -i '/mozillaWorkUrl/d' $file
sed -i "s/mozillaSecondEmail/mail/g" "$file"
sed -i "s/mozillaNickname/sn/g" $file
sed -i "s/mozillaHomeStreet/Street/g" $file
sed -i "s/mozillaHomeStreet2/Street/g" $file
sed -i '/birthyear/d' $file



#sed -i "s/,mail=[a-zA-Z].*/,$structure/g" "$file"


ligne1=$(cut -d\| -f2 $file| grep -o "dn" | wc -l) # nombre de fois ou il y a dn
#echo $ligne1
#let ligne1--
i1=1

# Cette boucle while permet d'ajouter l'élément contenu dans sn à la fin à l'ément contenu dans cn sur la ligne dn


while test $ligne1 != 0
do
# Permet de décrémenter
let ligne1--

ligneDn=$(sed -n '/dn/=' $file ) # ligne ou se trouve dn
#echo $ligne
ligneSn=$(sed -n '/sn: /=' $file ) # ligne ou se trouve sn
#echo $ligneSn
ligneNm=$(sed -n '/cn: /=' $file ) # ligne ou se trouve cn
#echo $ligneNm


ligneModify=$(sed -n '/modifytimestamp/=' $file )
echo $ligneModify


ligneSurnom=$(echo $ligneSn | cut -d" " -f$i1) #recupere numero de ligne surnom
ligneDomaine=$(echo $ligneDn | cut -d" " -f$i1) #recupere le numero de ligne domaine
#ligneNom=$(echo $ligneNm | cut -d" " -f$i1) #recupere numero de ligne nom
ligneModification=$(echo $ligneModify | cut -d" " -f1)
echo $ligneModification

#echo $ligneNom
#echo $ligneSurnom
#echo $ligneDomaine
let i1++

chaineSurnom=`sed -n ${ligneSurnom}p ${file}`
#echo  $chaineSurnom
chaineNom=`sed -n ${ligneNom}p ${file}`
#echo $chaineNom


ligneExtractionNom=$(echo $chaineNom | cut -c4- )
#echo $ligneExtractionNom
ligneExtractionSurnom=$(echo $chaineSurnom | cut -c4- )
#echo $ligneExtractionSurnom

sed -i "$ligneDomaine s/,mail=[a-zA-Z].*/$ligneExtractionSurnom,$structure/g" "$file"

sed -i "$ligneModification s/modifytimestamp: 0/givenName:$ligneExtractionSurnom/g" "$file"


done





