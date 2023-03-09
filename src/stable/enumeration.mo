import Array "mo:base/Array";
import Enumeration "mo:mrr/Enumeration";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";

actor {
  func create(left : Int, right : Int) : Enumeration.Tree {
    if (left > right) {
      #leaf;
    } else {
      let middle = (left + right) / 2;
      #red(create(left, middle - 1), Int.abs(middle), create(middle + 1, right));
    };
  };

  let n = 2 ** 24;
  let array = Array.init<Nat8>(29, 0);

  stable var state = (
    create(0, n - 1),
    Array.tabulate<Blob>(n, func(i) = Blob.fromArrayMut(array)),
    n,
  );
};
