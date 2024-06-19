import Create "create";

actor {
  public shared func init(name : Text) : async () {
    let _ = Create.get_profile(name)();
  };
};
