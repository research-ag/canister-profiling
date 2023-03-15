import Vector "mo:mrr/Vector";

actor {
    let n = 500_000_000;
    stable let vector = Vector.init<Nat>(n, 0);
};