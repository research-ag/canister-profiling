set -ex
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy heap --quiet --mode=reinstall --yes
dfx canister call heap init "(\"$1\")"
dfx canister call heap run
dfx canister call heap test