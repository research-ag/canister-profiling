    public shared query func getLastMutationStats(): async (Nat, Nat) {
        (Prim.rts_mutator_instructions(), Prim.rts_collector_instructions())
    };
