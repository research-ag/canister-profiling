import Create "create";

actor {
  public shared func init(name : Text) : async () {
    let a = Create.get_profile(name)();
  };
};
