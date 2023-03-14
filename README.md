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
|clone|176|253|-|
|add|291|490|-|
|get|208|118|71|
|getOpt|230|120|-|
|put|236|126|72|
|size|153|74|49|
|removeLast|294|326|-|
|indexOf|161|137|34|
|firstIndexWith|149|-|-|
|lastIndexOf|189|144|-|
|lastIndexWith|177|-|-|
|forAll|153|132|-|
|forSome|149|137|-|
|forNone|149|137|-|
|iterate|106|123|-|
|vals|161|117|14|
|items|261|-|-|
|valsRev|140|-|-|
|itemsRev|280|-|-|
|keys|92|-|-|
|addFromIter|368|311|-|
|toArray|152|102|-|
|fromArray|148|152|-|
|toVarArray|213|156|110|
|fromVarArray|148|152|56|
|clear|161|266|-|

Memory:

|method|vector|buffer|array|
|---|---|---|---|
|init|408688|400504|400008|
|addMany|408640|-|-|
|clone|425060|553568|-|
|add|416060|1659216|-|
|get|0|0|0|
|getOpt|0|0|-|
|put|0|0|0|
|size|0|0|0|
|removeLast|7404|553112|-|
|indexOf|28|0|0|
|firstIndexWith|8|-|-|
|lastIndexOf|20|0|-|
|lastIndexWith|0|-|-|
|forAll|24|48|-|
|forSome|8|48|-|
|forNone|8|48|-|
|iterate|8|48|-|
|vals|172|48|0|
|items|1600104|-|-|
|valsRev|68|-|-|
|itemsRev|1600080|-|-|
|keys|44|-|-|
|addFromIter|416060|1200008|-|
|toArray|400180|400024|-|
|fromArray|408716|600504|-|
|toVarArray|400180|400008|400008|
|fromVarArray|408716|600504|400024|
|clear|20|40|-|


## Becnh Enumeration against RBTree

Testing for n = 4096

Memory usage of Enumeration: 3050092

Memory usage of RBTree: 4027708

|method|enumeration|red-black tree|
|---|---|---|
|random blobs inside average|4250|3999|
|random blobs average|3127|2835|
|root|1866|1795|
|leftmost|4402|4114|
|rightmost|4973|4717|
|min blob|2901|2589|
|max blob|3575|3297|
|min leaf|3841|3586|
|max leaf|5795|5521|

min leaf in enumeration: 9

min leaf in red-black tree: 9

max leaf in enumeration: 16

max leaf in red-black tree: 16
