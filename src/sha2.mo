import Sha256 "mo:sha2/Sha256";
import Sha512 "mo:sha2/Sha512";
import Prng "mo:prng";
import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Table "utils/table";
import Sha2 "mo:motoko-sha2";
import Crypto "mo:crypto.mo/SHA/SHA256";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Nat8 "mo:base/Nat8";
import Iter "mo:base/Iter";

module {
  type RNG = { next : () -> ?Nat8; reset : () -> () };
  func random_iter(len_ : Nat) : RNG {
    object {
      let sfc = Prng.SFC64a();
      sfc.init_pre();
      let len = len_;
      var i = 0;
      public func next() : ?Nat8 {
        i += 1;
        if (i <= len) {
          ?Nat8.fromIntWrap(Nat64.toNat(sfc.next()));
        } else null;
      };
      public func reset() {
        i := 0;
        sfc.init_pre();
      };
    };
  };

  func ff_blocks_64(n : Nat) : Blob {
    let sfc = Prng.SFC64a();
    sfc.init_pre();
    let len = if (n == 0) 0 else (64 * n - 9 : Nat);
    let arr = Array.tabulate<Nat8>(len, func(i) = Nat8.fromIntWrap(Nat64.toNat(sfc.next())));
    Blob.fromArray(arr);
  };

  func ff_blocks_128(n : Nat) : Blob {
    let sfc = Prng.SFC64a();
    sfc.init_pre();
    let len = if (n == 0) 0 else (128 * n - 17 : Nat);
    let arr = Array.tabulate<Nat8>(len, func(i) = Nat8.fromIntWrap(Nat64.toNat(sfc.next())));
    Blob.fromArray(arr);
  };

  public func profile() {

    let lengths = [0, 1, 10, 100, 1000];
    let inputs_64 = Array.map<Nat, Blob>(lengths, ff_blocks_64);
    let inputs_128 = Array.map<Nat, Blob>(lengths, ff_blocks_128);
    let arrays_64 = Array.map<Blob, [Nat8]>(inputs_64, Blob.toArray);

    let t = Table.Table(0, 5);
    var i = 0;
    while (i < lengths.size()) {
      t.stat_average_n(
        (debug_show lengths[i]) # " blocks",
        Nat.max(lengths[i], 1),
        [
          ?(func() = func() = ignore Sha256.fromBlob(#sha256, inputs_64[i])),
          ?(func() = func() = ignore Sha512.fromBlob(#sha512, inputs_128[i])),
          ?(func() = func() = ignore Sha2.fromBlob(#sha256, inputs_64[i])),
          ?(func() = func() = ignore Sha2.fromBlob(#sha512, inputs_128[i])),
          ?(func() = func() = ignore Crypto.sum(arrays_64[i])),
        ],
      );
      i += 1;
    };

    Debug.print(t.output(["Sha256", "Sha512", "mo-sha256", "mo-sha512", "crypto.mo"]));
  };

  public func sha256_heap() : () -> Any {
    let b = ff_blocks_64(1000);
    func() {
      Sha256.fromBlob(#sha256, b);
    };
  };
  public func sha512_heap() : () -> Any {
    let b = ff_blocks_128(1000);
    func() {
      //Sha512.fromArray(#sha512, iter);
      Sha512.fromBlob(#sha512, b);
    };
  };
  public func motokosha256_heap() : () -> Any {
    let b = ff_blocks_64(1000);
    func() {
      Sha2.fromBlob(#sha256, b);
    };
  };
  public func motokosha512_heap() : () -> Any {
    let b = ff_blocks_128(1000);
    func() {
      Sha2.fromBlob(#sha512, b);
    };
  };
  public func cryptomo_heap() : () -> Any {
    let b = ff_blocks_64(1000);
    let a = Blob.toArray(b);
    func() {
      Crypto.sum(a);
    };
  };
};
