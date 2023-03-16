import Vector "mo:mrr/Vector";
import Prim "mo:⛔";
import Debug "mo:base/Debug";
import Measure "../utils/measure";

actor {
  Measure.print_in_stable("before constructor");
  let n = 200_000_000;
  stable let vector = Vector.init<Nat>(n, 0);
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
