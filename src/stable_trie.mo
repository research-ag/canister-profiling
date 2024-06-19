import StableTrie "mo:stable-trie/Enumeration";
import StableTrieMap "mo:stable-trie/Map";
import Prng "mo:prng";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
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
    let trie = StableTrie.Enumeration({
      pointer_size = 8;
      aridity = k;
      root_aridity = ?(k ** 3);
      key_size;
      value_size = 0;
    });

    func() : StableTrie.Enumeration {
      for (key in keys.vals()) {
        ignore trie.put(key, "");
      };
      trie;
    };
  };

  public func map_create_heap() : () -> Any {
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
    let trie = StableTrieMap.Map({
      pointer_size = 8;
      aridity = k;
      root_aridity = ?(k ** 3);
      key_size;
      value_size = 0;
    });

    func() : StableTrieMap.Map {
      for (key in keys.vals()) {
        ignore trie.put(key, "");
      };
      for (key in keys.vals()) {
        ignore trie.delete(key);
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
        let trie = StableTrie.Enumeration({
          pointer_size = 8;
          aridity = k;
          root_aridity = ?(k ** 3);
          key_size;
          value_size = 0;
        });
        let second = Iter.map<Nat, Text>(
          Iter.range(0, n),
          func(i) {
            if (i == 0) {
              ignore trie.put(keys[0], "");
            } else {
              for (j in Iter.range(2 ** (i - 1), 2 ** i - 1)) {
                ignore trie.put(keys[j], "");
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
        let trie = StableTrie.Enumeration({
          pointer_size = 8;
          aridity = k;
          root_aridity = ?(k ** 3);
          key_size;
          value_size = 0;
        });
        let second = Iter.map<Nat, Text>(
          Iter.range(0, n),
          func(i) {
            if (i == 0) {
              ignore trie.put(keys[0], "");
            } else {
              for (j in Iter.range(2 ** (i - 1), 2 ** i - 1)) {
                ignore trie.put(keys[j], "");
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
