set -ex
DFX_MOC_PATH=moc dfx deploy profile --quiet --mode=reinstall --yes
dfx canister call profile init "(\"$1\")"
