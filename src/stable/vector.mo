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

actor {
    let n = 500_000_000;
    stable let vector = Vector.init<Nat>(n, 0);
};