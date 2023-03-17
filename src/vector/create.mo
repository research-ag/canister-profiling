import Vector "mo:mrr/Vector";

module {
  public func create_heap() : Any {
    let n = 10_000_000;
    Vector.init<Nat>(n, 0);
  };

  public func create_stable() : Any {
    let n = 10_000_000;
    Vector.init<Nat>(n, 0);
  };
};
