root:
	chmod +x src/measure/run.sh

vector: root
	chmod +x src/vector/run.sh
	./src/vector/run.sh

sha2:
	dfx canister create sha2
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build sha2
	ic-repl ic-repl/sha2.sh

prng:
	dfx canister create prng
	DFX_MOC_PATH="$(shell vessel bin)/moc" dfx build prng
	ic-repl ic-repl/prng.sh
