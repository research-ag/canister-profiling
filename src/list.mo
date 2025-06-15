import List "mo:new-base/List";
import Refactored "mo:refactored/List";
import Table "utils/table";
import Debug "mo:base/Debug";

module {
  public func profile() {
    let n = 100_000;
    let t = Table.Table(n, 2);

    t.stat_average(
      "find",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.find<Nat>(a, func(x) = x == 1);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.find<Nat>(a, func(x) = x == 1);
          }
        ),
      ],
    );

    t.stat_average(
      "findIndex",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.findIndex<Nat>(a, func(x) = x == 1);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.findIndex<Nat>(a, func(x) = x == 1);
          }
        ),
      ],
    );

    t.stat_average(
      "all",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.all<Nat>(a, func(x) = x == 0);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.all<Nat>(a, func(x) = x == 0);
          }
        ),
      ],
    );

    t.stat_average(
      "any",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.any<Nat>(a, func(x) = x == 1);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.any<Nat>(a, func(x) = x == 1);
          }
        ),
      ],
    );

    Debug.print(t.output(["List", "Refactored"]));
  };
};
