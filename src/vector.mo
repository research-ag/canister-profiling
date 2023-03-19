import Vector "mo:mrr/Vector";
import E "mo:base/ExperimentalInternetComputer";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Prim "mo:⛔";
import Table "utils/table";

module {
  public func create_heap() : Any {
    let n = 10_000_000;
    Vector.init<Nat>(n, 0);
  };

  public func create_stable() : Any {
    let n = 10_000_000;
    Vector.init<Nat>(n, 0);
  };

  public func profile() : Any {
    return 25;
    
    let n = 100_000;
    let t = Table.Table(n, 4);
    t.stat_average(
      "init",
      [
        ?(func() = func() = ignore Vector.init<Nat>(n, 0)),
        ?(func() = func() = ignore Vector.Class.init<Nat>(n, 0)),
        ?(func() = func() = ignore Buffer.Buffer<Nat>(n)),
        ?(func() = func() = ignore Array.init<Nat>(n, 0)),
      ],
    );

    t.stat_average(
      "addMany",
      [
        ?(
          func() {
            let a = Vector.new<Nat>();
            func() = Vector.addMany(a, n, 0);
          }
        ),
        ?(
          func() {
            let a = Vector.Class.Vector<Nat>();
            func() = a.addMany(n, 0);
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "clone",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() = ignore Vector.clone(a);
          }
        ),
        ?(
          func() {
            let a = Vector.Class.Vector<Nat>();
            func() = ignore Vector.Class.clone(a);
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "add",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.Vector<Nat>();
            func() {
              var i = 0;
              while (i < n) {
                a.add(0);
                i += 1;
              };
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "get",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                ignore a.get(i);
                i += 1;
              };
            };
          }
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
          }
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
          }
        ),
      ],
    );

    t.stat_average(
      "getOpt",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                ignore a.getOpt(i);
                i += 1;
              };
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "put",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                a.put(i, 0);
                i += 1;
              };
            };
          }
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
          }
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
          }
        ),
      ],
    );

    t.stat_average(
      "size",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                ignore a.size();
                i += 1;
              };
            };
          }
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
          }
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
          }
        ),
      ],
    );

    t.stat_average(
      "removeLast",
      [
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
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                ignore a.removeLast();
                i += 1;
              };
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "indexOf",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.indexOf(1, a, Nat.equal);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              ignore Vector.Class.indexOf(1, a, Nat.equal);
            };
          }
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
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.find(a, func(x : Nat) : Bool = x == 1);
          }
        ),
      ],
    );

    t.stat_average(
      "firstIndexWith",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.firstIndexWith(a, func(x : Nat) : Bool = x == 1);
            };
          }
        ),
        null,
        null,
        null,
      ],
    );

    t.stat_average(
      "lastIndexOf",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.lastIndexOf(1, a, Nat.equal);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              ignore Vector.Class.lastIndexOf(1, a, Nat.equal);
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "lastIndexWith",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.lastIndexWith(a, func(x : Nat) : Bool = x == 1);
            };
          }
        ),
        null,
        null,
        null,
      ],
    );

    t.stat_average(
      "forAll",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.forAll(a, func(x : Nat) : Bool = x == 0);
            };
          }
        ),
        null,
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "forSome",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.forSome(a, func(x : Nat) : Bool = x == 1);
            };
          }
        ),
        null,
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "forNone",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.forNone(a, func(x : Nat) : Bool = x == 1);
            };
          }
        ),
        null,
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "iterate",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() = Vector.iterate(a, func(x : Nat) = ());
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() = Vector.Class.iterate(a, func(x : Nat) = ());
          }
        ),
        ?(
          func() {
            let a = Buffer.Buffer<Nat>(0);
            var i = 0;
            while (i < n) {
              a.add(0);
              i += 1;
            };
            func() = Buffer.iterate(a, func(x : Nat) = ());
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "iterateRev",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() = Vector.iterateRev(a, func(x : Nat) = ());
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() = Vector.Class.iterateRev(a, func(x : Nat) = ());
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "vals",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              for (x in Vector.vals(a)) {
                ignore x;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              for (x in a.vals()) {
                ignore x;
              };
            };
          }
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
          }
        ),
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() {
              for (x in a.vals()) {
                ignore x;
              };
            };
          }
        ),
      ],
    );

    t.stat_average(
      "items",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              for (x in Vector.items(a)) {
                ignore x;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              for (x in a.items()) {
                ignore x;
              };
            };
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "valsRev",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              for (x in Vector.valsRev(a)) {
                ignore x;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              for (x in a.valsRev()) {
                ignore x;
              };
            };
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "itemsRev",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              for (x in Vector.itemsRev(a)) {
                ignore x;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              for (x in a.itemsRev()) {
                ignore x;
              };
            };
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "keys",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              for (x in Vector.keys(a)) {
                ignore x;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              for (x in a.keys()) {
                ignore x;
              };
            };
          }
        ),
        null,
        null,
      ],
    );

    t.stat_average(
      "addFromIter",
      [
        ?(
          func() {
            let a = Vector.new<Nat>();
            let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
            func() {
              Vector.addFromIter(a, b);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.Vector<Nat>();
            let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
            func() {
              Vector.Class.addFromIter(a, b);
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "toArray",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.toArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              ignore Vector.Class.toArray(a);
            };
          }
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
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "fromArray",
      [
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() {
              ignore Vector.fromArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() {
              ignore Vector.Class.fromArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() {
              ignore Buffer.fromArray(a);
            };
          }
        ),
        null,
      ],
    );

    t.stat_average(
      "toVarArray",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.toVarArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              ignore Vector.Class.toVarArray(a);
            };
          }
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
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() {
              ignore Array.thaw(a);
            };
          }
        ),
      ],
    );

    t.stat_average(
      "fromVarArray",
      [
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() {
              ignore Vector.fromVarArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() {
              ignore Vector.Class.fromVarArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() {
              ignore Buffer.fromVarArray(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() {
              ignore Array.freeze(a);
            };
          }
        ),
      ],
    );

    t.stat_one(
      "clear",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              Vector.clear(a);
            };
          }
        ),
        ?(
          func() {
            let a = Vector.Class.init<Nat>(n, 0);
            func() {
              a.clear();
            };
          }
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
          }
        ),
        null,
      ],
    );
    Debug.print(t.output(["vector", "vector class", "buffer", "array"]));
  };
};
