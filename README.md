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

Any item in this table is a pair of the instructions count and the memory size divided by 65536.

|method|vector|buffer|array|
|---|---|---|---|
|init|(13,6)|(12,6)|(12,6)|
|addMany|(14,6)|(0,0)|(0,0)|
|clone|(181,7)|(312,32)|(0,0)|
|add|(350,31)|(557,50)|(0,0)|
|get|(218,0)|(123,0)|(74,0)|
|getOpt|(238,0)|(124,0)|(0,0)|
|put|(245,0)|(131,0)|(75,0)|
|size|(159,0)|(76,0)|(101,25)|
|removeLast|(302,1)|(387,33)|(0,0)|
|indexOf|(170,0)|(143,0)|(35,0)|
|lastIndexOf|(370,24)|(150,0)|(0,0)|
|vals|(171,0)|(122,0)|(14,0)|
|items|(272,25)|(0,0)|(0,0)|
|valsRev|(197,0)|(0,0)|(0,0)|
|itemsRev|(343,24)|(0,0)|(0,0)|
|keys|(97,0)|(0,0)|(0,0)|
|addFromIter|(431,31)|(321,18)|(0,0)|
|toArray|(159,6)|(105,6)|(0,0)|
|fromArray|(154,6)|(206,33)|(0,0)|
|toVarArray|(223,7)|(162,6)|(114,6)|
|fromVarArray|(154,6)|(206,34)|(57,6)|
|clear|(161,0)|(269,0)|(0,0)|


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
