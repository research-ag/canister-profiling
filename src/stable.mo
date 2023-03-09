import Vector "mo:mrr/Vector";
import E "mo:base/ExperimentalInternetComputer";
import StableMemory "mo:base/ExperimentalStableMemory";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Nat "mo:base/Nat";
import Prim "mo:⛔";
import Enumeration "mo:mrr/Enumeration";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";

actor {
    stable var stable_e = Enumeration.Enumeration().share();
    var e = Enumeration.Enumeration();

    class RNG() {
        var seed = 234234;
        var a = [var];

        public func next() : Nat {
            seed += 1;
            let a = seed * 15485863;
            a * a * a % 2038074743;
        };

        let ar = Array.init<Nat8>(29, 0);

        public func blob() : Blob {
            // let a = Array.tabulate<Nat8>(29, func(i) = Nat8.fromNat(next() % 256));
            var i = 0;
            while (i < 29) {
                ar[i] := Nat8.fromNat(next() % 256);
                i += 1;
            };
            Blob.fromArrayMut(ar);
        };
    };

    let n = 2 ** 12;

    public query func init() : async () {
        let r = RNG();
        var i = 0;
        while (i < n) {
            ignore e.add(r.blob());
            i += 1;
        };
    };

    system func preupgrade() {
        stable_e := e.share();
    };

    system func postupgrade() {
        e.unsafeUnshare(stable_e);
    };
};
