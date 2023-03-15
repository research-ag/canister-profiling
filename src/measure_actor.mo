import Debug "mo:base/Debug";
import Prim "mo:⛔";

actor class Measure(f : shared () -> async {}) = {
  var data = null : ?{};

  public shared func init() : async () {
    Debug.print(debug_show (Prim.rts_heap_size()));
    data := ?(await f());
    Debug.print(debug_show (Prim.rts_heap_size()));
  };

  public shared func test() : async () {
    Debug.print(debug_show (Prim.rts_heap_size()));
  };
};
