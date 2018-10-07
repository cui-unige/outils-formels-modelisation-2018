
//variable
var pokemonLevel = 1
pokemonLevel = 2
//constantes
let pokemonSpecies = "Bulbasaur"
//pokemonSpecies = "Pikachu" //retourne une erreur car est une constantes
print( pokemonLevel)
print("The level of my pokemon is\(pokemonLevel).")

//les types
let pokemonWeight: Double=5.1

//let pokemonVeight: Double
 //renvoi une erreur de constantes car on doit initializer la value dans sa déclaration
 let x, y : Int
//##############################################################################
//AFFICHAGE

print(type(of: pokemonWeight))

print(type(of: "Pikachu"))
//##############################################################################
//ASSIGNATION DE TYPE EXISTANT
let t1 = type(of: "Pikachu")
print("ti est \(t1)")

let t2 = type(of: t1)
print("ti est \(t2)")

let t3 = type(of: t2)
print("ti est \(t3)")

// possibilité d'assigner les valeur avec un pointeur null
var trainer1: String?
//autre possibilité
var trainer2: String? = nil

var trainer3: String? = "Ash"


var trainer11: String? = "Ash"
// impossible de faire pointer une variable vers une variable qui "pointe deja"
//var trainer22: String = trainer11
// mais fonctionne sans le types
var trainer33 = trainer11;

// impossible
//var trainer1: String? = "ASh"
//var trainer2: String = trainer1!

//trainer1 = nil
//trainer2 = trainer1! // la valeur est null on peut pas appliquer l'ASSIGNATION

//##############################################################################
// LES TUPLES

let bulbasaur = (001, "Bulbasaur")
let blubilar: (Int, String)
blubilar = (001, "Bulbilar")

var pokemon = (001, "bulbasaur")
pokemon = (002, "Ivysaur")
//pokemon = ("venusaur", 003)
//retourn une erreur

// acces des valeur d'une variable
print(bulbasaur.1)
//il est préférable de crée des label pour retrouver les valeurs
let bulbalabel = (number: 001, name: "bulbalabel")
print(bulbalabel.name)
// peut egalement être crée de la manière suivante

print(bulbalabel.1)

// attribution par decompostion
let (pokemonId, pokemonName) = bulbalabel
// Si on a pas besoin de toutes les valeur on peut eviter
let (_, pokemonName2) = bulbalabel
print("pokemon est\(pokemon) ")

// on peut eviter de retapper les types pour une variable utiliser un bon nombre de fois
typealias Species = (number: Int, name: String)
let bubasaur3: Species = (001, "bulbasaur3")
let ivysaur2: Species = (number: 002, name: "Ivysaur")
print("les pokemon avec alias :\(bubasaur3)\(ivysaur2)")
// on peut eviter de retapper les label que si on place les valeur dans l'ordre

//##############################################################################
//ENUMERATION
//création de différents types
enum SpeciesType {
case grass
case fire
case water
}
// autre création possible
enum SpeciesType2 {
case grass, fire, water
}

let bulbasaurSpeciesType = SpeciesType.grass
//autre métode si on a déja déclarer l'objet
let bulbasaurSpeciesType2: SpeciesType
bulbasaurSpeciesType2 = .grass

//on peut associer des valeur aux cases
enum Consumable {
case pokeball (catchRateMultiplier: Double)
case potion(restoration: Int)
}
let ultraBall = Consumable.pokeball(catchRateMultiplier: 2)

//Enumeration Récursif plus de details sur apple
indirect enum BinaryTree {
case leaf
case node(BinaryTree, BinaryTree)
}
let aTree : BinaryTree = .node(.leaf, . node(.leaf, .leaf))
// attention il existe un bug avec la recursion qui peut produire une recursion infini

//##############################################################################
//ARRAY []

let species = [(001, "bubasaur"), (004, "charmander"), (007, "Squirtle") ]
//idem que pour les variable on peut ajouter les labels
let species2 = [(number: 001, name: "bulebasaur"), (number: 004, name: "Charmander"), (number: 007, name: "Squirtle")]

// pour la création de tableau vide, il faut déclarer son types
// retour une erreur=> let species3 = []
typealias Species3 = (number: Int, name: String)
let species4: [Species3]
species4 = [(number: 001, name: "Bulbasaur4"), (number: 004, name: "charmander"), (number: 007, name: "Squirle")]

//pour une array vide

typealias Species5 = (number: Int, name: String)
let species5 = [Species5]()

// accès aux données
//species4[3].name
print(species4[1].name)
print(species4[2].name)

// les slices
// on peut obtenir les valeurs par des intervalles
print(species4[0 ... 1])
// on peut également obtenir une valeur spécifique de l'intervalles
// attention on doit spécifier l'index de la valeur qui sera stocker dans notre tableau résultat
print(species4[0 ... 1][0].name)

