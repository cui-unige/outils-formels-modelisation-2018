//variable
var pokemonLevel = 1
pokemonLevel = 2
//constantes
let pokemonSpecies = "Bulbasaur"
pokemonSpecies = "Pikachu" //retourne une erreur car est une constantes
print( pokemonLevel)
print("The level of my pokemon is\(pokemonLevel).")

//les types
let pokemonWeight: Double=5.1

//let pokemonVeight: Double
 //renvoi une erreur de constantes car on doit initializer la value dans sa déclaration
 let x, y : Int

//AFFICHAGE

print(type(of: pokemonWeight))

print(type(of: "Pikachu"))

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
var trainer1: String? = "ASh"

var trainer2: String = trainer1!

//trainer1 = nil
//trainer2 = trainer1! // la valeur est null on peut pas appliquer l'ASSIGNATION

// Les Tuples
