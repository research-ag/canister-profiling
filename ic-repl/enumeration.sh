#!/usr/local/bin/ic-repl
let id = call ic.provisional_create_canister_with_cycles(record { settings = null; amount = null });
call ic.install_code(
    record {
        arg = encode ();
        wasm_module = file("../.dfx/local/canisters/enumeration/enumeration.wasm");
        mode = variant { install };
        canister_id = id.canister_id;
    },
);
let canister = id.canister_id;
call canister.profile();
call canister.measure_enumeration();
call canister.measure_rb_tree();
call canister.measure_stable_enumeration();
call canister.measure_stable_rb_tree();