    public shared query func getLastMutationStats(): async (Nat, Nat, Nat) {
        (Prim.rts_mutator_instructions(), Prim.rts_collector_instructions(), Prim.rts_heap_size())
    };
