extends Node2D

export (float) var taux_etalement = 1
export var nombre_clefs_uniques = 1
export var nombre_multiclefs = 0
export var nombre_permaclefs = 0
export var max_multiclefs = 4
export var max_verrous_multiclef = 1
export var max_verrous_permaclef = 1
export var nombre_bonus = 0 #Nombre de bonus puremet optionnels
export (PackedScene) var verrou_scene #Scène du verrou
export (PackedScene) var clef_scene #Scène de la clef
export (PackedScene) var start_scene #Scène du noeud start
export (PackedScene) var fin_scene #Scène du noeud fin

export(NodePath) var viewport_path = null
onready var target_viewport = get_node(viewport_path) if viewport_path else get_tree().root.get_viewport()

func _ready():
	randomize()

func generation_diagramme():
	
	var liste_objets_a_placer = [] #Création de la liste des objets à placer
	var liste_verrous_accessibles = [] #Représente la liste des verrous accessibles à ce niveau de la génération
	var start #variable qui va contenir le noeud start
	var verrouID = 0
	var noeud #variable servant à instancier les noeuds qu'on rajoute
	
	### Génération de la liste des objets à placer -----------------------------
	for _i in range(0,nombre_clefs_uniques): #Clefs uniques
		
		verrouID +=1 #incrémenter l'ID du verrou qui sera créé
		
		#Création d'un verrou et ajout dans la liste
		noeud = verrou_scene.instance()
		noeud.clefID = verrouID
		noeud.majlabel()
		add_child(noeud)
		liste_objets_a_placer.append(noeud)
		
		#Création d'une clef et ajout dans la liste
		noeud = clef_scene.instance()
		noeud.clefID = verrouID
		add_child(noeud)
		noeud.majlabel()
		liste_objets_a_placer.append(noeud)
	
	for _i in range(0,nombre_multiclefs): #Clefs multiples
		
		verrouID += 1
		
		var nombre_clefs = max(1,randi() % max_multiclefs)
		for _j in range(0,nombre_clefs):
			noeud = clef_scene.instance()
			add_child(noeud)
			noeud.clefID = verrouID
			noeud.majlabel()
			liste_objets_a_placer.append(noeud)
		
		var nombre_verrous = max(1,randi() % max_verrous_multiclef)
		var clefs_requises = 0 #nombre de clef requises pour déverrouiller le verrou
		var clefs_supplementaires = nombre_clefs - nombre_verrous #On distribue au moins 1 clef par verrou
		for _j in range(0,nombre_verrous):
			noeud = verrou_scene.instance()
			noeud.clefID = verrouID
			clefs_requises += 1
			if clefs_supplementaires > 0 :
				var clefs_en_plus = randi()%clefs_supplementaires
				print("clefs en plus = "+str(clefs_en_plus))
				clefs_requises += clefs_en_plus
				clefs_supplementaires -= clefs_en_plus
			print("clefs requises = "+str(clefs_requises))
			noeud.clefs_requises = clefs_requises
			noeud.majlabel()
			add_child(noeud)
			liste_objets_a_placer.append(noeud)
	
	for _i in range(0,nombre_permaclefs): #Clefs permanentes
		verrouID += 1
		
		noeud = clef_scene.instance()
		noeud.clefID = verrouID
		noeud.majlabel()
		add_child(noeud)
		liste_objets_a_placer.append(noeud)
		
		var nombre_verrous = max(1,randi() % max_verrous_permaclef)
		for _j in range(0,nombre_verrous):
			noeud = verrou_scene.instance()
			noeud.clefID = verrouID
			noeud.majlabel()
			add_child(noeud)
			liste_objets_a_placer.append(noeud)
	
	
	### Placement des objets dans les noeuds -----------------------------------
	start = start_scene.instance()
	add_child(start)
	start.accessible = true
	liste_verrous_accessibles.append(start) #Placement du noeud start
	
	#tant qu'il reste des éléments à placer
	while len(liste_objets_a_placer) > 0 :
		
		#Calcul du poids de chaque objet de la liste à placer
		for objet in liste_objets_a_placer :
			objet.poids = (nombre_clefs_uniques+nombre_multiclefs+nombre_permaclefs)
			if objet in get_tree().get_nodes_in_group("clef"):
				for verrou in start.lister_objets_enfants() :
					if (verrou in get_tree().get_nodes_in_group("verrou")) and (objet.clefID == verrou.clefID) :
						objet.poids = (1/taux_etalement)*(nombre_clefs_uniques+nombre_multiclefs+nombre_permaclefs)
			if objet in get_tree().get_nodes_in_group("verrou"):#si l'objet est un verrou
				for clef in start.lister_objets_enfants():
					if (clef in get_tree().get_nodes_in_group("clef")) and (objet.clefID == clef.clefID):
						objet.poids = (1/taux_etalement)*(nombre_clefs_uniques+nombre_multiclefs+nombre_permaclefs)
		#Calcul du poids de chaque verrou
		for verrou in liste_verrous_accessibles :
			verrou.poids = (1/(1+len(verrou.liste_objets_accessibles))) + taux_etalement*len(verrou.liste_objets_accessibles)
		
		var verrou_select = selection_aleatoire_ponderee(liste_verrous_accessibles) #sélection d'un verrou au hasard pour placer le nouvel élément
		var element_index = selection_aleatoire_ponderee(liste_objets_a_placer) #sélection d'un élément à placer au hasard
		
		#Placement d'un objet de la liste derrière un verrou accessible
		liste_verrous_accessibles[verrou_select].liste_objets_accessibles.append(liste_objets_a_placer[element_index])
		#Calcul des nouveaux verrous qui sont ouverts suite à cet ajout
		if liste_objets_a_placer[element_index] in get_tree().get_nodes_in_group("verrou"):
			for clef_potentielle in start.lister_objets_enfants():
				if clef_potentielle in get_tree().get_nodes_in_group("clef"):
					if (clef_potentielle.clefID == liste_objets_a_placer[element_index].clefID) and (compter_clefs_accessibles(clef_potentielle.clefID) >= liste_objets_a_placer[element_index].clefs_requises) :
						liste_verrous_accessibles.append(liste_objets_a_placer[element_index])
						liste_objets_a_placer[element_index].accessible = true
		if liste_objets_a_placer[element_index] in get_tree().get_nodes_in_group("clef"):
			for verrou_potentiel in start.lister_objets_enfants():
				if verrou_potentiel in get_tree().get_nodes_in_group("verrou"):
					if (verrou_potentiel.clefID == liste_objets_a_placer[element_index].clefID) and (compter_clefs_accessibles(verrou_potentiel.clefID) >= verrou_potentiel.clefs_requises):
						liste_verrous_accessibles.append(verrou_potentiel)
						verrou_potentiel.accessible = true
		liste_objets_a_placer.remove(element_index)
	
	print("terminé sans buguer")

