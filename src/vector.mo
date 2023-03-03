import Vector "mo:mrr/Vector";
import E "mo:base/ExperimentalInternetComputer";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";

actor {
  let n = 1000;

  func print(message : Text, f : () -> ()) {
    Debug.print(message # " " # Nat64.toText(E.countInstructions(f)));
  };

  let stats = Buffer.Buffer<(Text, Nat, Nat)>(0);

  func stat(method : Text, vector : () -> (() -> ()), buffer : () -> (() -> ())) {
    stats.add((method, Nat64.toNat(E.countInstructions(vector())), Nat64.toNat(E.countInstructions(buffer()))));
  };

  public query func profile() : async () {
    stat(
      "init",
      func() {
        func() {
          ignore Vector.init<Nat>(n, 0);
        };
      },
      func() = func() = ignore Buffer.Buffer<Nat>(n),
    );

    stat(
      "addMany",
      func() {
        let a = Vector.new<Nat>();
        func() {
          Vector.addMany(a, n, 0);
        };
      },
      func() = func() = (),
    );

    stat(
      "clone",
      func() {
        let a = Vector.init<Nat>(n, 0);
        func() {
          ignore Vector.clone(a);
        };
      },
      func() {
        let a = Buffer.Buffer<Nat>(0);
        func() = ignore Buffer.clone(a);
      },
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
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
    );

    stat(
      "append",
      func() {
        let a = Vector.new<Nat>();
        let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
        func() {
          Vector.append(a, b);
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
    );

    stat(
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
    );

    stat(

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
    );

    stat(
      "toArray",
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
    );

    stat(
      "fromArray",
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
    );

    var result = "\n|method|vector|buffer|\n|---|---|\n";
    for ((method, vector, buffer) in stats.vals()) {
      result #= "|" # method # "|" # Nat.toText(vector) # "|" # Nat.toText(buffer) # "|\n";
    };
    Debug.print(result);
  };
};
