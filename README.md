# level-design-generator-metroidvaniaf
A level design generator for Dungeon/Metroidvania/Puzzle


**1) Introduction**
Ce générateur a pour but de créer des diagrammes de level-design qui peuvent servir pour designer des donjons, des metroidvanias, ou des énigmes.

Le principe du diagramme a été théorisé par Mark Brown, avec le soutien de ses patreons. Vous pouvez retrouver son travail ici : https://youtube.com/playlist?list=PLc38fcMFcV_ul4D6OChdWhsNsYY3NA5B2

Le logiciel lui-même a été réalisé à l’aide de Godot Engine.

**2) Principe général et commandes**

Le graphique représente la boucle de gameplay suivante : le joueur obtient une clef, qui ouvre un ou plusieurs verrous, qui lui permettent de trouver d’autres clefs, qui permettent d’ouvrir de nouveaux verrous.

Les termes de clef et verrou doivent être compris dans leur sens le plus général possible. Ainsi, une clef peut être :
- Une clef à proprement parler qui déverrouille une porte
- Un bouton qui active un téléporteur
- Tuer un boss qui maintient une porte verrouillée par magie
- Une nouvelle arme (bombe) qui permet de détruire les débris obstruant un chemin
- Un double saut permettant d’atteindre des plateformes hautes
Par convention, les verrous sont représentés par des carrés, les clefs par des losanges. Le numéro sur la clef indique le verrou auquel elle correspond. Les lignes indiquent les verrous et les clés qui sont disponibles une fois ce verrou ouvert.

Il y a trois types de couples clef-verrou :

- Clef unique : une seule clef ouvre un seul verrou. Ce type de clef correspond particulièrement bien aux clefs stricto-sensu, qui ouvrent une seule serrure.
- Multiclef : Dans ce modèle, le verrou nécessite un certain nombre de clefs pour être ouvert. Ces clefs sont identiques entre elles et interchangeables. Les clefs peuvent être indifféremment détruites lors de leur utilisation ou conservées, car le nombre de clefs nécessaires pour ouvrir le prochain verrou est de toute façon supérieur. Ce type correspond aux “petites clefs” des jeux Zelda, mais aussi à un PNJ qui réclame 3 peaux de loups en échange d’un truc (le PNJ est alors le verrou).
Petite astuce : ce n’est pas parce que ces clés sont identiques sur le papier qu’elles doivent forcément l’être en jeu ! Il peut s’agir d’un verrou qui requiert 3 symboles élémentaires (feu, eau, glace) plutôt que 3 clés identiques !
- Clef permanente : une seule clef ouvre plusieurs verrous. Ce type représente plutôt les nouvelles armes ou les nouvelles compétences acquises par le joueur, mais peut aussi représenter un passe-partout ou l’acquisition d’un grade supplémentaire permettant d’aller autre part.

A l’ouverture du logiciel, vous arrivez sur une interface qui vous permet de personnaliser vos paramètres (ces paramètres sont détaillés dans la partie 3).

Cliquez sur “Générer Diagramme” pour générer un diagramme aléatoire d’après les paramètres renseignés.

Appuyez sur **Echap** lorsque le diagramme est affiché pour l’effacer et revenir à l’écran des paramètres. Appuyez sur **Entrée** pour enregistrer une image du diagramme. Les images enregistrées se trouvent dans le dossier “Sauvegardes” du répertoire du jeu.

**3) Paramètres**
Explication des différents paramètres :

Clés uniques : nombre de clés uniques (et de verrous correspondants)

Clés multiples : nombre de clés multiples différentes.

Max verrous pour clés multiples : nombre maximal de verrous correspondant à un set de clés multiples. Le nombre de verrous sera choisi aléatoirement entre 1 et ce nombre.

Max clés multiples : nombre maximal de clés pour chaque set de clés multiples. Le nombre de clés sera tiré aléatoirement entre 1 et ce nombre.

Clés permanentes : nombre de clés permanentes différentes.

Max verrous pour clés permanentes : nombre maximal de verrous correspondant à chaque clé permanente. Le nombre de verrous sera choisi aléatoirement entre 1 et ce nombre.

Taux d’étalement : représente vaguement l’étalement horizontal du diagramme. Plus la valeur est élevée, plus il sera horizontal. D’expérience, 0.01 donne de bons résultats. L’utilisation exacte de ce paramètre est expliquée dans la partie algorithme.

**4) Comment utiliser le diagramme**
Cet algorithme ne génère pas toujours des niveaux intéressants à jouer. Vous devrez sans doute remanier le diagramme pour obtenir quelque chose d’intéressant.

Ajoutez le noeud de fin à l’endroit le plus intéressant
Je pense que placer la “fin” du niveau relève davantage du feeling que d’un algorithme. Placez donc la fin à l’endroit que vous pensez être le plus intéressant (généralement, derrière un verrou difficile à atteindre ou à ouvrir).

Ajoutez quelque chose derrière chaque verrou vide, ou supprimez-les
Un verrou derrière lequel il n’y a rien n’a aucun intérêt. Arrangez-vous pour que derrière chaque verrou vide, il y ait au moins 1 truc intéressant (un bonus permanent de vie, une fontaine pour se régénérer entièrement, un raccourci, du lore secret sur l’univers…)

Si rien ne vous vient à l’esprit, supprimez ce verrou et les clés associées.

Si vous le sentez, déplacez des clés d’un endroit à un autre… Ou bien déplacez carrément des branches entières !
C’est beaucoup plus simple de voir les imperfections dans un design déjà fait que de créer soi-même un design intéressant. Ce logiciel ne fera probablement pas un travail parfait, alors n’hésitez pas à corriger tous les problèmes que vous voyez jusqu’à obtenir un résultat dont vous serez satisfait !

