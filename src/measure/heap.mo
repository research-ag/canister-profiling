import Vector "mo:mrr/Vector";
import Measure "../utils/measure";
import Create "create";
import Prim "mo:⛔";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Table "../utils/table";

actor {
  var name_ = "";
  var heap_with_gc_size = 0;
  var vector = null : Any;

  let m = Measure.Measure(false);
  m.header();
  m.test("before constructor");

  public shared func init(name : Text) : async () {
    name_ := name;
    m.test("before init");
    let f = Create.get_heap(name);
    vector := f();
    heap_with_gc_size := Prim.rts_heap_size();
    m.test("after init");
  };

  public shared func test() : async () {
    m.test("test");
    let heap_size = Prim.rts_heap_size();
    let gc_size = heap_with_gc_size - heap_size;
    Debug.print(
      Table.format_table(
        "Heap profiling",
        ["heap size", "gc size", "collector instructions", "mutator instructions"],
        [(
          name_,
          [
            debug_show heap_size,
            debug_show gc_size,
            debug_show Prim.rts_collector_instructions(),
            debug_show Prim.rts_mutator_instructions(),
          ].vals(),
        )].vals(),
      )
    );
  };
};
