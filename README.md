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
|init|(13,408688)|(12,400504)|(12,400008)|
|addMany|(14,408672)|(0,0)|(0,0)|
|clone|(181,437380)|(312,2153584)|(0,0)|
|add|(350,2036732)|(557,3259680)|(0,0)|
|get|(218,0)|(123,0)|(74,0)|
|getOpt|(238,0)|(124,0)|(0,0)|
|put|(245,0)|(131,0)|(75,0)|
|size|(159,0)|(76,0)|(101,1600000)|
|removeLast|(302,38604)|(387,2153368)|(0,0)|
|indexOf|(170,10380)|(143,0)|(35,0)|
|lastIndexOf|(370,1610388)|(150,0)|(0,0)|
|vals|(171,10524)|(122,48)|(14,0)|
|items|(272,1610456)|(0,0)|(0,0)|
|valsRev|(197,10376)|(0,0)|(0,0)|
|itemsRev|(343,1610388)|(0,0)|(0,0)|
|keys|(97,44)|(0,0)|(0,0)|
|addFromIter|(431,2036732)|(321,1200024)|(0,0)|
|toArray|(159,410532)|(105,400024)|(0,0)|
|fromArray|(154,408732)|(206,2200520)|(0,0)|
|toVarArray|(223,410532)|(162,400008)|(114,400024)|
|fromVarArray|(154,408732)|(206,2200520)|(57,400040)|
|clear|(161,20)|(269,40)|(0,0)|


## Becnh Enumeration against RBTree

Testing for n = 4096

Memory usage of Enumeration: 49

Memory usage of RBTree: 63

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
