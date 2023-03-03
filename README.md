# canister-profiling

Profiling things in the canister.

# Run

On the first run:
```
dfx start --background
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy
```
On the next ones:
```
DFX_MOC_PATH="$(vessel bin)/moc" dfx build && ic-repl ic-repl/vector.sh
```

# Bench Vector against Buffer

|method|vector|buffer|
|---|---|---|
|init|26741|13154|
|addMany|40968|0|
|clone|212841|1480|
|add|406178|484168|
|get|218025|123025|
|getOpt|238617|124025|
|put|245617|131025|
|size|159025|76025|
|removeLast|354234|367814|
|clear|161|269|
|indexOf|546397|143062|
|lastIndexOf|375870|150076|
|vals|418334|122238|
|items|519390|0|
|valsRev|202687|0|
|itemsRev|348863|0|
|keys|97403|0|
|append|487227|321530|
|toArray|201245|105158|
|fromArray|487698|207403|
|toArray|266461|162081|
|fromArray|487728|207373|
