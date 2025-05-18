import Enumeration "../enumeration";
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
      case "trie" return StableTrieMap.create_heap;
      case "trie-map" return StableTrieMap.map_create_heap;
      case _ Prim.trap("");
    };
  };

  public func get_profile(name : Text) : () -> () {
    switch (name) {
      case "vector" return Vector.profile;
      case "enumeration" return Enumeration.profile;
      case "prng" return Prng.profile;
      case "trie" return StableTrieMap.profile;
      case "trie-map" return StableTrieMap.profile_map;
      case _ Prim.trap("");
    };
  };
};
