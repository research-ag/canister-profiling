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
call canister.create_rb();
call canister.heap_size();
call canister.create_enumeration();
call canister.heap_size();
