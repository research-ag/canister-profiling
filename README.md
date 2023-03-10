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

n = 100000

Time:

|method|vector|buffer|array|
|---|---|---|---|
|init|13|12|12|
|addMany|14|-|-|
|clone|181|312|-|
|add|350|557|-|
|get|218|123|74|
|getOpt|238|124|-|
|put|245|131|75|
|size|159|76|101|
|removeLast|302|387|-|
|indexOf|170|143|35|
|firstIndexWith|158|-|-|
|lastIndexOf|198|150|-|
|lastIndexWith|186|-|-|
|forAll|161|137|-|
|forSome|158|143|-|
|forNone|158|143|-|
|iterate|113|128|-|
|vals|171|122|14|
|items|272|-|-|
|valsRev|146|-|-|
|itemsRev|291|-|-|
|keys|97|-|-|
|addFromIter|431|321|-|
|toArray|159|105|-|
|fromArray|154|206|-|
|toVarArray|223|162|114|
|fromVarArray|154|206|57|
|clear|161|269|-|

Memory:

|method|vector|buffer|array|
|---|---|---|---|
|init|408688|400504|400008|
|addMany|408672|-|-|
|clone|437380|2153584|-|
|add|2036732|3259680|-|
|get|0|0|0|
|getOpt|0|0|-|
|put|0|0|0|
|size|0|0|1600000|
|removeLast|38604|2153368|-|
|indexOf|10380|0|0|
|firstIndexWith|10360|-|-|
|lastIndexOf|10356|0|-|
|lastIndexWith|10336|-|-|
|forAll|10376|48|-|
|forSome|10360|48|-|
|forNone|10360|48|-|
|iterate|10360|48|-|
|vals|10524|48|0|
|items|1610456|-|-|
|valsRev|10404|-|-|
|itemsRev|1610416|-|-|
|keys|44|-|-|
|addFromIter|2036732|1200024|-|
|toArray|410532|400024|-|
|fromArray|408732|2200520|-|
|toVarArray|410532|400008|400024|
|fromVarArray|408732|2200520|400040|
|clear|20|40|-|


## Becnh Enumeration against RBTree

Testing for n = 4096

Memory usage of Enumeration: 3213932

Memory usage of RBTree: 4093244

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
