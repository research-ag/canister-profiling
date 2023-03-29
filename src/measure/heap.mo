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
  var mutator_instructions = 0 : Nat64;
  var collector_instructions = 0;
  var data = null : Any;
  var work_f : () -> Any = func() = ();

  let m = Measure.Measure(true);
  m.header();
  m.test("before constructor");

  let init_heap_size = Prim.rts_heap_size();

  public shared func init(name : Text) : async () {
    name_ := name;
    m.test("before init");

    let f = Create.get_heap(name);
    work_f := f();

    m.test("after init");
  };

  public shared func run() : async () {
    m.test("before run");

    heap_with_gc_size := Prim.rts_heap_size();
    mutator_instructions := Prim.performanceCounter(0);

    data := work_f();
    // cleanup captured data
    work_f := func() = ();

    mutator_instructions := Prim.performanceCounter(0) - mutator_instructions;
    heap_with_gc_size := Prim.rts_heap_size() - heap_with_gc_size;

    m.test("after run");
  };

  public shared func test() : async () {
    m.test("test");
    let heap_size : Int = Prim.rts_heap_size() - init_heap_size;
    let gc_size : Int = heap_with_gc_size - heap_size;
    Debug.print(
      Table.format_table(
        "Heap profiling",
        [
          "heap size",
          "gc size",
          "collector instructions",
          "mutator instructions",
        ],
        [(
          name_,
          [
            debug_show heap_size,
            debug_show gc_size,
            debug_show Prim.rts_collector_instructions(),
            debug_show mutator_instructions,
          ].vals(),
        )].vals(),
      )
    );
  };
};
