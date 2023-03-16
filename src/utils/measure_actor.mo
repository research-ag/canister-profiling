import Debug "mo:base/Debug";
import Prim "mo:⛔";

actor class Measure(f : shared () -> async Any) = {
  func print(time : Text) {
    Debug.print(debug_show (time, Prim.rts_heap_size(), Prim.rts_mutator_instructions(), Prim.rts_collector_instructions()));
  };

  print("constructor");
  var data = null : ?Any;

  public shared func init() : async () {
    print("before init");
    data := ?(await f());
    print("after init");
  };

  public shared func test() : async () {
    print("test");
  };
};
