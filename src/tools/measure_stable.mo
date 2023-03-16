import Debug "mo:base/Debug";
import Prim "mo:⛔";
import StableMemory "mo:base/ExperimentalStableMemory";

actor class MeasureStable(f : shared () -> async {}) {
  let memoryUsage = StableMemory.stableVarQuery();

  Debug.print(debug_show ("constructor", Prim.rts_heap_size(), null, Prim.performanceCounter(0), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions()));

  stable var data = null : ?{};

  public shared func init() : async () {
    Debug.print(debug_show ("before init", Prim.rts_heap_size(), (await memoryUsage()).size, Prim.performanceCounter(0), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions()));
    data := ?(await f());
    Debug.print(debug_show ("after init", Prim.rts_heap_size(), (await memoryUsage()).size, Prim.performanceCounter(0), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions()));
  };

  public shared func test() : async () {
    Debug.print(debug_show ("test", Prim.rts_heap_size(), (await memoryUsage()).size, Prim.performanceCounter(0), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions()));
  };
};
