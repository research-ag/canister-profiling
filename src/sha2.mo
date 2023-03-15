import Sha256 "mo:mrr/Sha256";
import Sha512 "mo:mrr/Sha512";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Table "table";
import Sha2 "mo:motoko-sha2";
import Crypto "mo:crypto.mo/SHA/SHA256";

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

  let inputs_64 = Array.map<Nat, Blob>([1,10,100,1000], zero_blocks_64);
  let inputs_128 = Array.map<Nat, Blob>([1,10,100,1000], zero_blocks_128);

  public query func profile() : async () {
    let t = Table.Table(2, 4);
    t.stat_one(
      "empty",
      [
        ?(
          func() {
            func() = ignore Sha256.fromBlob(#sha256, "");
          }
        ),
        ?(
          func() {
            func() = ignore Sha512.fromBlob(#sha512, "");
          }
        ),
        ?(
          func() {
            func() = ignore Sha2.fromBlob(#sha256, "");
          }
        ),
        ?(
          func() {
            func() = ignore Crypto.sum([]);
          }
        ),
      ],
    );
    t.stat_one(
      "1 block",
      [
        ?(
          func() {
            func() = ignore Sha256.fromBlob(#sha256, inputs_64[0]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha512.fromBlob(#sha512, inputs_128[0]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha2.fromBlob(#sha256, inputs_64[0]);
          }
        ),
        ?(
          func() {
            func() = ignore Crypto.sum(Blob.toArray(inputs_64[0]));
          }
        ),
      ],
    );
    t.stat_one(
      "10 blocks",
      [
        ?(
          func() {
            func() = ignore Sha256.fromBlob(#sha256, inputs_64[1]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha512.fromBlob(#sha512, inputs_128[1]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha2.fromBlob(#sha256, inputs_64[1]);
          }
        ),
        ?(
          func() {
            func() = ignore Crypto.sum(Blob.toArray(inputs_64[1]));
          }
        ),
      ],
    );
    t.stat_one(
      "100 blocks",
      [
        ?(
          func() {
            func() = ignore Sha256.fromBlob(#sha256, inputs_64[2]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha512.fromBlob(#sha512, inputs_128[2]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha2.fromBlob(#sha256, inputs_64[2]);
          }
        ),
        ?(
          func() {
            func() = ignore Crypto.sum(Blob.toArray(inputs_64[2]));
          }
        ),
      ],
    );
    t.stat_one(
      "1000 blocks",
      [
        ?(
          func() {
            func() = ignore Sha256.fromBlob(#sha256, inputs_64[3]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha512.fromBlob(#sha512, inputs_128[3]);
          }
        ),
        ?(
          func() {
            func() = ignore Sha2.fromBlob(#sha256, inputs_64[3]);
          }
        ),
        ?(
          func() {
            func() = ignore Crypto.sum(Blob.toArray(inputs_64[3]));
          }
        ),
      ],
    );

    Debug.print(t.output(["Sha256", "Sha512", "timohanke", "aviate-labs"]));
  };
};
