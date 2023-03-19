import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";

actor {
  Measure.test("before constructor");
  var vector = null : ?Any;
  Measure.test("after constructor");

  public shared func init(name : Text) : async () {
    await Measure.test_async("before init");
    vector := ?Create.get(name)();
    await Measure.test_async("after init");
  };

  public shared func test() : async () = async await Measure.test_async("test");
};
