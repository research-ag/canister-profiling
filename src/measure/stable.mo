import Enumeration "mo:enumeration";
import E "../enumeration";
import Measure "../utils/measure";
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

  let name = "enumeration";
  type Type = (Enumeration.Tree, [var Blob], Nat);
  let f = E.create_stable;

  // let name = "rb_tree";
  // type Type = RbTree.Tree<Blob, Nat>;
  // let f = E.rb_tree_stable;

  // let name = "stable_enumeration";
  // type Type = StableEnumeration.StableData;
  // let f = E.stable_enumeration;

  stable var pre = 0 : Nat64;
  stable var post = 0 : Nat64;

  let m = Measure.Measure(true);
  m.header();
  m.test("before constructor");
  stable var data = null : ?Type;

  public shared func init() : async () {
    m.test("before init");
    data := ?f();
    m.test("after init");
  };

  system func preupgrade() {
    m.test("preupgrade");
    pre := Prim.performanceCounter(0);
  };

  system func postupgrade() {
    m.test("postupgrade");
    post := Prim.performanceCounter(0);
  };

  public shared func test() : async () = async m.test("test");

  public shared func summarize() : async () = async {
    let svq = (await Prim.stableVarQuery()()).size;

    Debug.print(
      Table.format_table(
        "Stable profiling",
        [
          "serialization",
          "deserialization",
          "stable var query",
        ],
        [(
          name,
          [
            debug_show pre,
            debug_show post,
            debug_show svq,
          ].vals(),
        )].vals(),
      )
    );
  };
};
