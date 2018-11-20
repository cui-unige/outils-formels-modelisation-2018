public struct InhibitorNet<Place> where Place: Hashable {

  // Struct that represents an transition of a Petri net extended with inhibitor arcs.
//here
public struct Transition: Hashable {

   public init(name: String, pre: [Place: Arc], post: [Place: Arc]) {
     for (_, arc) in post {
       guard case .regular = arc
         else { preconditionFailure() }
     }

     self.name = name
     self.preconditions = pre
     self.postconditions = post
   }

   public let name: String
   public let preconditions: [Place: Arc]
   public let postconditions: [Place: Arc]

   /// A method that returns whether a transition is fireable from a given marking.
   public func isFireable(from marking: [Place: Int]) -> Bool {
     // Write your code here.

       for (place, arc) in self.preconditions{

       switch(arc){
       case let .regular(Int: preVal):
                         guard marking[place]! >= preVal else { return false }

       case .inhibitor :
                         guard marking[place]! == 0 else { return false }
       }
     }
     return true
 }

   /// A method that fires a transition from a given marking.
   ///
   /// If the transition isn't fireable from the given marking, the method returns a `nil` value.
   /// otherwise it returns the new marking.
   public func fire(from marking: [Place: Int]) -> [Place: Int]? {
     // Write your code here.
     var newMarking = marking
     if !isFireable(from : marking){
         return nil
     }
     else{

           for (place, arc) in self.preconditions{

                 switch(arc){
                 case let .regular(Int: preVal):
                                         newMarking[place] = newMarking[place]! - preVal
                       case .inhibitor :
                                         newMarking[place] = newMarking[place]!
               }

           }

           for (place, arc) in self.postconditions{

                 switch(arc){
                 case let .regular(Int: postVal):
                                         newMarking[place] = newMarking[place]! + postVal
                       case .inhibitor :
                                         newMarking[place] = newMarking[place]!
                 }

           }

     }
         return newMarking
   }

 }

  /// Struct that represents an arc of a Petri net extended with inhibitor arcs.
  public enum Arc: Hashable {

    case inhibitor
    case regular(Int)

  }

  public init(places: Set<Place>, transitions: Set<Transition>) {
    self.places = places
    self.transitions = transitions
  }

  public let places: Set<Place>
  public let transitions: Set<Transition>

}
