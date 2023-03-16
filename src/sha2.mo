import Sha256 "mo:mrr/Sha256";
import Sha512 "mo:mrr/Sha512";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Table "tools/table";
import Sha2 "mo:motoko-sha2";
import Crypto "mo:crypto.mo/SHA/SHA256";
import Nat "mo:base/Nat";

actor {
  func zero_blocks_64(n : Nat) : Blob {
    let len = if (n == 0) 0 else (64 * n - 9 : Nat);
    let arr = Array.freeze(Array.init<Nat8>(len, 0));
    Blob.fromArray(arr);
  };
  
  func zero_blocks_128(n : Nat) : Blob {
    let len = if (n == 0) 0 else (128 * n - 17 : Nat);
    let arr = Array.freeze(Array.init<Nat8>(len, 0));
    Blob.fromArray(arr);
  };

  let lengths = [0, 1, 10, 100, 1000];
  let inputs_64 = Array.map<Nat, Blob>(lengths, zero_blocks_64);
  let inputs_128 = Array.map<Nat, Blob>(lengths, zero_blocks_128);

  public query func profile() : async () {
    let t = Table.Table(0, 4);
    var i = 0;
    while (i < lengths.size()) {
      t.stat_average_n(
        (debug_show lengths[i]) # " blocks",
        Nat.max(lengths[i], 1),
        [
          ?(func() = func() = ignore Sha256.fromBlob(#sha256, inputs_64[i])),
          ?(func() = func() = ignore Sha512.fromBlob(#sha512, inputs_128[i])),
          ?(func() = func() = ignore Sha2.fromBlob(#sha256, inputs_64[i])),
          ?(func() = func() = ignore Crypto.sum(Blob.toArray(inputs_64[i]))),
        ],
      );
      i += 1;
    };

    Debug.print(t.output(["Sha256", "Sha512", "timohanke", "aviate-labs"]));
  };
};
