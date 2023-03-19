set -x
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy heap --quiet
dfx canister call heap init "(\"$1\")"
dfx canister call heap test