Ajoutez des obstacles linéaires sur certaines lignes noires
Un obstacle linéaire peut être défini comme un obstacle qui n’a qu’une seule entrée et une seule sortie (un puzzle à base de cubes à pousser, un combat contre des ennemis ou un boss, un simple couloir servant à installer une ambiance…).

Vous pouvez placer les obstacles linéaires sur les lignes du diagramme. Rajoutez en autant que voulez, mais arrangez-vous pour que les allers-retours ne soient pas laborieux !

Petite astuce : un diagramme généré à partir de ce logiciel peut constituer un obstacle linéaire à part entière, à la condition que les clés utilisées n’aient aucune utilité en-dehors de ce donjon.

De manière générale : utilisez votre imagination pour interpréter chaque élément du diagramme
Trois verrous se suivent verticalement ? Pourquoi ne pas imaginer un obstacle combinant les trois verrous (sous forme d’énigme) plutôt que les enchaîner les uns derrière les autres ?

L’un des verrous donne accès à un grand nombre de clés ? Pourquoi ne pas regrouper ces clés sous la forme d’un porte-clés pour le justifier dans votre univers ?

**5) Algorithme**
Principe général : le programme se base sur 3 types d’objets : la clef, le verrou, et le start (chacun a sa propre scène dans Godot Engine). L’algorithme génère un nombre d’instances de ces objets déterminé par les paramètres qu’il reçoit de l’interface.

L’objet start, ainsi que chaque verrou placé, possède en lui la liste des objets (verrous ou clefs) qui sont accessibles depuis ce verrou. Il s’agit donc d’une structure en arbre.

L’algorithme se décompose en 3 grandes parties :

Construction de la liste des objets à placer dans le diagramme
Placement des objets dans le diagramme
Affichage du diagramme
Partie 1 : Création de la liste des objets à placer dans le diagramme
L’algorithme crée les objets dans l’ordre suivant : d’abord les clés uniques (et verrous correspondants), ensuite les clés multiples (et verrous correspondants), puis enfin les clés permanentes (et verrous correspondants).

Le nombre de clés par set de clés multiples, le nombre de verrous par set de clés multiples, et le nombre de verrous par clé permanentes, sont tirés aléatoirement entre 1 et le nombre maximal renseigné.

Pour les clés multiples, chaque verrou se voit attribuer un nombre de clés nécessaires à son ouverture. Chaque verrou généré nécessite au moins une clef de plus que le précédent, mais s’il y a plus de clefs que de verrous, ce nombre est augmenté par un nombre aléatoire tiré entre 0 et le nombre de clés excédentaires.

Partie 2 : Création de l’arbre des objets
(NB : dans le cadre de cet algorithme, j’utilise le terme “accessible” comme un synonyme de déverrouillé. Un verrou accessible signifie que le joueur peut passer à travers. Un verrou verrouillé est inaccessible, bien que le joueur peut se tenir devant)

Le fonctionnement de l’algorithme est similaire à celui d’un joueur qui explore le donjon, sauf qu’au lieu de le découvrir il le crée au fur et à mesure. On crée d’abord un noeud Start, qui représente le début du jeu, du donjon ou de l’énigme.

A côté de l’arbre final, l’algorithme tient une liste des noeuds accessibles actuellement par le joueur.

L’algorithme choisit un objet au hasard dans la liste des objets à placer, puis un verrou au hasard dans la liste des noeuds accessibles actuellement, et ajoute l’objet à la liste des objets situés derrière ce verrou. En plus de l’arbre, l’algorithme tient à jour la liste des verrous accessibles. Au début, évidemment, seul le start est considéré comme accessible, les verrous placés sont considérés comme verrouillés. Lorsqu’une clé est placée dans l’arbre (cela peut très bien être dans une branche différente), l’intégralité des verrous associés à cette clé sont alors considérés comme déverrouillés (sous réserve que le nombre de clés soit supérieur au nombre de clés requis par le verrou, dans le cadre des clés multiples). Lorsqu’un verrou est placé dans l’arbre, il est verrouillé par défaut, mais est déverrouillé si l’algorithme trouve la clé correspondante dans l’arbre (le nombre suffisant de clés multiples le cas échéant).

A chaque pas de l’algorithme, l’arbre représente donc l’intégralité de la zone explorable par le joueur. Toutes les clés de l’arbre sont considérées comme obtenues, et tous les verrous dont les clés se situent dans l’arbre sont considérés comme accessibles.

La sélection des objets à placer, ainsi que le verrou sur lequel ils sont placés, n’est pas équiprobable, car cela résulterait en un start très volumineux qui regroupe la quasi-totalité des objets.

La sélection aléatoire est pondérée de sorte à remplir en priorité les verrous qui n’ont rien derrière eux, et à placer en priorité les clés qui correspondent à des verrous déjà placés ainsi que les verrous qui correspondent à des clés déjà placées.

A chaque pas, l’algorithme attribue un poids aux objets, qui dépend de la valeur du Taux d’étalement. Le poids est calculé de la manière suivante :

Pour la liste des objets à placer :
poids = (nombre_clés_uniques + nombre_clés_multiples + nombre_clés_permanentes)

Le poids est multiplié par 1/(taux d’étalement) si la clé ou le verrou correspondant se trouve déjà dans l’arbre.

Pour la liste des verrous accessibles :
poids = (1/(N+1) + (taux d’étalement)*N
Où N est égal au nombre d’objets derrière le verrou

**6) Mot de la fin**
N’hésitez pas à me faire des retours sur ce petit programme, que ce soit positif ou qu’il s’agisse de pistes d’amélioration. Je suis prêt à continuer d’améliorer ce programme cela peut être utile à quelqu’un ^^
