let id = call ic.provisional_create_canister_with_cycles(record { settings = null; amount = null });
call ic.install_code(
    record {
        arg = encode ();
        wasm_module = file("../../.dfx/local/canisters/stable_vector/stable_vector.wasm");
        mode = variant { install };
        canister_id = id.canister_id;
    },
);
call ic.install_code(
    record {
        arg = encode ();
        wasm_module = file("../../.dfx/local/canisters/stable_vector/stable_vector.wasm");
        mode = variant { upgrade };
        canister_id = id.canister_id;
    },
);
