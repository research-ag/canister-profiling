import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";

actor {
  Measure.header();
  Measure.test("before constructor");
  var vector = null : Any;

  public shared func init(name : Text) : async () {
    let f = Create.get_heap(name);
    await Measure.test_async("before init");
    vector := f();
    Measure.test("after init");
    await Measure.test_async("after init collected");
  };

  public shared func test() : async () = async await Measure.test_async("test");
};
