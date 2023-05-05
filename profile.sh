set -ex
dfx deploy profile --quiet --mode=reinstall --yes
dfx canister call profile init "(\"$1\")"
