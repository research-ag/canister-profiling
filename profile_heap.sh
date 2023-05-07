set -ex
dfx deploy heap --quiet --mode=reinstall --yes
dfx canister call heap pre_init
dfx canister call heap init "(\"$1\")"
dfx canister call heap run
dfx canister call heap test
