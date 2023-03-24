import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";
import Prim "mo:⛔";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";

actor {
  var heap_with_gc_size = 0;
  var vector = null : Any;

  public shared func init(name : Text) : async () {
    let f = Create.get_heap(name);
    vector := f();
    heap_with_gc_size := Prim.rts_heap_size();
  };

  public shared func test() : async () {
    let heap_size = Prim.rts_heap_size();
    let gc_size = heap_with_gc_size - heap_size;
    Debug.print(debug_show {
      heap_size = heap_size;
      gc_size = gc_size;
      collector_instructions = Prim.rts_collector_instructions();
      mutator_instructions = Prim.rts_mutator_instructions();
    });
  };
};
