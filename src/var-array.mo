import Table "utils/table";
import Nat "mo:core/Nat";
import VarArray "mo:core/VarArray";
import Refactored "mo:refactored/VarArray";
import Debug "mo:core/Debug";

module {
  public func profile() {
    let n = 100_000;
    let t = Table.Table(n, 2);

    t.stat_average(
      "sortInPlace",
      [
        ?(
          func() {
            let a = VarArray.repeat<Nat>(0, n);
            func() = VarArray.sortInPlace(a, Nat.compare);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = Refactored.sortInPlace(a, Nat.compare);
          }
        ),
      ],
    );

    Debug.print(t.output(["VarArray", "Refactored"]));
  };
};
