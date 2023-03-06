# canister-profiling

Profiling things in the canister.

## Run

On the first run:
```
dfx start --background
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy
```
On the next ones:
```
DFX_MOC_PATH="$(vessel bin)/moc" dfx build && ic-repl ic-repl/vector.sh
```

## Bench Vector against Buffer

|method|vector|buffer|array|
|---|---|---|---|
|init|26741|13154|12086|
|addMany|40968|0|0|
|clone|212841|310260|0|
|add|406178|484168|0|
|get|218025|123025|74025|
|getOpt|238617|124025|0|
|put|245617|131025|75025|
|size|159025|76025|101025|
|removeLast|354234|367814|0|
|clear|161|269|0|
|indexOf|546397|143062|35027|
|lastIndexOf|375900|150076|0|
|vals|418334|122238|14019|
|items|519390|0|0|
|valsRev|202687|0|0|
|itemsRev|348863|0|0|
|keys|97403|0|0|
|append|487227|321560|0|
|toArray|201245|105158|0|
|fromArray|487728|207373|0|
|toVarArray|266461|162081|114208|
|fromVarArray|487698|207373|57183|


## Becnh Enumeration against RBTree

|method|enumeration|red-black tree|
|---|---|---|
|random blobs inside average|4304|4028|
|random blobs average|3201|2867|
|root|1873|1798|
|leftmost|4459|4143|
|rightmost|5037|4753|
|min blob|2971|2618|
|max blob|3653|3334|
|min leaf|3892|3609|
|max leaf|5868|5566|

min leaf in enumeration: 9

min leaf in red-black tree: 9

max leaf in enumeration: 16

max leaf in red-black tree: 16
