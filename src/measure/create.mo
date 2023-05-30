import Enumeration "../enumeration";
import Sha2 "../sha2";
import Prng "../prng";
import Vector "../vector";
import Prim "mo:⛔";

module {
  public func get_heap(name : Text) : () -> () -> Any {
    switch (name) {
      case "vector" return Vector.create_heap;
      case "array" return Vector.array_heap;
      case "buffer" return Vector.buffer_heap;
      case "enumeration" return Enumeration.create_heap;
      case "rb_tree" return Enumeration.rb_tree_heap;
      case "zhus" return Enumeration.zhus_heap;
      case "zhus7" return Enumeration.zhus7_heap;
      case "sha256" return Sha2.sha256_heap;
      case _ Prim.trap("");
    };
  };

  public func get_profile(name : Text) : () -> () {
    switch (name) {
      case "vector" return Vector.profile;
      case "enumeration" return Enumeration.profile;
      case "sha2" return Sha2.profile;
      case "prng" return Prng.profile;
      case _ Prim.trap("");
    };
  };
};
