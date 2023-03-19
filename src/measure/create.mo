import Enumeration "../enumeration/create";
import Vector "../vector";
import Prim "mo:⛔";

module {
  public func get(name : Text) : () -> Any {
    switch (name) {
      case "vector" Vector.create_heap;
      case "enumeration" Enumeration.create_heap;
      case _ Prim.trap("");
    };
  };

  public func get_profile(name : Text) : (() -> Any) {
    switch (name) {
      case ("vector") Vector.profile;
      case _ Prim.trap("Not found");
    };
  };
};
