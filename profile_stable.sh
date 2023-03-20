set -ex
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy stable --quiet
dfx canister call stable init "(\"$1\")"
dfx canister call stable test
dfx canister install stable --mode='upgrade' --upgrade-unchanged
dfx canister call stable test