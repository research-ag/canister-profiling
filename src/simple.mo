import Array "mo:base/Array";
import Enumeration "mo:mrr/Enumeration";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Prim "mo:⛔";

actor {
  let a = Prim.rts_heap_size();
  let t = #leaf : Enumeration.Tree;
  let b = Prim.rts_heap_size();
  let x = #red(#leaf, 0, #leaf) : Enumeration.Tree;
  let c = Prim.rts_heap_size();
  Debug.print(debug_show (a, b, c));
};
