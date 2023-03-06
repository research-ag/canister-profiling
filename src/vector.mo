import Vector "mo:mrr/Vector";
import E "mo:base/ExperimentalInternetComputer";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";

actor {
  let n = 10000;

  func print(message : Text, f : () -> ()) {
    Debug.print(message # " " # Nat64.toText(E.countInstructions(f)));
  };

  let stats = Buffer.Buffer<(Text, Nat, Nat, Nat)>(0);

  func stat(method : Text, vector : () -> (() -> ()), buffer : () -> (() -> ()), array : () -> (() -> ())) {
    stats.add((
      method,
      Nat64.toNat(E.countInstructions(vector())),
      Nat64.toNat(E.countInstructions(buffer())),
      Nat64.toNat(E.countInstructions(array())),
    ));
  };

  func stat_average(method : Text, vector : () -> (() -> ()), buffer : () -> (() -> ()), array : () -> (() -> ())) {
    stats.add((
      method,
      Nat64.toNat(E.countInstructions(vector())) / n,
      Nat64.toNat(E.countInstructions(buffer())) / n,
      Nat64.toNat(E.countInstructions(array())) / n,
    ));
  };

  public query func profile() : async () {
    stat_average(
      "init",
      func() = func() = ignore Vector.init<Nat>(n, 0),
      func() = func() = ignore Buffer.Buffer<Nat>(n),
      func() = func() = ignore Array.init<Nat>(n, 0),
    );

    stat_average(
      "addMany",
      func() {
        let a = Vector.new<Nat>();
        func() {
          Vector.addMany(a, n, 0);
        };
      },
      func() = func() = (),
      func() = func() = (),
    );

    stat_average(
      "clone",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.clone(a);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() = ignore Buffer.clone(a);
      },
      func() = func() = (),
    );

    stat_average(
      "add",
      func() {
        let a = Vector.new<Nat>();
        func() {
          var i = 0;
          while (i < n) {
            Vector.add(a, 0);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        func() {
          var i = 0;
          while (i < n) {
            a.add(0);
            i += 1;
          };
        };
      },
      func() = func() = (),
    );

    stat_average(
      "get",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore Vector.get(a, i);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          var i = 0;
          while (i < n) {
            ignore a.get(i);
            i += 1;
          };
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore a[i];
            i += 1;
          };
        };
      },
    );

    stat_average(
      "getOpt",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore Vector.getOpt(a, i);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          var i = 0;
          while (i < n) {
            ignore a.getOpt(i);
            i += 1;
          };
        };
      },
      func() = func() = (),
    );

    stat_average(
      "put",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            Vector.put(a, i, 0);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          var i = 0;
          while (i < n) {
            a.put(i, 0);
            i += 1;
          };
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            a[i] := 0;
            i += 1;
          };
        };
      },
    );

    stat_average(
      "size",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore Vector.size(a);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          var i = 0;
          while (i < n) {
            ignore a.size();
            i += 1;
          };
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore a.size();
            i += 1;
          };
        };
      },
    );

    stat_average(
      "removeLast",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          var i = 0;
          while (i < n) {
            ignore Vector.removeLast(a);
            i += 1;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          var i = 0;
          while (i < n) {
            ignore a.removeLast();
            i += 1;
          };
        };
      },
      func() = func() = (),
    );

    stat_average(
      "indexOf",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.indexOf(1, a, Nat.equal);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          ignore Buffer.indexOf(1, a, Nat.equal);
        };
      },
      func() {
        let a = Array.freeze(Array.init<Nat>(n, 0));
        func() = ignore Array.find(a, func(x : Nat) : Bool = x == 1);
      },
    );

    stat_average(
      "lastIndexOf",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.lastIndexOf(1, a, Nat.equal);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          ignore Buffer.lastIndexOf(1, a, Nat.equal);
        };
      },
      func() = func() = (),
    );

    stat_average(
      "vals",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          for (x in Vector.vals(a)) {
            ignore x;
          };
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          for (x in a.vals()) {
            ignore x;
          };
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          for (x in a.vals()) {
            ignore x;
          };
        };
      },
    );

    stat_average(
      "items",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          for (x in Vector.items(a)) {
            ignore x;
          };
        };
      },
      func() = func() = (),
      func() = func() = (),
    );

    stat_average(
      "valsRev",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          for (x in Vector.valsRev(a)) {
            ignore x;
          };
        };
      },
      func() = func() = (),
      func() = func() = (),
    );

    stat_average(
      "itemsRev",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          for (x in Vector.itemsRev(a)) {
            ignore x;
          };
        };
      },
      func() = func() = (),
      func() = func() = (),
    );

    stat_average(
      "keys",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          for (x in Vector.keys(a)) {
            ignore x;
          };
        };
      },
      func() = func() = (),
      func() = func() = (),
    );

    stat_average(
      "append",
      func() {
        let a = Vector.new<Nat>();
        let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
        func() {
          Vector.addFromIter(a, b);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        let b = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          b.add(0);
          i += 1;
        };
        func() {
          a.append(b);
        };
      },
      func() = func() = (),
    );

    stat_average(
      "toArray",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.toArray(a);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          ignore Buffer.toArray(a);
        };
      },
      func() = func() = (),
    );

    stat_average(
      "fromArray",
      func() {
        let a = Array.freeze(Array.init<Nat>(n, 0));
        func() {
          ignore Vector.fromArray(a);
        };
      },
      func() {
        let a = Array.freeze(Array.init<Nat>(n, 0));
        func() {
          ignore Buffer.fromArray(a);
        };
      },
      func() = func() = (),
    );

    stat_average(
      "toVarArray",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.toVarArray(a);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          ignore Buffer.toVarArray(a);
        };
      },
      func() {
        let a = Array.freeze(Array.init<Nat>(n, 0));
        func() {
          ignore Array.thaw(a);
        };
      },
    );

    stat_average(
      "fromVarArray",
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          ignore Vector.fromVarArray(a);
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          ignore Buffer.fromVarArray(a);
        };
      },
      func() {
        let a = Array.init<Nat>(n, 0);
        func() {
          ignore Array.freeze(a);
        };
      },
    );

    stat(
      "clear",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          Vector.clear(a);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        var i = 0;
        while (i < n) {
          a.add(0);
          i += 1;
        };
        func() {
          a.clear();
        };
      },
      func() = func() = (),
    );

    var result = "\n|method|vector|buffer|array|\n|---|---|---|---|\n";
    for ((method, vector, buffer, array) in stats.vals()) {
      result #= "|" # method # "|" # Nat.toText(vector) # "|" # Nat.toText(buffer) # "|" # Nat.toText(array) # "|\n";
    };
    Debug.print(result);
  };
};
