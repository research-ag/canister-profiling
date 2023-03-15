import Cycles "mo:base/ExperimentalCycles";
import A "measure_actor";
import Stable "measure_stable";
import StableMemory "mo:base/ExperimentalStableMemory";
import Debug "mo:base/Debug";
import Prim "mo:⛔";

module {
  public func measure(f : shared () -> async {}) : async () {
    Cycles.add(3_000_000_000_000);
    let m = await A.Measure(f);
    await m.init();
    await m.test();
  };

  public func measure_stable(f : shared () -> async {}) : async () {
    Cycles.add(3_000_000_000_000);
    let m = await Stable.MeasureStable(f);
    await m.init();
    await m.test();
  };

  public func print_in_stable(time : Text) {
    Debug.print(debug_show (time, Prim.rts_heap_size(), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions(), Prim.performanceCounter(0)));
  };
};
