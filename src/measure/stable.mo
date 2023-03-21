import Vector "mo:mrr/Vector";
import V "../vector";
import Measure "../utils/measure";
import Create "create";

actor {
  type Type = Vector.Vector<Nat>; // Chnage Type
  let f : () -> Type = V.create_stable; // Change f

  Measure.header();
  Measure.test("before constructor");
  stable var data = null : ?Type;

  public shared func init() : async () {
    await Measure.test_async("before init");
    data := ?f();
    Measure.test("after init");
    await Measure.test_async("after init collected");
  };

  system func preupgrade() = Measure.test("preupgrade");

  system func postupgrade() = Measure.test("postupgrade");

  public shared func test() : async () = async await Measure.test_async("test");
};
