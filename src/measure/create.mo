import Enumeration "../enumeration/create";
import Vector "../vector/create";
import Prim "mo:⛔";

module {
  public func get(name : Text) : () -> Any {
    switch (name) {
      case "vector" Vector.create_heap;
      case "enumeration" Enumeration.create_heap;
      case _ Prim.trap("");
    };
  };
};
