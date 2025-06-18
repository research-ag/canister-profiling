import List "mo:core/List";
import Refactored "mo:refactored/List";
import Table "utils/table";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat "mo:core/Nat";

module {
  public func profile() {
    let n = 100_000;
    let t = Table.Table(n, 2);

    t.stat_average(
      "get",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                ignore List.get<Nat>(a, i);
                i += 1;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                ignore Refactored.get<Nat>(a, i);
                i += 1;
              };
            };
          }
        ),
      ],
    );

    t.stat_average(
      "getOpt",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                ignore List.getOpt<Nat>(a, i);
                i += 1;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                ignore Refactored.getOpt<Nat>(a, i);
                i += 1;
              };
            };
          }
        ),
      ],
    );

    t.stat_average(
      "put",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                List.put<Nat>(a, i, 1);
                i += 1;
              };
            };
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() {
              var i = 0;
              while (i < n) {
                Refactored.put<Nat>(a, i, 1);
                i += 1;
              };
            };
          }
        ),
      ],
    );

    t.stat_average(
      "forEach",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = List.forEach<Nat>(a, func(x) = ());
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = Refactored.forEach<Nat>(a, func(x) = ());
          }
        ),
      ],
    );

    t.stat_average(
      "reverseForEach",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = List.reverseForEach<Nat>(a, func(x) = ());
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = Refactored.reverseForEach<Nat>(a, func(x) = ());
          }
        ),
      ],
    );

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
      "findLastIndex",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.findLastIndex<Nat>(a, func(x) = x == 1);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.findLastIndex<Nat>(a, func(x) = x == 1);
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

    t.stat_average(
      "repeat",
      [
        ?(func() = func() = ignore List.repeat<Nat>(0, n)),
        ?(func() = func() = ignore Refactored.repeat<Nat>(0, n)),
      ],
    );

    t.stat_average(
      "fromArray",
      [
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore List.fromArray<Nat>(a);
          }
        ),
        ?(
          func() {
            let a = Array.freeze(Array.init<Nat>(n, 0));
            func() = ignore Refactored.fromArray<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "fromVarArray",
      [
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() = ignore List.fromVarArray<Nat>(a);
          }
        ),
        ?(
          func() {
            let a = Array.init<Nat>(n, 0);
            func() = ignore Refactored.fromVarArray<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "toArray",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.toArray<Nat>(a);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.toArray<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "toVarArray",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.toVarArray<Nat>(a);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.toVarArray<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "toText",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.toText<Nat>(a, Nat.toText);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.toText<Nat>(a, Nat.toText);
          }
        ),
      ],
    );

    t.stat_average(
      "map",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.map<Nat, Nat>(a, func(x) = x);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.map<Nat, Nat>(a, func(x) = x);
          }
        ),
      ],
    );

    t.stat_average(
      "clone",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.clone<Nat>(a);
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.clone<Nat>(a);
          }
        ),
      ],
    );

    t.stat_average(
      "min",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.min<Nat>(a, func(a, b) = Nat.compare(a, b));
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.min<Nat>(a, func(a, b) = Nat.compare(a, b));
          }
        ),
      ],
    );

    t.stat_average(
      "max",
      [
        ?(
          func() {
            let a = List.repeat<Nat>(0, n);
            func() = ignore List.max<Nat>(a, func(a, b) = Nat.compare(a, b));
          }
        ),
        ?(
          func() {
            let a = Refactored.repeat<Nat>(0, n);
            func() = ignore Refactored.max<Nat>(a, func(a, b) = Nat.compare(a, b));
          }
        ),
      ],
    );

    Debug.print(t.output(["List", "Refactored"]));
  };
};
