vector:
	dfx canister create vector
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build vector
	ic-repl ic-repl/vector.sh
	dfx canister create stable_vector
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build stable_vector
	ic-repl ic-repl/stable/vector.sh

enumeration:
	dfx canister create enumeration
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build enumeration
	ic-repl ic-repl/enumeration.sh
	dfx canister create stable_enumeration
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build stable_enumeration
	ic-repl ic-repl/stable/enumeration.sh

sha2:
	dfx canister create sha2
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build sha2
	ic-repl ic-repl/sha2.sh

prng:
	dfx canister create prng
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build prng
	ic-repl ic-repl/prng.sh
