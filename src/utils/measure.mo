import Debug "mo:base/Debug";
import Prim "mo:⛔";

module {
  public func test(time : Text) {
    Debug.print(
      debug_show (
        time,
        Prim.rts_heap_size(),
        Prim.rts_mutator_instructions(),
        Prim.rts_collector_instructions(),
        Prim.performanceCounter(0),
      )
    );
  };

  public func test_async(time : Text) : async () {
    Debug.print(
      debug_show (
        time,
        Prim.rts_heap_size(),
        Prim.rts_mutator_instructions(),
        Prim.rts_collector_instructions(),
        Prim.performanceCounter(0),
        (await Prim.stableVarQuery()()).size,
      )
    );
  };
};
