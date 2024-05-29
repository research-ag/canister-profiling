import Enumeration "../enumeration";
import Sha2 "../sha2";
import Prng "../prng";
import Vector "../vector";
import Prim "mo:⛔";
import StableTrieMap "../stable_trie";

module {
  public func get_heap(name : Text) : () -> () -> Any {
    switch (name) {
      case "vector" return Vector.create_heap;
      case "array" return Vector.array_heap;
      case "buffer" return Vector.buffer_heap;
      case "enumeration" return Enumeration.create_heap;
      case "rb_tree" return Enumeration.rb_tree_heap;
      case "sha256" return Sha2.sha256_heap;
      case "sha512" return Sha2.sha512_heap;
      case "motokosha256" return Sha2.motokosha256_heap;
      case "motokosha512" return Sha2.motokosha512_heap;
      case "cryptomo" return Sha2.cryptomo_heap;
      case "trie" return StableTrieMap.create_heap;
      case _ Prim.trap("");
    };
  };

  public func get_profile(name : Text) : () -> () {
    switch (name) {
      case "vector" return Vector.profile;
      case "enumeration" return Enumeration.profile;
      case "sha2" return Sha2.profile;
      case "prng" return Prng.profile;
      case "trie" return StableTrieMap.profile;
      case _ Prim.trap("");
    };
  };
};
