import Vector "mo:mrr/Vector";
import E "mo:base/ExperimentalInternetComputer";
import StableMemory "mo:base/ExperimentalStableMemory";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Prim "mo:⛔";

actor {
  let n = 100000;

  type Func = ?(() -> (() -> ()));

  func print(message : Text, f : () -> ()) {
    Debug.print(message # " " # Nat64.toText(E.countInstructions(f)));
  };

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

  let stats = Buffer.Buffer<(Text, ?(Nat, Nat), ?(Nat, Nat), ?(Nat, Nat))>(0);

  func stat(method : Text, vector : Func, buffer : Func, array : Func) {
    stats.add((
      method,
      bench_one(vector),
      bench_one(buffer),
      bench_one(array),
    ));
  };

  func stat_average(method : Text, vector : Func, buffer : Func, array : Func) {
    stats.add((
      method,
      becnh_average(vector),
      becnh_average(buffer),
      becnh_average(array),
    ));
  };

  public query func profile() : async () {
    stat_average(
      "init",
      ?(func() = func() = ignore Vector.init<Nat>(n, 0)),
      ?(func() = func() = ignore Buffer.Buffer<Nat>(n)),
      ?(func() = func() = ignore Array.init<Nat>(n, 0)),
    );

    stat_average(
      "addMany",
      ?(
        func() {
          let a = Vector.new<Nat>();
          func() {
            Vector.addMany(a, n, 0);
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "clone",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.clone(a);
          };
        },
      ),
      ?(
        func() {
          let a = Buffer.Buffer<Nat>(0);
          var i = 0;
          while (i < n) {
            a.add(0);
            i += 1;
          };
          func() = ignore Buffer.clone(a);
        },
      ),
      null,
    );

    stat_average(
      "add",
      ?(
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
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "get",
      ?(
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
      ),
      ?(
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
      ),
      ?(
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
      ),
    );

    stat_average(
      "getOpt",
      ?(
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
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "put",
      ?(
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
      ),
      ?(
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
      ),
      ?(
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
      ),
    );

    stat_average(
      "size",
      ?(
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
      ),
      ?(
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
      ),
      ?(
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
      ),
    );

    stat_average(
      "removeLast",
      ?(
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
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "indexOf",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.indexOf(1, a, Nat.equal);
          };
        },
      ),
      ?(
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
      ),
      ?(
        func() {
          let a = Array.freeze(Array.init<Nat>(n, 0));
          func() = ignore Array.find(a, func(x : Nat) : Bool = x == 1);
        },
      ),
    );

    stat_average(
      "firstIndexWith",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.firstIndexWith(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "lastIndexOf",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.lastIndexOf(1, a, Nat.equal);
          };
        },
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "lastIndexWith",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.lastIndexWith(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "forAll",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.forAll(a, func(x : Nat) : Bool = x == 0);
          };
        },
      ),
      ?(
        func() {
          let a = Buffer.Buffer<Nat>(0);
          var i = 0;
          while (i < n) {
            a.add(0);
            i += 1;
          };
          func() {
            ignore Buffer.forAll(a, func(x : Nat) : Bool = x == 0);
          };
        },
      ),
      null,
    );

    stat_average(
      "forSome",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.forSome(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      ?(
        func() {
          let a = Buffer.Buffer<Nat>(0);
          var i = 0;
          while (i < n) {
            a.add(0);
            i += 1;
          };
          func() {
            ignore Buffer.forSome(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      null,
    );

    stat_average(
      "forNone",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.forNone(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      ?(
        func() {
          let a = Buffer.Buffer<Nat>(0);
          var i = 0;
          while (i < n) {
            a.add(0);
            i += 1;
          };
          func() {
            ignore Buffer.forNone(a, func(x : Nat) : Bool = x == 1);
          };
        },
      ),
      null,
    );

    stat_average(
      "vals",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            for (x in Vector.vals(a)) {
              ignore x;
            };
          };
        },
      ),
      ?(
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
      ),
      ?(
        func() {
          let a = Array.init<Nat>(n, 0);
          func() {
            for (x in a.vals()) {
              ignore x;
            };
          };
        },
      ),
    );

    stat_average(
      "items",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            for (x in Vector.items(a)) {
              ignore x;
            };
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "valsRev",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            for (x in Vector.valsRev(a)) {
              ignore x;
            };
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "itemsRev",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            for (x in Vector.itemsRev(a)) {
              ignore x;
            };
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "keys",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            for (x in Vector.keys(a)) {
              ignore x;
            };
          };
        },
      ),
      null,
      null,
    );

    stat_average(
      "addFromIter",
      ?(
        func() {
          let a = Vector.new<Nat>();
          let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
          func() {
            Vector.addFromIter(a, b);
          };
        },
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "toArray",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.toArray(a);
          };
        },
      ),
      ?(
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
      ),
      null,
    );

    stat_average(
      "fromArray",
      ?(
        func() {
          let a = Array.freeze(Array.init<Nat>(n, 0));
          func() {
            ignore Vector.fromArray(a);
          };
        },
      ),
      ?(
        func() {
          let a = Array.freeze(Array.init<Nat>(n, 0));
          func() {
            ignore Buffer.fromArray(a);
          };
        },
      ),
      null,
    );

    stat_average(
      "toVarArray",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            ignore Vector.toVarArray(a);
          };
        },
      ),
      ?(
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
      ),
      ?(
        func() {
          let a = Array.freeze(Array.init<Nat>(n, 0));
          func() {
            ignore Array.thaw(a);
          };
        },
      ),
    );

    stat_average(
      "fromVarArray",
      ?(
        func() {
          let a = Array.init<Nat>(n, 0);
          func() {
            ignore Vector.fromVarArray(a);
          };
        },
      ),
      ?(
        func() {
          let a = Array.init<Nat>(n, 0);
          func() {
            ignore Buffer.fromVarArray(a);
          };
        },
      ),
      ?(
        func() {
          let a = Array.init<Nat>(n, 0);
          func() {
            ignore Array.freeze(a);
          };
        },
      ),
    );

    stat(
      "clear",
      ?(
        func() {
          let a = Vector.init<Nat>(n, 0);
          func() {
            Vector.clear(a);
          };
        },
      ),
      ?(
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
      ),
      null,
    );

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

    var result = "\nn = " # Nat.toText(n) # "\n";

    result #= "\nTime:\n\n|method|vector|buffer|array|\n|---|---|---|---|\n";
    for ((method, vector, buffer, array) in stats.vals()) {
      result #= "|" # method # "|" # first(vector) # "|" # first(buffer) # "|" # first(array) # "|\n";
    };

    result #= "\nMemory:\n\n|method|vector|buffer|array|\n|---|---|---|---|\n";
    for ((method, vector, buffer, array) in stats.vals()) {
      result #= "|" # method # "|" # second(vector) # "|" # second(buffer) # "|" # second(array) # "|\n";
    };
    Debug.print(result);
  };

  let m = 1_000_000;

  func measure_stable(f : () -> ()) : async Text {
    let memoryUsage = StableMemory.stableVarQuery();
    let before = (await memoryUsage()).size;
    f();
    let after = (await memoryUsage()).size;
    debug_show (after - before);
  };

  stable var state_vector = Vector.new<Nat>();
  stable var state_array = [var] : [var Nat];

  public shared func profile_stable() : async () {
    Debug.print(await measure_stable(func() = state_vector := Vector.init<Nat>(m, 0)));
    Debug.print(await measure_stable(func() = state_array := Array.init<Nat>(m, 0)));
  };
};
