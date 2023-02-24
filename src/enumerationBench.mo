import E "mo:base/ExperimentalInternetComputer";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Buffer "mo:base/Buffer";
import Order "mo:base/Order";
import Prim "mo:⛔";
import Vector "mo:mrr/Vector";
import Enumeration "mo:mrr/Enumeration";

actor {
  type Tree = {
    #node : ({ #R; #B }, Tree, Nat, Tree);
    #leaf;
  };

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

  func print(message : Text, f : () -> ()) {
    Debug.print(message # ": " # Nat64.toText(E.countInstructions(f)));
  };

  public query func profile_rb_tree() : async () {
    let r = RNG();
    let t = Enumeration.Enumeration();
    var first = r.blob();
    var middle = r.blob();
    var last = r.blob();

    var i = 0;
    while (i < n) {
      let b = r.blob();
      if (i == 0) first := b;
      if (i == 2 ** 11) middle := b;
      if (i == n - 1) last := b;
      t.add(b);
      i += 1;
    };

    print("first", func() = ignore (t.lookup(first)));
    print("middle", func() = ignore (t.lookup(middle)));
    print("last", func() = ignore (t.lookup(last)));

    var key = t.get(root(t.tree));
    print("root", func() = ignore (t.lookup(key)));

    let (max_d, max_key1) = max_leaf(t.tree);
    let max_key = t.get(max_key1);
    print("max leaf " # Nat.toText(max_d), func() = ignore (t.lookup(max_key)));

    let (min_d, min_key1) = min_leaf(t.tree);
    let min_key = t.get(min_key1);
    print("min leaf " # Nat.toText(min_d), func() = ignore (t.lookup(min_key)));

    key := t.get(leftmost(t.tree));
    print("leftmost", func() = ignore (t.lookup(key)));

    key := t.get(rightmost(t.tree));
    print("rightmost", func() = ignore (t.lookup(key)));

    key := r.with_byte(255);
    print("max blob", func() = ignore (t.lookup(key)));

    key := r.with_byte(0);
    print("min blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));

    key := r.blob();
    print("random blob", func() = ignore (t.lookup(key)));
  };

  func root(t : Tree) : Nat {
    switch (t) {
      case (#node(_, _, key, _)) key;
      case (#leaf) Prim.trap("ff");
    };
  };

  func leftmost(t : Tree) : Nat {
    switch (t) {
      case (#node(_, #leaf, key, _)) key;
      case (#node(_, left, _, _)) leftmost(left);
      case (#leaf) Prim.trap("");
    };
  };

  func rightmost(t : Tree) : Nat {
    switch (t) {
      case (#node(_, _, key, #leaf)) key;
      case (#node(_, _, _, right)) rightmost(right);
      case (#leaf) Prim.trap("");
    };
  };

  func max_leaf(t : Tree) : (Nat, Nat) {
    switch (t) {
      case (#node(_, #leaf, key, #leaf)) {
        (1, key);
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

  func min_leaf(t : Tree) : (Nat, Nat) {
    switch (t) {
      case (#node(_, #leaf, key, #leaf)) {
        (1, key);
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
};