// Connaître le nombre de valeur d'un tableau
print(species4.count)
print("le nombre de valeurs du tableau species4 est de : \(species4.count)")
// ATTention comme d'hab le parcourt du tableau doit aller de 0 à count-1

//creation de tableau mutable on utilise var au lieu de let
var species6 : [Species3]
species6 = [(001, "bubasaur"), (004, "charmander"), (007, "Squirtle") ]
species6[2] = (number: 025, name: "Pickachu")
print(species6[2].name)
species6[1 ... 2] = [(number: 043, name: "oddish"), (number: 016, name: "Pidget")]
print(species6)

// possibilité d'inserer un élément dans une liste et de décaller le rest dans l'indexation
//Array.insert(_:at:)
species6.insert((number: 043, name: "Oddis"), at: 0)
print(species6)

// idem avec remove à la place d'insert
species6.remove(at: 1)
print(species6)

//##############################################################################
//LES SET (SONT DE ARRAY COMME DES MAP SANS ORDRE)
// le plus important est le : Set

let speciesNames: Set = ["bublasar", "charmander", "squirtle"]
// les set empty doive avoir la déclaration de valeurs

let SpeciesNames2 : Set<String> = []

let speciesNames2 = Set<String>()
// Attention les type créent par nous même doivent avoir des propriétés suplémentaires

// pareil que pour les array un set est mutable que avec var devant
//les methode insert et remove idem mais pas d'indexation
var speciesNames3: Set = ["Bulbasaur", "charmander", "Squirtle"]
speciesNames3.insert("Pidgey")
print(speciesNames3.count)
speciesNames3.remove("Pidgey")
print(speciesNames.count)
//si l'élément existe déja dans notre set il ne sera pas ajouté
speciesNames3.insert("Bulbasaur")
print(speciesNames3.count)


//##############################################################################
// LES DICONNAIRES (LES MAP)

enum SpeciesType3 { case grass, fire, water }
let speciesTypes3 = ["bulbasaur": SpeciesType3.grass, "charmander": SpeciesType3.fire]

// la map est sans valeur on doit déclarer les type comme d'hab
//ici String= la clé et SpeciesType3 = la valeur de la clé
let speciesTypes4 : [String: SpeciesType3] = [:]
//ou
let speciesTypes6 = [String: SpeciesType3]()

//pour trouver une valeur par rapport à la clé on fait
print("on obtient la valeur suivante sans !:\(speciesTypes3["bulbasaur"])")
//pour obtenir une valeur non optionel on utilise !
print("on obtient la valeur suivante avec !:\(speciesTypes3["bulbasaur"]!)")


// comme pour tout le rest si on utilise var la map est mutable

enum SpeciesType5 { case grass, fire, water }
var speciesTypes5 = ["bubasar": SpeciesType5.grass, "Charmander": SpeciesType5.fire]

print("on obtient la map suivante: \n\(speciesTypes5)")
// on peut donc changer les valeurs associées aux clés

speciesTypes5["bubasar"] = .water

// ajout de valeurs

speciesTypes5["oddish"] = .grass

// en supprimant une valeur de clé on supprime également la clé de la map
speciesTypes5["Charmander"] = nil
print("on obtient la map modifiée suivante: \n\(speciesTypes5)")

//##############################################################################
// LES STRUCTURES
// on doit specifier si on a des variables ou des constantes dans la structure

typealias Species11 = (number: Int, name: String)
struct Pokemon {
  let species: Species11
  var level: Int
}
var rainer = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
let sparky = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)

print(rainer.level)

rainer.level = rainer.level + 1
print(rainer.level)
// Attention idem que pour les constants on ne peut pas réattribuer une valeurs au objet let
//##############################################################################
//OPTIONAL CHAINING
// on utilis les optional chaining pour attribuer une valeur à une var que si elle est vide
// pour ce faire on doit encapsuler l'objet dans un optional type
var rainer2: Pokemon? = Pokemon(species: (number: 134, name: "Vaporeon"), level: 58)
print(rainer2?.level)
// si la var est vide on ne pourra pas ajouter 87 sinon oui
rainer2 = nil
print("avec encapsulation optionnel: \(rainer2?.level)")
rainer2?.level = 87
print("apprait réattribution de valeur: rainer2?.level = 87  retourne \(rainer2?.level)")
print("Donc rien a changé")

//##############################################################################
//LES CLASSES

typealias Species7 = (number: Int, name: String)
class Pokemon1 {
  let species7: Species7
  var level: Int

