import E "mo:base/ExperimentalInternetComputer";
import StableMemory "mo:base/ExperimentalStableMemory";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Prim "mo:⛔";

class Table(n_ : Nat, columns : Nat) {
  let n = n_;
  let cols = columns;
  let stats = Buffer.Buffer<(Text, [?(Nat, Nat)])>(0);

  type Func = ?(() -> (() -> ()));

  func bench_one(a : Func) : ?(Nat, Nat) {
    let ?f = a else return null;
    var b = f();
    let before = Prim.rts_heap_size();
    b();
    let after = Prim.rts_heap_size();
    ?(Nat64.toNat(E.countInstructions(f())), after - before);
  };

  func becnh_average(a : Func) : ?(Nat, Nat) {
    let ?(x, y) = bench_one(a) else return null;
    ?(x / n, y);
  };

  public func stat_one(method : Text, funcs : [Func]) {
    assert funcs.size() == cols;
    stats.add((
      method,
      Array.tabulate<?(Nat, Nat)>(cols, func(i) = bench_one(funcs[i])),
    ));
  };

  public func stat_average(method : Text, funcs : [Func]) {
    assert funcs.size() == cols;
    stats.add((
      method,
      Array.tabulate<?(Nat, Nat)>(cols, func(i) = becnh_average(funcs[i])),
    ));
  };

  func first(x : ?(Nat, Nat)) : Text {
    switch (x) {
      case (null) "-";
      case (?value) Nat.toText(value.0);
    };
  };

  func second(x : ?(Nat, Nat)) : Text {
    switch (x) {
      case (null) "-";
      case (?value) Nat.toText(value.1);
    };
  };

  public func output(columns : [Text]) : Text {
    assert columns.size() == cols;
    var result = "\nn = " # Nat.toText(n) # "\n";
    let header = "\n|method|" # Text.join("|", columns.vals()) # "|";
    let space = "\n|" # Text.join("|", Iter.map(Iter.range(0, cols), func(i : Nat) : Text = "---")) # "|";
    result #= "\nTime:\n" # header # space # "\n";

    for ((method, row) in stats.vals()) {
      result #= "|" # method # "|" # Text.join("|", Iter.map(row.vals(), func(x : ?(Nat, Nat)) : Text = first(x))) # "|\n";
    };

    result #= "\nMemory:\n" # header # space # "\n";
    for ((method, row) in stats.vals()) {
      result #= "|" # method # "|" # Text.join("|", Iter.map(row.vals(), func(x : ?(Nat, Nat)) : Text = second(x))) # "|\n";
    };

    result;
  };
};