func selection_aleatoire_ponderee(liste):
	var poids_total = 0
	for i in range(0,len(liste)) :
		poids_total += liste[i].poids
		
	var selection = randf() * poids_total
	var actuel = 0
	for i in range(0,len(liste)) :
		actuel += liste[i].poids
		if actuel >= selection :
			return i

func compter_clefs_accessibles(ID):
	var nombre = 0
	for objet in $Start.lister_objets_enfants():
		if (objet in get_tree().get_nodes_in_group("clef")) and (objet.clefID == ID):
			nombre += 1
	return nombre

### Fonctions d'affichage du diagramme
func affichage_recursif(objet):
	var col = objet.col
	var lig = objet.lig + 1
	for enfant in objet.liste_objets_accessibles :
		enfant.position.x = col*50
		enfant.position.y = lig*50
		enfant.col = col
		enfant.lig = lig
		col += enfant.taille_horizontale()
		#lig += enfant.taille_verticale()
		var point_intermediaire = Vector2(enfant.position.x, objet.position.y)
		$DessinerLignes.liste_traits.append([objet.position, point_intermediaire])
		$DessinerLignes.liste_traits.append([point_intermediaire, enfant.position])
	for enfant in objet.liste_objets_accessibles :
		if enfant in get_tree().get_nodes_in_group("verrou"):
			affichage_recursif(enfant)

func lire_donnees_interface():
	taux_etalement = float($EcranAccueil/SaisieTauxEtalement.text)
	nombre_clefs_uniques = int($EcranAccueil/SaisieClefsUniques.text)
	nombre_multiclefs = int($EcranAccueil/SaisieClefsMultiples.text)
	nombre_permaclefs = int($EcranAccueil/SaisieClefsPermanentes.text)
	max_multiclefs = int($EcranAccueil/SaisieMaxMulticlefs.text)
	max_verrous_multiclef = int($EcranAccueil/SaisieVerrousMulticlefs.text)
	max_verrous_permaclef = int($EcranAccueil/SaisieVerrousPermaclefs.text)

func affichage_diagramme():
	$Start.position.x = 50
	$Start.position.y = 50
	$Start/Verrou/Label.text = "Start"
	affichage_recursif($Start)
	print("fin affichage")


func _on_BoutonGenerer_pressed():
	lire_donnees_interface()
	generation_diagramme()
	$EcranAccueil.hide()
	affichage_diagramme()

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		var file_check = File.new()
		var id_save = 1
		var chemin = "res://Sauvegardes/image"+str(id_save)+".png"
		while file_check.file_exists(chemin) :
			id_save += 1
			chemin = "res://Sauvegardes/image"+str(id_save)+".png"
		var img = target_viewport.get_texture().get_data()
		img.flip_y()
		return img.save_png(chemin)
	if Input.is_action_pressed("ui_cancel"):
		for objet in get_tree().get_nodes_in_group("clef"):
			objet.queue_free()
		for objet in get_tree().get_nodes_in_group("verrou"):
			objet.queue_free()
		$EcranAccueil.show()
		$DessinerLignes.liste_traits = []
		
