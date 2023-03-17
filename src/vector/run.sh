echo vector deploy
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy vector --quiet

echo vector profile
dfx canister call vector profile

./src/measure/run.sh

echo heap init
dfx canister call heap init '("vector")'

echo heap test
dfx canister call heap test

echo stable init
dfx canister call stable init '("vector")'

echo stable test
dfx canister call stable test

echo stable upgrade
dfx canister install stable --mode='upgrade' --upgrade-unchanged

echo stable test
dfx canister call stable test