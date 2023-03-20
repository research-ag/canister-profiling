    private func natToBlob(len : Nat, n : Nat) : Blob {
        let ith_byte = func(i : Nat) : Nat8 {
            assert(i < len);
            let shift : Nat = 8 * (len - 1 - i);
            Nat8.fromIntWrap(n / 2**shift)
        };
        Blob.fromArray(Array.tabulate<Nat8>(len, ith_byte));
    };

    public shared query func subaccountFromIndex(index: Nat): async Blob {
        natToBlob(32, index);
    };

    public shared ({ caller }) func registerMany(startPrincipalNumber: Nat, amount: Nat, subaccountsAmount: Nat, initialBalance: Nat): async { #ok; #err: ICRC1.TransferError } {
        let principalFromNat = func (n : Nat) : Principal {
            let blobLength = 16;
            Principal.fromBlob(Blob.fromArray(
                Array.tabulate<Nat8>(
                    blobLength,
                    func (i : Nat) : Nat8 {
                        assert(i < blobLength);
                        let shift : Nat = 8 * (blobLength - 1 - i);
                        Nat8.fromIntWrap(n / 2**shift)
                    }
                )
            ));
        };
        for (p in Iter.map<Nat, Principal>(Iter.range(startPrincipalNumber, startPrincipalNumber + amount), func (i: Nat) : Principal = principalFromNat(i))) {
            for (i in Iter.range(0, subaccountsAmount)) {
                switch (await* ICRC1.mint(token, { to = { owner = p; subaccount = ?natToBlob(32, i) }; amount = initialBalance; memo = null; created_at_time = null; }, caller)) {
                    case (#Ok _) {};
                    case (#Err err) return #err(err);
                };
            }
        };
        #ok();
    };

    public shared query func getLastMutationStats(): async (Nat, Nat, Nat) {
        (Prim.rts_mutator_instructions(), Prim.rts_collector_instructions(), Prim.rts_heap_size())
    };
