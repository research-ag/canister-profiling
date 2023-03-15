import Array "mo:base/Array";
import Enumeration "mo:mrr/Enumeration";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Int "mo:base/Int";
import Debug "mo:base/Debug";
import Prim "mo:⛔";
import Measure "../tools/measure";

actor {
  func create(left : Int, right : Int) : Enumeration.Tree {
    if (left > right) {
      null;
    } else {
      let middle = (left + right) / 2;
      ?(#R, create(left, middle - 1), Int.abs(middle), create(middle + 1, right));
    };
  };

  Measure.print_in_stable("before constructor");

  let n = 2 ** 24;
  let array = Array.init<Nat8>(29, 0);

  stable var state = (
    create(0, n - 1),
    Array.tabulate<Blob>(n, func(i) = Blob.fromArrayMut(array)),
    n,
  );

  Measure.print_in_stable("after constructor");

  system func preupgrade() {
    Measure.print_in_stable("preupgrade");
  };

  system func postupgrade() {
    Measure.print_in_stable("postupgrade");
  };

  public query func test() : async () {
    Measure.print_in_stable("test");
  };
};
