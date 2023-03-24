import Vector "mo:mrr/Vector";
import V "../vector";
import Measure "../utils/measure";
import Create "create";
import Option "mo:base/Option";
import Prim "mo:⛔";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

actor {
  type Type = Vector.Vector<Nat>; // Chnage Type
  let f : () -> Type = V.create_stable; // Change f

  Measure.header();
  Measure.test("before constructor");
  stable var data = null : ?Type;

  public shared func init() : async () {
    Measure.test("before init");
    data := ?f();
    Measure.test("after init");
  };

  system func preupgrade() = Measure.test("preupgrade");

  system func postupgrade() = Measure.test("postupgrade");

  public shared func test() : async () = async await Measure.test_async("test");

  public shared func summarize() : async () = async {
    let a = Prim.rts_mutator_instructions();
    let b = (await Prim.stableVarQuery()()).size;
    Debug.print(debug_show {
      mutator_instructions = a;
      stable_var_query = b;
    });
  };
};
