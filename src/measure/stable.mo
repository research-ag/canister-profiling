import Vector "mo:mrr/Vector";
import V "../vector";
import Enumeration "mo:mrr/Enumeration";
import E "../enumeration";
import RbTree "mo:base/RBTree";
import Measure "../utils/measure";
import Create "create";
import Option "mo:base/Option";
import Prim "mo:⛔";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Table "../utils/table";

actor {
  // let name = "vector";
  // type Type = Vector.Vector<Nat>;
  // let f : () -> Type = V.create_stable;

  // let name = "array";
  // type Type = [var Nat];
  // let f : () -> Type = V.array_stable;

  // let name = "enumeration";
  // type Type = (Enumeration.Tree, [var Blob], Nat);
  // let f = E.create_stable;

  let name = "rb_tree";
  type Type = RbTree.Tree<Blob, Nat>;
  let f = E.rb_tree_stable;

  let m = Measure.Measure(false);
  m.header();
  m.test("before constructor");
  stable var data = null : ?Type;

  public shared func init() : async () {
    m.test("before init");
    data := ?f();
    m.test("after init");
  };

  system func preupgrade() = m.test("preupgrade");

  system func postupgrade() = m.test("postupgrade");

  public shared func test() : async () = async m.test("test");

  public shared func summarize() : async () = async {
    let a = Prim.rts_mutator_instructions();
    let b = (await Prim.stableVarQuery()()).size;

    Debug.print(
      Table.format_table(
        "Stable profiling",
        [
          "mutator instructions",
          "stable var query",
        ],
        [(
          name,
          [
            debug_show a,
            debug_show b,
          ].vals(),
        )].vals(),
      )
    );
  };
};
