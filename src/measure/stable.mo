import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";

actor {
  Measure.test("before constructor");
  stable var data = null : ?Any;
  Measure.test("after constructor");

  public shared func init(name : Text) : async () {
    await Measure.test_async("before init");
    data := ?Create.get(name)();
    await Measure.test_async("after init");
  };

  system func preupgrade() = Measure.test("preupgrade");

  system func postupgrade() = Measure.test("postupgrade");

  public shared func test() : async () = async await Measure.test_async("test");
};
