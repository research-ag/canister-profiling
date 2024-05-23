import StableTrie "mo:mrr/StableTrie";
import Prng "mo:prng";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Table "utils/table";

module {
  public func create_heap() : () -> Any {
    let k = 4;
    let key_size = 8;
    let n = 18;
    let rng = Prng.Seiran128();
    rng.init(0);
    let keys = Array.tabulate<Blob>(
      2 ** n,
      func(i) {
        Blob.fromArray(Array.tabulate<Nat8>(key_size, func(j) = Nat8.fromNat(Nat64.toNat(rng.next()) % 256)));
      },
    );
    let trie = StableTrie.StableTrie(8, k, k ** 3, key_size, 0);

    func () : StableTrie.StableTrie {
      for (key in keys.vals()) {
        ignore trie.add(key, "");
      };
      trie;
    };
  };

  public func profile() {
    let children_number = [2, 4];

    let key_size = 8;
    let n = 18;
    let rng = Prng.Seiran128();
    rng.init(0);
    let keys = Array.tabulate<Blob>(
      2 ** n,
      func(i) {
        Blob.fromArray(Array.tabulate<Nat8>(key_size, func(j) = Nat8.fromNat(Nat64.toNat(rng.next()) % 256)));
      },
    );
    let rows = Iter.map<Nat, (Text, Iter.Iter<Text>)>(
      children_number.vals(),
      func(k) {
        let first = Nat.toText(k);
        let trie = StableTrie.StableTrie(8, k, k ** 3, key_size, 0);
        let second = Iter.map<Nat, Text>(
          Iter.range(0, n),
          func(i) {
            if (i == 0) {
              ignore trie.add(keys[0], "");
            } else {
              for (j in Iter.range(2 ** (i - 1), 2 ** i - 1)) {
                assert Result.isOk(trie.add(keys[j], ""));
              };
            };
            Nat.toText(trie.size() / 2 ** i);
          },
        );
        (first, second);
      },
    );

    let columns = Iter.map<Nat, Text>(Iter.range(0, n), func(i) = Nat.toText(i));
    Debug.print(Table.format_table("Memory per item", Iter.toArray(columns), rows));
  };

  public func profile1() {
    let children_number = [2, 4, 16, 256];
    let key_size = 2;
    let n = key_size * 8;
    let keys = Array.tabulateVar<Blob>(
      2 ** n,
      func(i) {
        Blob.fromArray(Array.tabulate<Nat8>(key_size, func(j) = Nat8.fromNat(i / 2 ** (j * 8) % 256)));
      },
    );
    let rng = Prng.Seiran128();
    rng.init(0);

    for (i in Iter.range(0, 2 ** n - 1)) {
      let j = Nat64.toNat(rng.next()) % 2 ** n;
      let t = keys[i];
      keys[i] := keys[j];
      keys[j] := t;
    };

    let rows = Iter.map<Nat, (Text, Iter.Iter<Text>)>(
      children_number.vals(),
      func(k) {
        let first = Nat.toText(k);
        let trie = StableTrie.StableTrie(8, k, k ** 3, key_size, 0);
        let second = Iter.map<Nat, Text>(
          Iter.range(0, n),
          func(i) {
            if (i == 0) {
              ignore trie.add(keys[0], "");
            } else {
              for (j in Iter.range(2 ** (i - 1), 2 ** i - 1)) {
                assert Result.isOk(trie.add(keys[j], ""));
              };
            };
            Nat.toText(trie.size() / 2 ** i);
          },
        );
        (first, second);
      },
    );
    let columns = Iter.map<Nat, Text>(Iter.range(0, n), func(i) = Nat.toText(i));
    Debug.print(Table.format_table("Memory per item", Iter.toArray(columns), rows));
  };
};
