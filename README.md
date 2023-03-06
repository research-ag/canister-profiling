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
|init|16|12|12|
|addMany|21|0|0|
|clone|191|310|0|
|add|365|516|0|
|get|218|123|74|
|getOpt|238|124|0|
|put|245|131|75|
|size|159|76|101|
|removeLast|317|376|0|
|indexOf|544|143|35|
|lastIndexOf|371|150|0|
|vals|416|122|14|
|items|517|0|0|
|valsRev|198|0|0|
|itemsRev|344|0|0|
|keys|97|0|0|
|append|446|321|0|
|toArray|201|105|0|
|fromArray|446|206|0|
|toVarArray|266|162|114|
|fromVarArray|446|206|57|
|clear|161|269|0|


## Becnh Enumeration against RBTree

Testing for n = 4096

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

