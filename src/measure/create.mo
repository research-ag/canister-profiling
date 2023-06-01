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
      case "b_tree" return Enumeration.b_tree_heap;
      case "zhus" return Enumeration.zhus_heap;
      case "zhus7" return Enumeration.zhus7_heap;

      case "enumeration_nat" return Enumeration.create_nat_heap;
      case "rb_tree_nat" return Enumeration.rb_tree_nat_heap;
      case "b_tree_nat" return Enumeration.b_tree_nat_heap;
      case "zhus_nat" return Enumeration.zhus_nat_heap;
      case "zhus7_nat" return Enumeration.zhus7_nat_heap;

      case "enumeration_nat64" return Enumeration.create_nat64_heap;
      case "rb_tree_nat64" return Enumeration.rb_tree_nat64_heap;
      case "b_tree_nat64" return Enumeration.b_tree_nat64_heap;
      case "zhus_nat64" return Enumeration.zhus_nat64_heap;
      case "zhus7_nat64" return Enumeration.zhus7_nat64_heap;

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
