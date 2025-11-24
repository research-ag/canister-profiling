import Sort "mo:radix-sort";
import Table "utils/table";
import VarArray "mo:core/VarArray";
import Debug "mo:core/Debug";
import Nat32 "mo:core/Nat32";

module {
  public func profile() {
    let n = 2 ** 16;
    let t = Table.Table(n, 2);

    t.stat_average(
      "sort",
      [
        ?(
          func() {
            let a = VarArray.tabulate<(Nat32, Nat)>(n, func i = (Nat32.fromNat(i), i));
            func() = VarArray.sortInPlace(a, func(a, b) = Nat32.compare(a.0, b.0));
          }
        ),
        ?(
          func() {
            let a = VarArray.tabulate<(Nat32, Nat)>(n, func i = (Nat32.fromNat(i), i));
            func() = Sort.radixSort(a, func a = a.0);
          }
        ),
      ],
    );

    Debug.print(t.output(["VarArray", "Radix sort"]));
  };
};
