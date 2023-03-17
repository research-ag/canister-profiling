import Vector "mo:mrr/Vector";
import Enumeration "mo:mrr/Enumeration";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Prim "mo:⛔";
import Int "mo:base/Int";

module {
  public func create_stable() : Any {
    func create(left : Int, right : Int) : Enumeration.Tree {
      if (left > right) {
        null;
      } else {
        let middle = (left + right) / 2;
        ?(#R, create(left, middle - 1), Int.abs(middle), create(middle + 1, right));
      };
    };
    let n = 2 ** 24;
    let array = Array.init<Nat8>(29, 0);

    let e = Enumeration.Enumeration();
    e.unsafeUnshare((
      create(0, n - 1),
      Array.tabulateVar<Blob>(n, func(i) = Blob.fromArrayMut(array)),
      n,
    ));
  };

  public func create_heap() : Any {
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
    let enumeration = Enumeration.Enumeration();
    let r = RNG();
    var i = 0;
    while (i < n) {
      ignore enumeration.add(r.blob());
      i += 1;
    };
    enumeration;
  };
};