  init (species7: Species7, level: Int) {
  self.species7 = species7
  self.level = level
  }

}
// Grace au class on peut modifier les valeurs des objet constant
let sparky1 = Pokemon1(species7: (number: 135, name: "jolteon"), level: 31)
print("le niveau du sparky.level est : \(sparky1.level)")
sparky1.level = sparky1.level + 1
print("le niveau du sparky.level est : \(sparky1.level)")

//néanmoins sparky n'est pas reassignable
//sparky = rainer2 retourne une erreur

// Attention si on attribue une valeur qui pointe à une autre valeur elle SONT
// liée est les valeurs changes pour les deux
var sparky2 = Pokemon1(species7: (number: 135, name: "jolteon"), level: 31)
var another = sparky2
sparky2.level = sparky2.level + 1
print("level de sparky2 : \(sparky2.level) le level de another\(another.level)")
//Important
// on peut eviter ce problem avec les STRUCTURES
var sparky3 = Pokemon(species: (number: 135, name: "Jolteon"), level: 31)
var another1 = sparky3
sparky3.level = sparky3.level + 1
print("level de sparky3 structure : \(sparky3.level) le level de another1 structure est \(another1.level)")

// on peut vérifier si deux class on la même référence Attention c'est trois ===
print("Vérification des références pour les class: \(sparky2===another)" )

//##############################################################################
//##############################################################################
//##############################################################################
//CONTROL FLOW
//##############################################################################
//##############################################################################
//##############################################################################

let pokemonLevel1 = 38;

if pokemonLevel1 > 30 {
  print("the pokemeon won't obey")
  }
  else
  {
    print("the pokemon will obey")
  }

//Condition avec les optionnels

let pokemonLevel2 : Int? = 38

if let level = pokemonLevel2 {
  print("the pokemon level is \(level)")
}
else {
  print("The pokemon level is unknown")
}

// même chose sans les optionnels
if pokemonLevel1 != nil {
  print("the pokemon level is \(pokemonLevel1)")

}
else {
  print("the pokemon level is unknown")
}

let level4 = pokemonLevel1 ?? 1
// retourn le nom de la variable si rien n'est contenu dedans sinon la valeur

indirect enum SpeciesType10 {
case dual( primary: SpeciesType, secondary: SpeciesType)

}
//Extraction des types
// on fait juste une inversion pour le controlle la variable est égaliser à la fin = lotadType
let lotadType = SpeciesType10.dual(primary : .water, secondary: .grass)
if case .dual(primary: let primary, secondary: let secondary ) = lotadType {
  print("Lotad has two types: \(primary) and \(secondary)")
}

// on voit que les référence au valeur de l'objet est donné par le case
let pokemon2 = (number: 001, name: "Bulbasaur")
if case let (number: x, name: y ) = pokemon2 {
  print("\(y) has number \(x)")
}
if case 0 ... 10 = pokemon2.number {
  print("the pokemon number is comprised between 0 and 10")
}

// on peut ajouter des condition la virgule prend le rôle de and
if case let (number: x, name: y) = pokemon, x > 50 {
  print("\(y) has a number greater than 50")
}
if case let x = pokemon2.number, x > 50 {
  print("the pokemon number is greater than 50")
}

//OPERATIONS TERNAIRES _?_:_
//(ressemble au if un bloc (oprande,opsiTrue,opsiFalse)

//rappel typealias Species = (number: Int, name: String)
let pokemon3 = (number: 001, name: "Bulbasaur")
let another4 = pokemon3.number == 001 ? pokemon: (number: 002, name: "Ivysaur")
print("another4 case true= \(another4)")

let another5 = pokemon3.number == 002 ? pokemon: (number: 002, name: "Ivysaur")
print("another5 case false = \(another5)")

//LES SWITCH
// les switch en swift peuvent servir d'extracteur(patern matching)
//Attention les switch doivent couvrir toutes les possibilités autrement erreur
let pokemonLevel3 = 31
switch pokemonLevel3 {
case 50 ... 100:
  print("the pokemon won't obey unless we have 4 badges")
case 30 ... 100:
  print(" the pokemon won't obey unless we have 2 badges")
default:
  print("the pokemon will obey")
}
//sans un default ne marchera pas

// si plusieurs case on le même resultat on peut les separer par une virgule
let pokemonlevel4 = 4
switch pokemonlevel4 {
case 2,4,6:
  print("the pokemon level is 2 , 4  or 6 ")
default:
  break
}

// parterne matching

//rappel typealisa Species11 = (number: Int, name: String)
//        struct Pokemon {
//        let species: Species11
//        var level: Int
//}
// let sparky = Pokemon(species: Number: 135, name: "jolteon"), level: 31
switch sparky {
case let pokemon where pokemon.species.name == "Jolteon":
  print("the pokemon is a jolteon with level \(pokemon.level)")
case let pokemon where pokemon.level > 50:
  print("the pokemon won 't obey unless we have 4 badges")
default:
   break
}

