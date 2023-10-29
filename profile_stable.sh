set -ex
DFX_MOC_PATH=moc dfx deploy stable --quiet --mode=reinstall --yes
dfx canister call stable init
dfx canister call stable test
DFX_MOC_PATH=moc dfx canister install stable --mode='upgrade' --upgrade-unchanged
dfx canister call stable summarize
