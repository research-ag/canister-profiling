set -x
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy profile --quiet
dfx canister call profile init "(\"$1\")"