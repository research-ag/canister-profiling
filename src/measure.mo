import Cycles "mo:base/ExperimentalCycles";
import A "measure_actor";

module {
  public func measure(f : shared () -> async {}) : async () {
    Cycles.add(3_000_000_000_000);
    let m = await A.Measure(f);
    await m.init();
    await m.test();
  };
};
