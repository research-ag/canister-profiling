import Debug "mo:base/Debug";
import Prng "mo:mrr/Prng";
import Table "tools/table";

actor {
  public query func profile() : async () {
    let t = Table.Table(1, 3);
    t.stat_one(
      "init",
      [
        ?(
          func() {
            let r = Prng.Seiran128();
            func() = ignore r.next();
          }
        ),
        ?(
          func() {
            let r = Prng.SFC64a();
            func() = ignore r.next();
          }
        ),
        ?(
          func() {
            let r = Prng.SFC32a();
            func() = ignore r.next();
          }
        ),
      ],
    );

    Debug.print(t.output(["Seiran128", "SFC64", "SFC32"]));
  };
};
