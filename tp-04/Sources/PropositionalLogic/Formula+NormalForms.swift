/*
------------------------------------------------------------------------------
# NAME : Formula+NormalForms.swift
#
# PURPOSE : Extension of Formula : Implementation of NNF, DNF, CNF, MINTERMS of
#           DNF and MAXTERMS of CNF
#
# AUTHOR : Benjamin Fischer
#
# CREATED : 10.11.2018
-----------------------------------------------------------------------------
*/
extension Formula {
  /* NEGATION NORMAL FORM */
  // Formula is in NNF if :
  // 1) negation operators (NOT) is only applied to variables
  // 2) only other boolean operators are conjunction (AND) and disjunction (OR)
  /* DE MORGAN'S LAW */
  // NOT(A OR B) = NOT(A) AND NOT(B)
  // NOT(A AND B) = NOT(A) OR NOT(B)
  public var nnf: Formula {
    /* A == FORMULA | B == FORMULA */
    switch self {
      case .constant(let A) : // formula == constant
        // if(A) then : true else : false
        return A ? true : false // constant boolean value
      case .proposition(_) : // formula == proposition
        return self // proposition
      case .conjunction(let A, let B) : // A ∧ B
        return (A).nnf && (B).nnf // A ∧ B + remove negations
      case .disjunction(let A, let B) : // A ∨ B
        return (A).nnf || (B).nnf // A ∨ B + remove negations
      case .implication(let A, let B) : // A → B == ¬A ∨ B
        return (!A).nnf || (B).nnf // ¬A ∨ B + remove negations
      /* HANDLE NEGATION */
      case .negation(let A) : // ¬(FORMULA)
        switch A {
          case .constant(let A) : // ¬A
            // if(A) then : false else : true
            return A ? false : true // constant boolean value
          // MORGAN : ¬(A ∧ B) == ¬(A) ∨ ¬(B)
          case .conjunction(let A, let B) : // ¬(A ∧ B)
            return (!A).nnf || (!B).nnf // ¬(A) ∨ ¬(B) + remove negations
          // MORGAN : ¬(A ∨ B) == ¬(A) ∧ ¬(B)
          case .disjunction(let A, let B) : // ¬(A ∨ B)
            return (!A).nnf && (!B).nnf // ¬(A) ∧ ¬(B) + remove negations
          case .implication(let A, let B) : // // ¬(A → B)
            return (A).nnf && (!B).nnf // A ∧ ¬B + remove negations
          case .negation(let A) : // ¬(¬A)
            return A.nnf // ¬A + remove negations
          case .proposition(_) : // A == proposition
            return self // propositions
        }
    }
  }
  /* DISJUNCTIVE NORMAL FORM */
  // Formula is in DNF if and only if it is a disjunction (OR) of one or more
  // conjunction(s) (AND) of one or more literal(s)
  // C[1] OR ... OR C[n] where C[i] = l[1] AND ... AND l[m]
  public var dnf: Formula {
    /* A == FORMULA | B == FORMULA */
    // 1rst step : remove implications (→)
    // 2nd step : let negations go down next to variables (MORGAN)
    switch self.nnf { // NNF achieves step 1 and 2
      case .constant(let A) : // formula == constant
        // if(A) then : true else : false
        return A ? true : false // constant boolean value
      case .proposition(_) : // formula == proposition
        return self // proposition
      case .disjunction(let A, let B) : // A ∨ B
        return A.dnf || B.dnf // DNF(A) ∨ DNF(B)
      case .conjunction(let A, let B) : // A ∧ B
        // 3rd step : apply distributivity to let conjunctions go down and disjunctions go up
        // AND-DISTRIBUTIVITY : A ∧ (B ∨ C) ==  (A ∧ B) ∨ (A ∧ C)
        let A_DNF = A.dnf // store DNF of A formula
        let B_DNF = B.dnf // store DNF of B formula
        /* A_DNF == DNF FORMULA | B_DNF == DNF FORMULA */
        switch (A_DNF, B_DNF) {
          case (.disjunction(let A, let B),_) : // (A ∨ B) ∧ B_DNF
            return (A && B_DNF) || (B && B_DNF) // (A ∧ B_DNF) ∨ (B ∧ B_DNF)
          case (_,.disjunction(let A, let B)) : // A_DNF ∧ (A ∨ B)
            return (A_DNF && A) || (A_DNF && B) // (A_DNF ∧ A) ∨ (A_DNF ∧ B)
          default : // case : only propositions
            return A_DNF && B_DNF
        }
      default : // case negation + case implication handled by NNF
        return self.nnf
    }
  }
  /* CONJUNCTIVE NORMAL FORM */
  // Formula is in CNF if and only if it is a conjunction (AND) of one or more
  // disjunction(s) (OR) of one or more literal(s)
  // C[1] AND ... AND C[n] where C[i] = l[1] OR ... OR l[m]
  public var cnf: Formula {
    /* A == FORMULA | B == FORMULA */
    // 1rst step : remove implications (→)
    // 2nd step : let negations go down next to variables (MORGAN)
    switch self.nnf { // NNF achieves step 1 and 2
      case .constant(let A) : // formula == constant
        // if(A) then : true else : false
        return A ? true : false // constant boolean value
      case .proposition(_) : // formula == proposition
        return self // proposition
      case .conjunction(let A, let B) : // A ∧ B
        return A.cnf && B.cnf // CNF(A) ∧ CNF(B)
      case .disjunction(let A, let B) : // A ∨ B
        // 3rd step : apply distributivity to let disjunctions go down and conjunctions go up
        // OR-DISTRIBUTIVITY : A ∨ (B ∧ C) ==  (A ∨ B) ∧ (A ∨ C)
        let A_CNF = A.cnf // store CNF of A formula
        let B_CNF = B.cnf // store CNF of B formula
        /* A_CNF == CNF FORMULA | B_CNF == CNF FORMULA */
        switch (A_CNF, B_CNF) {
          case (.conjunction(let A, let B),_) : // (A ∧ B) ∨ B_CNF
            return (A || B_CNF) && (B || B_CNF) // (A ∨ B_CNF) ∧ (B ∨ C_DNF)
          case (_,.conjunction(let A, let B)) : // A_CNF ∨ (A ∧ B)
            return (A_CNF || A) && (A_CNF || B) // (A_CNF ∨ A) ∧ (A_CNF ∨ B)
          default : // case : only propositions
            return A_CNF || B_CNF
        }
      default : // case negation + case implication handled by NNF
        return self.nnf
    }
  }
  /* MINTERMS OF FORMULA IN DISJUNCTIVE NORMAL FORM */
  // DNF : C[1] OR ... OR C[n] where C[i] = l[1] AND ... AND l[m]
  public var minterms: Set<Set<Formula>> {
    switch self {
    case .disjunction(_,_) : // C[1] ∨ ... ∨ C[n]
        var result : Set<Set<Formula>> = [] // empty list of disjunctive operands
        // loop on C[1], ..., C[n]
        for operand in self.disjunctionOperands {
          // add disjunctive operands to result list
          // l[1] ∧ ... ∧ l[n]
          result.insert(operand.conjunctionOperands)
        }
        return result // list of disjunctive operands
      default : // proposition or other case
        return [] // empty list
    }
  }
  /* MAXTERMS OF FORMULA IN CONJUNCTIVE NORMAL FORM */
  // CNF : C[1] AND .. AND C[n] where C[i] = l[1] OR ... OR l[m]
  public var maxterms: Set<Set<Formula>> {
    switch self {
    case .conjunction(_,_) : // C[1] ∧ ... ∧ C[n]
        var result : Set<Set<Formula>> = [] // empty list of conjunctive operands
        // loop on C[1], ..., C[n]
        // C[i] = l[1] ∨ ... ∨ l[m]
        for operand in self.conjunctionOperands {
          // add conjunctive operands to result list
          result.insert(operand.disjunctionOperands)
        }
        return result // list of conjunctive operands
      default : // proposition or other case
        return [] // empty list
    }
  }

  /// Unfold a tree of binary disjunctions into a set of operands.
  ///
  ///     let f: Formula = .disjunction("a", .disjunction("b", .negation("c")))
  ///     print(disjunctionOperands)
  ///     // Prints "[a, b, ¬c]"
  ///
  private var disjunctionOperands: Set<Formula> {
    switch self {
    case .disjunction(let a, let b):
      return a.disjunctionOperands.union(b.disjunctionOperands)
    default:
      return [self]
    }
  }

  /// Unfold a tree of binary conjunctions into a set of operands.
  ///
  ///     let f: Formula = .conjunction("a", .conjunction("b", .negation("c")))
  ///     print(f.conjunctionOperands)
  ///     // Prints "[a, b, ¬c]"
  ///
  private var conjunctionOperands: Set<Formula> {
    switch self {
    case .conjunction(let a, let b):
      return a.conjunctionOperands.union(b.conjunctionOperands)
    default:
      return [self]
    }
  }

}
