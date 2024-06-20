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
import BTree "mo:btree/BTree";
import RBTree "mo:base/RBTree";
import Buffer "mo:base/Buffer";
import Map "mo:zhus/Map";
import E "mo:base/ExperimentalInternetComputer";
import Int "mo:base/Int";
import Nat32 "mo:base/Nat32";
import Float "mo:base/Float";
import Prim "mo:⛔";

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

  public func profile_map() {
    let key_size = 29;

    let rng = Prng.Seiran128();
    rng.init(0);

    type Tree = RBTree.Tree<Blob, Nat>;
    let n = 2 ** 12;
    let m = 2 ** 6;

    let stats = Buffer.Buffer<(Text, [Nat])>(0);
    var blobs = Array.tabulate<Blob>(
      n,
      func(i) = Blob.fromArray(
        Array.tabulate<Nat8>(
          key_size,
          func(j) = Nat8.fromNat(Nat64.toNat(rng.next()) % 256),
        )
      ),
    );

    let rb = RBTree.RBTree<Blob, Blob>(Blob.compare);

    let { bhash } = Map;
    let zhus = Map.new<Blob, Blob>();

    let trie = StableTrieMap.Map({
      pointer_size = 4;
      aridity = 4;
      root_aridity = ?(4 ** 6);
      key_size = key_size;
      value_size = 0;
    });
    let key_conv = BTree.noconv(Nat32.fromNat(key_size));
    let value_conv = BTree.noconv(0);

    let btree = BTree.new<Blob, Blob>(key_conv, value_conv);

    func average(blobs : [Blob], get : (Blob) -> ()) : Nat {
      var i = 0;
      var sum = 0;
      while (i < blobs.size()) {
        sum += Nat64.toNat(E.countInstructions(func() = get(blobs[i])));
        i += 1;
      };
      Int.abs(Float.toInt(Float.fromInt(sum) / Float.fromInt(blobs.size())));
    };

    stats.add((
      "put",
      [
        average(blobs, func(b) = rb.put(b, "")),
        average(blobs, func(b) = ignore Map.put<Blob, Blob>(zhus, bhash, b, "")),
        average(blobs, func(b) = ignore trie.put(b, "")),
        average(blobs, func(b) = ignore BTree.put<Blob, Blob>(btree, key_conv, b, value_conv, "")),
      ],
    ));

    func addForArray(s : Text, a : [Blob]) {
      stats.add((
        s,
        [
          average(a, func(b) = ignore rb.remove(b)),
          average(a, func(b) = ignore Map.remove(zhus, bhash, b)),
          average(a, func(b) = ignore trie.delete(b)),
          average(a, func(b) = ignore BTree.remove<Blob, Blob>(btree, key_conv, b, value_conv)),
        ],
      ));
    };

    addForArray("random blobs inside average", Array.tabulate<Blob>(m, func(i) = blobs[i * m]));
    addForArray(
      "random blobs outside average",
      Array.tabulate<Blob>(
        m,
        func(i) = Blob.fromArray(
          Array.tabulate<Nat8>(
            key_size,
            func(j) = Nat8.fromNat(Nat64.toNat(rng.next()) % 256),
          )
        ),
      ),
    );
    Debug.print(
      Table.format_table(
        "Maps deletion comparison",
        ["rb tree", "zhus map", "stable trie map", "motoko stable btree"],
        Iter.map<(Text, [Nat]), (Text, Iter.Iter<Text>)>(
          stats.vals(),
          func(x) = (
            x.0,
            Iter.map<Nat, Text>(
              x.1.vals(),
              func(i) = debug_show i,
            ),
          ),
        ),
      )
    );
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
