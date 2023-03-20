import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";

actor {
  Measure.header();
  Measure.test("before constructor");
  stable var data = null : ?Any;

  public shared func init(name : Text) : async () {
    let f = Create.get_stable(name);
    await Measure.test_async("before init");
    data := ?f();
    Measure.test("after init");
    await Measure.test_async("after init collected");
  };

  system func preupgrade() = Measure.test("preupgrade");

  system func postupgrade() = Measure.test("postupgrade");

  public shared func test() : async () = async await Measure.test_async("test");
};