//avec les indirect enum

//on utilise SpeciesType10
// on utilise loatedType

switch lotadType {
case .dual(primary: let primary, secondary : let secondary):
  print("the pokemon has 2 types : \(primary) and \(secondary)")
default:
  print("the pokemon has 1 type: \(lotadType)")
}
// pour utiliser plusieurs condition dans le switch on ulise le where qui représente le and
 let someTuple = (2, 10)

switch someTuple {
case let(x, y) where x > y:
  print("x et plus grand que y true" )
case let(x, y) where x < y:
  print("x est plus grand que y false")
default:
  break
}


//LES BOUCLES
//FOR

var speciesNames4 = ["Bulbasaur", "Charmander", "Squirtle"]
for i in 0 ... 2 {
  print(speciesNames4[i])
}
// avec 0 ..< 2 exclut le 2
//

//iterations sur les séquences
let chainedeCaracteres = "kljagkéak"
for character in chainedeCaracteres.characters {
  print(character)

}

// pour les set map et array

//array
typealias Species22 = (number: Int, name: String)
let species23: [Species22] = [(number: 001, name: "bulb"),(number: 004, name: "charm"),(number: 007, name: "squid")]
//Set
let species24: Set = ["bulb", "charm", "squid"]
//Map
enum SpeciesType6 { case grass, fire, water }
let speciesTypes25 = ["bulbasaur": SpeciesType6.grass, "charmander": SpeciesType6.fire]

//pour les array
for oneSpecies in species23 {
  print(oneSpecies.name)
}

//pour les Set
for oneSpecies in species24 {
  print(oneSpecies)
}

//pour les Map
for (SpeciesName, SpeciesType) in speciesTypes25 {
  print("species : \(SpeciesName) et son type : \(SpeciesType)")
}
// ou pour les map
for case let (name, _) in speciesTypes25 where name.hasSuffix("aur") {
  print(name)
}

//BOUCLE while
let evolutions = ["Bulbauser": "Ivysaur", "Ivysaur": "Venusaur"]
var pokemon4 = (level: 1, species: "Bulbauser")
while evolutions[pokemon4.species] != nil {
  pokemon4 = (level: pokemon4.level, species: evolutions[pokemon4.species]!)
}
print("Boucle while: \(pokemon4)")

//repeat while

repeat {
  pokemon4 = (level: pokemon4.level, species: evolutions[pokemon4.species]!)
} while evolutions[pokemon4.species] != nil
print("boucle repeat while : \(pokemon4)")

//CONTINUE
// pour forcer l'iteration dans le cas ou on a rien au dans les premières valeurs
// boucle qui ne s'arrête pas
/*
repeat {
  if pokemon4.species == "Ivysaur" {
    continue
  }
pokemon4 = (level: pokemon4.level, species: evolutions[pokemon4.species]!)
print(pokemon)
}while evolutions[pokemon4.species] != nil
*/


//BREAK
// permet de sortir du while si problème avec une des valeurs
/*
repeat {
  if pokemon4.species ==  "Ivysaur" {
    break
  }
  pokemon4 = (level: pokemon4.level, species: evolutions[pokemon4.species]!)
} while evolutions[pokemon4.species] != nil
print("boucle avec break \(pokemon4)")
*/
//LABELISATON DES BOUCLES
//CONTINUE AND BREAK sont utiliser pour choisir quel boucle conviendra en fonction des conditions

enum SpeciesType26 { case grass, fire, water }
struct Pokemon2 {
  let species: (number: Int, name: String)
  var level: Int
}
let speciesTypes27 = ["Bulbasaur": SpeciesType26.grass, "Charmander": SpeciesType26.fire]
let pokemons = [
  Pokemon2(species: (number: 001, name: "Bulbasaur"), level: 01),
  Pokemon2(species: (number: 004, name: "Charmander"), level: 01)
  ]

var result : Pokemon2? = nil
outer: for pokemon in pokemons {
  inner: for (name, speciesType) in speciesTypes27{
    if( name == pokemon.species.name) && (speciesType == .grass) {
      result = pokemon
      break outer
    }
  }
}

print("DernierExerciceBoucle les resultat est \(result) ")

//GUARD utiliser à la place du if pour do then inverser
//utilisation de struct Pokemon
let bulby = Pokemon2(species: (number: 001, name: "Bulbasaur"), level: 8)
switch bulby {
case let pokemon where pokemon.species.name == "Bulbasaur":
  guard pokemon.level >= 16 else {
    print("the Pokemon cannot evolve yet")
    break
  }
  print("the pokemon can evolve")
default:
  break
}
