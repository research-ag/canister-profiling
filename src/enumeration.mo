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
import Buffer "mo:base/Buffer";
import RbTree "mo:base/RBTree";
import OrderedMap "mo:base/OrderedMap";
import Map "mo:zhus/Map";
import Prng "mo:prng";
import StableEnumeration "mo:stable_enumeration";
import StableTrie "mo:stable-trie/Enumeration";

module {
  let KEY_SIZE = 29;

  class RNG() {
    let r = Prng.Seiran128();
    r.init(0);

    public func blob() : Blob {
      let a = Array.tabulate<Nat8>(KEY_SIZE, func(i) = Nat8.fromNat(Nat64.toNat(r.next()) % 256));
      Blob.fromArray(a);
    };

    public func with_byte(byte : Nat8) : Blob {
      let a = Array.tabulate<Nat8>(KEY_SIZE, func(i) = byte);
      Blob.fromArray(a);
    };
  };

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
    let array = Array.init<Nat8>(KEY_SIZE, 0);

    (
      create(0, n - 1),
      Array.tabulateVar<Blob>(n, func(i) = Blob.fromArrayMut(array)),
      n,
    );
  };

  public func rb_tree_stable() : RbTree.Tree<Blob, Nat> {
    let array = Array.init<Nat8>(KEY_SIZE, 0);

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

  public func stable_enumeration() : StableEnumeration.StableData {
    let n = 2 ** 12;
    let enumeration = StableEnumeration.Enumeration();
    let r = RNG();
    var i = 0;
    while (i < n) {
      ignore enumeration.add(r.blob());
      i += 1;
    };
    enumeration.share();
  };

  public func create_heap() : () -> Any = func() {
    let n = 2 ** 12;
    // let enumeration = Enumeration.Enumeration();
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
    let n = 2 ** 12;
    let rb = RbTree.RBTree<Blob, Nat>(Blob.compare);
    let r = RNG();
    var i = 0;
    while (i < n) {
      rb.put(r.blob(), i);
      i += 1;
    };
    rb;
  };

  public func profile() {
    type Tree = RbTree.Tree<Blob, Nat>;
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
        case (#node(_, left, _key, #leaf)) {
          let (x, y) = max_leaf(left);
          (x + 1, y);
        };
        case (#node(_, #leaf, _key, right)) {
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
        case (#node(_, left, _key, #leaf)) {
          let (x, y) = min_leaf(left);
          (x + 1, y);
        };
        case (#node(_, #leaf, _key, right)) {
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

    let stats = Buffer.Buffer<(Text, Nat, Nat, Nat, Nat, Nat, Nat)>(0);
    let r = RNG();
    var blobs = Array.tabulate<Blob>(n, func(i) = r.blob());
    let enumeration = Enumeration.Enumeration<Blob>(Blob.compare, "");
    let rb = RbTree.RBTree<Blob, Nat>(Blob.compare);
    let ops = OrderedMap.Make<Blob>(Blob.compare);
    var orderedMap = ops.empty<Nat>();

    let { bhash } = Map;
    let zhus = Map.new<Blob, Nat>();

    let stable_enum = StableEnumeration.Enumeration();

    let trie = StableTrie.Enumeration({
      pointer_size = 4;
      aridity = 4;
      root_aridity = ?(4 ** 6);
      key_size = KEY_SIZE;
      value_size = 0;
    });
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
        0,
        0,
        0,
      ));
    };

    let _mem = (
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
            orderedMap := ops.put(orderedMap, blobs[i], i);
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
      memory(
        func() {
          var i = 0;
          while (i < n) {
            ignore stable_enum.add(blobs[i]);
            i += 1;
          };
        }
      ),
      memory(
        func() {
          var i = 0;
          while (i < n) {
            ignore trie.add(blobs[i], "");
            i += 1;
          };
        }
      ),
    );

    func addForArray(m : Text, a : [Blob]) {
      stats.add((
        m,
        average(a, func(b) = ignore enumeration.lookup(b)),
        average(a, func(b) = ignore rb.get(b)),
        average(a, func(b) = ignore ops.get(orderedMap, b)),
        average(a, func(b) = ignore Map.get(zhus, bhash, b)),
        average(a, func(b) = ignore stable_enum.lookup(b)),
        average(a, func(b) = ignore trie.lookup(b)),
      ));
    };

    addForArray("random blobs outside average", Array.tabulate<Blob>(m, func(i) = blobs[i * m]));
    addForArray("random blobs inside average", Array.tabulate<Blob>(m, func(i) = r.blob()));

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
    result #= "|method|enumeration|red-black tree|ordered-map|zhus|stable enum|stable trie|\n|---|---|---|---|---|---|---|\n";
    for ((method, enumeration, rb, om, zh, st, tr) in stats.vals()) {
      result #= "|" # method # "|" # Nat.toText(enumeration) # "|" # Nat.toText(rb) # "|" # Nat.toText(om) # "|" # Nat.toText(zh) # "|" # Nat.toText(st) # "|" # Nat.toText(tr) # "|\n";
    };

    result #= "\n";

    result #= "min leaf in enumeration: " # Nat.toText(min_leaf(enumeration_tree).0) # "\n\n";
    result #= "min leaf in red-black tree: " # Nat.toText(min_leaf(rb_tree).0) # "\n\n";
    result #= "max leaf in enumeration: " # Nat.toText(max_leaf(enumeration_tree).0) # "\n\n";
    result #= "max leaf in red-black tree: " # Nat.toText(max_leaf(rb_tree).0) # "\n\n";

    Debug.print(result);
  };
};
