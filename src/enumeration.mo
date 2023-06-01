import Enumeration "mo:enumeration";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Prim "mo:⛔";
import Int "mo:base/Int";
import E "mo:base/ExperimentalInternetComputer";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import RBTree "mo:base/RBTree";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Order "mo:base/Order";
import RbTree "mo:base/RBTree";
import Map "mo:zhus/Map";
import Map7 "mo:motoko-hash-map/Map";
import BTree "mo:stableheapbtreemap/BTree";

module {
  public func create_stable() : (Enumeration.Tree, [var Blob], Nat) {
    func create(left : Int, right : Int) : Enumeration.Tree {
      if (left > right) {
        null;
      } else {
        let middle = (left + right) / 2;
        ?(#R, create(left, middle - 1), Int.abs(middle), create(middle + 1, right));
      };
    };
    let n = 2 ** 20;
    let array = Array.init<Nat8>(29, 0);

    (
      create(0, n - 1),
      Array.tabulateVar<Blob>(n, func(i) = Blob.fromArrayMut(array)),
      n,
    );
  };

  public func rb_tree_stable() : RbTree.Tree<Blob, Nat> {
    let array = Array.init<Nat8>(29, 0);

    func create(left : Int, right : Int) : RbTree.Tree<Blob, Nat> {
      if (left > right) {
        #leaf;
      } else {
        let middle = (left + right) / 2;
        #node(#R, create(left, middle - 1), (Blob.fromArrayMut(array), ?Int.abs(middle)), create(middle + 1, right));
      };
    };

    let n = 2 ** 20;
    create(0, n - 1);
  };

  // Blob 29bit

  public func create_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let enumeration = Enumeration.Enumeration<Blob>(Blob.compare, "");
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore enumeration.add(r.blob());
      i += 1;
    };
    enumeration;
  };

  public func rb_tree_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let rb = RBTree.RBTree<Blob, Nat>(Blob.compare);
    let r = RNG();
    var i = 0;

    while (i < n) {
      rb.put(r.blob(), i);
      i += 1;
    };
    rb;
  };

  public func b_tree_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let bt = BTree.init<Blob, Nat>(?29);
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore BTree.insert<Blob, Nat>(bt, Blob.compare, r.blob(), i);
      i += 1;
    };
    bt;
  };

  public func zhus_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let hash = Map.bhash;
    let map = Map.new<Blob, Nat>(hash);
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map.set(map, hash, r.blob(), i);
      i += 1;
    };
    map;
  };

  public func zhus7_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let hash = Map7.bhash;
    let map = Map7.new<Blob, Nat>();
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map7.set(map, hash, r.blob(), i);
      i += 1;
    };
    map;
  };

  // Nat

  public func create_nat_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let enumeration = Enumeration.Enumeration<Nat>(Nat.compare, 0);
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore enumeration.add(r.next());
      i += 1;
    };
    enumeration;
  };

  public func rb_tree_nat_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let rb = RBTree.RBTree<Nat, Nat>(Nat.compare);
    let r = RNG();
    var i = 0;

    while (i < n) {
      rb.put(r.next(), i);
      i += 1;
    };
    rb;
  };

  public func b_tree_nat_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let bt = BTree.init<Nat, Nat>(null);
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore BTree.insert<Nat, Nat>(bt, Nat.compare, r.next(), i);
      i += 1;
    };
    bt;
  };

  public func zhus_nat_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let hash = Map.nhash;
    let map = Map.new<Nat, Nat>(hash);
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map.set(map, hash, r.next(), i);
      i += 1;
    };
    map;
  };

  public func zhus7_nat_heap() : () -> Any = func() {

    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };
    let n = 2 ** 12;
    let hash = Map7.nhash;
    let map = Map7.new<Nat, Nat>();
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map7.set(map, hash, r.next(), i);
      i += 1;
    };
    map;
  };

  // Nat64

  public func create_nat64_heap() : () -> Any = func() {

    class RNG() {
      var seed : Nat64 = 234234;

      public func next() : Nat64 {
        seed += 1;
        let a : Nat64 = seed * 15485863;
        a *% a *% a % 2038074743;
      };
    };
    let n = 2 ** 12;
    let enumeration = Enumeration.Enumeration<Nat64>(Nat64.compare, 0);
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore enumeration.add(r.next());
      i += 1;
    };
    enumeration;
  };

  public func rb_tree_nat64_heap() : () -> Any = func() {

    class RNG() {
      var seed : Nat64 = 234234;

      public func next() : Nat64 {
        seed += 1;
        let a = seed * 15485863;
        a *% a *% a % 2038074743;
      };
    };
    let n = 2 ** 12;
    let rb = RBTree.RBTree<Nat64, Nat>(Nat64.compare);
    let r = RNG();
    var i = 0;

    while (i < n) {
      rb.put(r.next(), i);
      i += 1;
    };
    rb;
  };

  public func b_tree_nat64_heap() : () -> Any = func() {

    class RNG() {
      var seed : Nat64 = 234234;

      public func next() : Nat64 {
        seed += 1;
        let a = seed * 15485863;
        a *% a *% a % 2038074743;
      };
    };
    let n = 2 ** 12;
    let bt = BTree.init<Nat64, Nat>(?64);
    let r = RNG();
    var i = 0;

    while (i < n) {
      ignore BTree.insert<Nat64, Nat>(bt, Nat64.compare, r.next(), i);
      i += 1;
    };
    bt;
  };

  public func zhus_nat64_heap() : () -> Any = func() {

    class RNG() {
      var seed : Nat64 = 234234;

      public func next() : Nat64 {
        seed += 1;
        let a : Nat64 = seed * 15485863;
        a *% a *% a % 2038074743;
      };
    };
    let n = 2 ** 12;
    let hash = Map.n64hash;
    let map = Map.new<Nat64, Nat>(hash);
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map.set(map, hash, r.next(), i);
      i += 1;
    };
    map;
  };

  public func zhus7_nat64_heap() : () -> Any = func() {

    class RNG() {
      var seed : Nat64 = 234234;

      public func next() : Nat64 {
        seed += 1;
        let a = seed * 15485863;
        a *% a *% a % 2038074743;
      };
    };
    let n = 2 ** 12;

    let hash : Map7.HashUtils<Nat64> =
      ( func key { var hash = key;
        hash := hash >> 30 ^ hash *% 0xbf58476d1ce4e5b9;
        hash := hash >> 27 ^ hash *% 0x94d049bb133111eb;
        Prim.nat64ToNat(hash >> 31 ^ hash & 0x3fffffff) },
      func (a, b) { a == b } );
    let map = Map7.new<Nat64, Nat>();
    let r = RNG();
    var i = 0;

    while (i < n) {
      Map7.set(map, hash, r.next(), i);
      i += 1;
    };
    map;
  };

  // --

  public func profile() {
    class RNG() {
      var seed = 234234;

      public func next() : Nat {
        seed += 1;
        let a = seed * 15485863;
        a * a * a % 2038074743;
      };

      public func blob() : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
        Blob.fromArray(a);
      };

      public func with_byte(byte : Nat8) : Blob {
        let a = Array.tabulate<Nat8>(29, func(i) = byte);
        Blob.fromArray(a);
      };
    };

    type Tree = RBTree.Tree<Blob, Nat>;
    let n = 2 ** 12;
    let m = 2 ** 6;

    func toRBTree(t : Enumeration.Tree, a : [var Blob]) : Tree {
      switch (t) {
        case (?(#R, left, key, right)) #node(#R, toRBTree(left, a), (a[key], ?key), toRBTree(right, a));
        case (?(#B, left, key, right)) #node(#B, toRBTree(left, a), (a[key], ?key), toRBTree(right, a));
        case (null) #leaf;
      };
    };

    func root(t : Tree) : Blob {
      switch (t) {
        case (#node(_, _, key, _)) key.0;
        case (#leaf) Prim.trap("ff");
      };
    };

    func leftmost(t : Tree) : Blob {
      switch (t) {
        case (#node(_, #leaf, key, _)) key.0;
        case (#node(_, left, _, _)) leftmost(left);
        case (#leaf) Prim.trap("");
      };
    };

    func rightmost(t : Tree) : Blob {
      switch (t) {
        case (#node(_, _, key, #leaf)) key.0;
        case (#node(_, _, _, right)) rightmost(right);
        case (#leaf) Prim.trap("");
      };
    };

    func max_leaf(t : Tree) : (Nat, Blob) {
      switch (t) {
        case (#node(_, #leaf, key, #leaf)) {
          (1, key.0);
        };
        case (#node(_, left, key, #leaf)) {
          let (x, y) = max_leaf(left);
          (x + 1, y);
        };
        case (#node(_, #leaf, key, right)) {
          let (x, y) = max_leaf(right);
          (x + 1, y);
        };
        case (#node(_, left, _, right)) {
          let a = max_leaf(left);
          let b = max_leaf(right);
          if (a.0 > b.0) { (a.0 + 1, a.1) } else { (b.0 + 1, b.1) };
        };
        case (#leaf) Prim.trap("");
      };
    };

    func min_leaf(t : Tree) : (Nat, Blob) {
      switch (t) {
        case (#node(_, #leaf, key, #leaf)) {
          (1, key.0);
        };
        case (#node(_, left, key, #leaf)) {
          let (x, y) = min_leaf(left);
          (x + 1, y);
        };
        case (#node(_, #leaf, key, right)) {
          let (x, y) = min_leaf(right);
          (x + 1, y);
        };
        case (#node(_, left, _, right)) {
          let a = min_leaf(left);
          let b = min_leaf(right);
          if (a.0 < b.0) { (a.0 + 1, a.1) } else { (b.0 + 1, b.1) };
        };
        case (#leaf) Prim.trap("");
      };
    };

    func memory(f : () -> ()) : Nat {
      let before = Prim.rts_heap_size();
      f();
      let after = Prim.rts_heap_size();
      after - before;
    };

    let stats = Buffer.Buffer<(Text, Nat, Nat, Nat)>(0);
    let r = RNG();
    var blobs = Array.tabulate<Blob>(n, func(i) = r.blob());
    let enumeration = Enumeration.EnumerationBlob();
    let rb = RBTree.RBTree<Blob, Nat>(Blob.compare);

    let { bhash } = Map;
    let zhus = Map.new<Blob, Nat>(bhash);

    func average(blobs : [Blob], get : (Blob) -> ()) : Nat {
      var i = 0;
      var sum = 0;
      while (i < blobs.size()) {
        sum += Nat64.toNat(E.countInstructions(func() = get(blobs[i])));
        i += 1;
      };
      Int.abs(Float.toInt(Float.fromInt(sum) / Float.fromInt(blobs.size())));
    };

    func stat(method : Text, enum_key : Blob, rb_key : Blob) {
      stats.add((
        method,
        Nat64.toNat(E.countInstructions(func() = ignore enumeration.lookup(enum_key))),
        Nat64.toNat(E.countInstructions(func() = ignore rb.get(rb_key))),
        0,
      ));
    };

    let mem = (
      memory(
        func() {
          var i = 0;
          while (i < n) {
            ignore enumeration.add(blobs[i]);
            i += 1;
          };
        }
      ),
      memory(
        func() {
          var i = 0;
          while (i < n) {
            rb.put(blobs[i], i);
            i += 1;
          };
        }
      ),
      memory(
        func() {
          var i = 0;
          while (i < n) {
            ignore Map.put(zhus, bhash, blobs[i], i);
            i += 1;
          };
        }
      ),
    );

    let random = Array.tabulate<Blob>(m, func(i) = blobs[i * m]);
    stats.add((
      "random blobs inside average",
      average(random, func(b) = ignore enumeration.lookup(b)),
      average(random, func(b) = ignore rb.get(b)),
      average(random, func(b) = ignore Map.get(zhus, bhash, b)),
    ));

    let others = Array.tabulate<Blob>(m, func(i) = r.blob());
    stats.add((
      "random blobs average",
      average(others, func(b) = ignore enumeration.lookup(b)),
      average(others, func(b) = ignore rb.get(b)),
      average(random, func(b) = ignore Map.get(zhus, bhash, b)),
    ));

    let (t, a, _) = enumeration.share();
    let enumeration_tree = toRBTree(t, a);
    let rb_tree = rb.share();

    stat("root", root(enumeration_tree), root(rb_tree));

    stat("leftmost", leftmost(enumeration_tree), leftmost(rb_tree));
    stat("rightmost", rightmost(enumeration_tree), rightmost(rb_tree));

    stat("min blob", r.with_byte(0), r.with_byte(0));
    stat("max blob", r.with_byte(255), r.with_byte(255));

    stat("min leaf", min_leaf(enumeration_tree).1, min_leaf(rb_tree).1);
    stat("max leaf", max_leaf(enumeration_tree).1, max_leaf(rb_tree).1);

    var result = "\nTesting for n = " # Nat.toText(n) # "\n\n";
    result #= "|method|enumeration|red-black tree|zhus|\n|---|---|---|---|\n";
    for ((method, enumeration, rb, zh) in stats.vals()) {
      result #= "|" # method # "|" # Nat.toText(enumeration) # "|" # Nat.toText(rb) # "|" # Nat.toText(zh) # "|\n";
    };

    result #= "\n";

    result #= "min leaf in enumeration: " # Nat.toText(min_leaf(enumeration_tree).0) # "\n\n";
    result #= "min leaf in red-black tree: " # Nat.toText(min_leaf(rb_tree).0) # "\n\n";
    result #= "max leaf in enumeration: " # Nat.toText(max_leaf(enumeration_tree).0) # "\n\n";
    result #= "max leaf in red-black tree: " # Nat.toText(max_leaf(rb_tree).0) # "\n\n";

    Debug.print(result);
  };
};
