import E "mo:base/ExperimentalInternetComputer";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Prim "mo:⛔";

module {
  public func format_table(name : Text, columns : [Text], iter : Iter.Iter<(Text, Iter.Iter<Text>)>) : Text {
    let header = "\n|method|" # Text.join("|", columns.vals()) # "|";
    let space = "\n|" # Text.join("|", Iter.map(Iter.range(0, columns.size()), func(_ : Nat) : Text = "---")) # "|";
    var result = "\n" # name # ":\n" # header # space # "\n";
    for ((method, row) in iter) {
      result #= "|" # method # "|" # Text.join("|", row) # "|\n";
    };
    result;
  };

  public class Table(n_ : Nat, columns : Nat) {
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

    public func stat_one(method : Text, funcs : [Func]) {
      stat_average_n(method, 1, funcs);
    };

    public func stat_average(method : Text, funcs : [Func]) {
      stat_average_n(method, n, funcs);
    };

    public func stat_average_n(method : Text, n : Nat, funcs : [Func]) {
      assert funcs.size() == cols;
      stats.add((
        method,
        Array.tabulate<?(Nat, Nat)>(
          cols,
          func(i) {
            let ?(x, y) = bench_one(funcs[i]) else return null;
            ?(x / n, y);
          },
        ),
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

      result #= format_table(
        "Time",
        columns,
        Iter.map(
          stats.vals(),
          func((method, row) : (Text, [?(Nat, Nat)])) : ((Text, Iter.Iter<Text>)) {
            let y : Iter.Iter<Text> = Iter.map(row.vals(), func(x : ?(Nat, Nat)) : Text = first(x));
            (method, y);
          },
        ),
      );

      result #= format_table(
        "Memory",
        columns,
        Iter.map(
          stats.vals(),
          func((method, row) : (Text, [?(Nat, Nat)])) : ((Text, Iter.Iter<Text>)) {
            let y : Iter.Iter<Text> = Iter.map(row.vals(), func(x : ?(Nat, Nat)) : Text = second(x));
            (method, y);
          },
        ),
      );

      result;
    };
  };
};
