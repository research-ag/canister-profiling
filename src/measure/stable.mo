import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";

actor {
  Measure.test("before constructor");
  stable var data = null : ?Any;

  public shared func init(name : Text) : async () {
    let f = Create.get_stable(name);
    await Measure.test_async("before init");
    data := ?f();
    await Measure.test_async("after init");
  };

  system func preupgrade() = Measure.test("preupgrade");

  system func postupgrade() = Measure.test("postupgrade");

  public shared func test() : async () = async await Measure.test_async("test");
};
