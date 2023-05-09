import Vector "mo:vector";
import VectorClass "mo:vector/Class";
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
  public func create_heap() : () -> Any {
    func() {
      let n = 10_000_000;
      let a = Vector.new<Nat>();
      var i = 0;
      while (i < n) {
        Vector.add(a, i);
        i += 1;
      };
      a;
    };
  };

  public func create_stable() : Vector.Vector<Nat> {
    let n = 10_000_000;
    Vector.init<Nat>(n, 0);
  };

  public func array_heap() : () -> Any = func() {
    let n = 10_000_000;
    Array.init<Nat>(n, 0);
  };

  public func array_stable() : [var Nat] {
    let n = 10_000_000;
    Array.init<Nat>(n, 0);
  };

  public func buffer_heap() : () -> Any = func() {
    let n = 10_000_000;
    let a = Buffer.Buffer<Nat>(0);
    var i = 0;
    while (i < n) {
      a.add(i);
      i += 1;
    };
    a;
  };

  public func profile() {
    let n = 100_000;
    let t = Table.Table(n, 4);
    t.stat_average(
      "init",
      [
        ?(func() = func() = ignore Vector.init<Nat>(n, 0)),
        ?(func() = func() = ignore VectorClass.init<Nat>(n, 0)),
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
            let a = VectorClass.Vector<Nat>();
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
            let a = VectorClass.Vector<Nat>();
            func() = ignore VectorClass.clone(a);
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
            let a = VectorClass.Vector<Nat>();
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
            func() {
              ignore VectorClass.indexOf(1, a, Nat.equal);
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
            let a = VectorClass.init<Nat>(n, 0);
            func() {
              ignore VectorClass.lastIndexOf(1, a, Nat.equal);
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
            let a = VectorClass.init<Nat>(n, 0);
            func() = VectorClass.iterate(a, func(x : Nat) = ());
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
            let a = VectorClass.init<Nat>(n, 0);
            func() = VectorClass.iterateRev(a, func(x : Nat) = ());
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
            let a = VectorClass.init<Nat>(n, 0);
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
      "iterateItems",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            let f = func(i : Nat, x : Nat) {};
            func() {
              Vector.iterateItems<Nat>(a, f);
            };
          }
        ),
        null,
        null,
        null,
      ],
    );

    t.stat_average(
      "iterateItemsRev",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            let f = func(i : Nat, x : Nat) {};
            func() {
              Vector.iterateItemsRev<Nat>(a, f);
            };
          }
        ),
        null,
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
            let a = VectorClass.Vector<Nat>();
            let b = Array.vals(Array.freeze(Array.init<Nat>(n, 0)));
            func() {
              VectorClass.addFromIter(a, b);
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
            let a = VectorClass.init<Nat>(n, 0);
            func() {
              ignore VectorClass.toArray(a);
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
              ignore VectorClass.fromArray(a);
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
            let a = VectorClass.init<Nat>(n, 0);
            func() {
              ignore VectorClass.toVarArray(a);
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
              ignore VectorClass.fromVarArray(a);
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
            let a = VectorClass.init<Nat>(n, 0);
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

    t.stat_average(
      "contains",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.contains(a, 1, Nat.equal);
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
              ignore Buffer.contains(a, 1, Nat.equal);
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
      "max",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.max(a, Nat.compare);
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
              ignore Buffer.max(a, Nat.compare);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.foldLeft<Nat, Nat>(a, a[0], Nat.max);
          }
        ),
      ],
    );

    t.stat_average(
      "min",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.min(a, Nat.compare);
            };
          }
        ),
        null,
        ?(
          func() {
            let a = Buffer.Buffer<Nat>(0);
            var i = 0;
            while (i < n) {
              a.add(i);
              i += 1;
            };
            func() {
              ignore Buffer.min(a, Nat.compare);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.foldLeft<Nat, Nat>(a, a[0], Nat.min);
          }
        ),
      ],
    );

    t.stat_average(
      "equal",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            let b = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.equal<Nat>(a, b, Nat.equal);
            };
          }
        ),
        null,
        ?(
          func() {
            let a = Buffer.Buffer<Nat>(0);
            let b = Buffer.Buffer<Nat>(0);
            var i = 0;
            while (i < n) {
              a.add(i);
              b.add(i);
              i += 1;
            };
            func() {
              ignore Buffer.equal(a, b, Nat.equal);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            let b = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.equal<Nat>(a, b, Nat.equal);
          }
        ),
      ],
    );

    t.stat_average(
      "compare",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            let b = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.compare<Nat>(a, b, Nat.compare);
            };
          }
        ),
        null,
        ?(
          func() {
            let a = Buffer.Buffer<Nat>(0);
            let b = Buffer.Buffer<Nat>(0);
            var i = 0;
            while (i < n) {
              a.add(i);
              b.add(i);
              i += 1;
            };
            func() {
              ignore Buffer.compare(a, b, Nat.compare);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            let b = Array.freeze(Array.init<Nat>(n, 0));
            // TODO: not quite the same
            func() = ignore Array.equal<Nat>(a, b, Nat.equal);
          }
        ),
      ],
    );

    t.stat_average(
      "toText",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.toText<Nat>(a, Nat.toText);
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
              ignore Buffer.toText(a, Nat.toText);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(10, 0));
            // TODO: not quite the same, has extra comma
            func() = ignore "[" # Array.foldRight<Nat, Text>(a, "", func(x, acc) = Nat.toText(x) # ", " # acc) # "]";
          }
        ),
      ],
    );

    t.stat_average(
      "foldLeft",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.foldLeft<Nat, Nat>(a, 0, func(acc, x) = acc + x);
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
              ignore Buffer.foldLeft<Nat, Nat>(a, 0, func(acc, x) = acc + x);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.foldLeft<Nat, Nat>(a, 0, func(acc, x) = acc + x);
          }
        ),
      ],
    );

    t.stat_average(
      "foldRight",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.foldRight<Nat, Nat>(a, 0, func(x, acc) = x + acc);
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
              ignore Buffer.foldRight<Nat, Nat>(a, 0, func(x, acc) = x + acc);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.foldRight<Nat, Nat>(a, 0, func(x, acc) = x + acc);
          }
        ),
      ],
    );

    t.stat_average(
      "reverse",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              Vector.reverse(a);
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
              Buffer.reverse<Nat>(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.reverse<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "reversed",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              ignore Vector.reversed(a);
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
              Buffer.reverse<Nat>(a);
            };
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Array.reverse<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "isEmpty",
      [
        ?(
          func() {
            let a = Vector.init<Nat>(n, 0);
            func() {
              var i = 0;
              while (i < n) {
                ignore Vector.isEmpty(a);
                i += 1;
              };
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
              var i = 0;
              while (i < n) {
                ignore Buffer.isEmpty(a);
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
                ignore a.size() == 0;
                i += 1;
              };
            };
          }
        ),
      ],
    );

    Debug.print(t.output(["vector", "vector class", "buffer", "array"]));
  };
};
