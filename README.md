# canister-profiling

Profiling things in canisters.

## Run

It's better to run `dfx` in background to see debug outputs and ic-repl calls in the same terminal and to clean everything happened before.
```
dfx start --background --clean
```
Use make to run a separate benchmark:
```
make vector
```
or enumeration, etc.

## Bench Vector against Buffer

n = 100000

Time:

|method|vector|vector class|buffer|array|
|---|---|---|---|---|
|init|13|13|12|12|
|addMany|14|14|-|-|
|clone|176|0|253|-|
|add|291|321|490|-|
|get|196|226|118|71|
|getOpt|230|260|120|-|
|put|236|267|126|72|
|size|153|182|74|49|
|removeLast|294|323|326|-|
|indexOf|148|148|137|34|
|firstIndexWith|136|-|-|-|
|lastIndexOf|176|176|144|-|
|lastIndexWith|164|-|-|-|
|forAll|140|-|132|-|
|forSome|136|-|137|-|
|forNone|136|-|137|-|
|iterate|93|93|123|-|
|iterateRev|150|150|-|-|
|vals|148|148|117|14|
|items|248|248|-|-|
|valsRev|140|140|-|-|
|itemsRev|268|268|-|-|
|keys|92|92|-|-|
|addFromIter|368|368|311|-|
|toArray|139|139|102|-|
|fromArray|148|148|152|-|
|toVarArray|200|200|156|110|
|fromVarArray|148|148|152|56|
|clear|161|189|266|-|

Memory:

|method|vector|vector class|buffer|array|
|---|---|---|---|---|
|init|408688|409076|400504|400008|
|addMany|408640|408640|-|-|
|clone|425060|520|553568|-|
|add|416060|416060|1659216|-|
|get|0|0|0|0|
|getOpt|0|0|0|-|
|put|0|0|0|0|
|size|0|0|0|0|
|removeLast|7404|7404|553112|-|
|indexOf|28|28|0|0|
|firstIndexWith|8|-|-|-|
|lastIndexOf|20|20|0|-|
|lastIndexWith|0|-|-|-|
|forAll|24|-|48|-|
|forSome|8|-|48|-|
|forNone|8|-|48|-|
|iterate|8|8|48|-|
|iterateRev|0|0|-|-|
|vals|172|172|48|0|
|items|1600104|1600104|-|-|
|valsRev|68|68|-|-|
|itemsRev|1600080|1600080|-|-|
|keys|44|44|-|-|
|addFromIter|416060|416060|1200008|-|
|toArray|400180|400180|400024|-|
|fromArray|408716|409104|600504|-|
|toVarArray|400180|400180|400008|400008|
|fromVarArray|408716|409104|600504|400024|
|clear|20|20|40|-|

## Becnh Enumeration against RBTree

Testing for n = 4096

|method|enumeration|red-black tree|
|---|---|---|
|random blobs inside average|4236|3999|
|random blobs average|3100|2835|
|root|1860|1795|
|leftmost|4413|4114|
|rightmost|4958|4717|
|min blob|2895|2589|
|max blob|3543|3297|
|min leaf|3787|3586|
|max leaf|5832|5521|

min leaf in enumeration: 9

min leaf in red-black tree: 9

max leaf in enumeration: 16

max leaf in red-black tree: 16

## Bench Sha2

The columns refer to the following code:

* Sha256, Sha512: https://github.com/research-ag/motoko-lib
* timohanke: https://github.com/timohanke/motoko-sha2
* aviate-labs: https://github.com/skilesare/crypto.mo

Columns 1,3,4 are comparable because they all perform Sha256. 1 block refers to 64 bytes.

Column 2 performs Sha512 and 1 block refers to 128 bytes.

Time:

|method|Sha256|Sha512|timohanke|aviate-labs|
|---|---|---|---|---|
|0 blocks|35047|52840|492622|98430|
|1 blocks|40003|62723|325539|93319|
|10 blocks|34299|53480|97391|53067|
|100 blocks|33697|52555|51238|48421|
|1_000 blocks|33640|52463|48362|47990|

Memory:

|method|Sha256|Sha512|timohanke|aviate-labs|
|---|---|---|---|---|
|0 blocks|1032|2024|26508|4376|
|1 blocks|1048|2024|17516|3720|
|10 blocks|1416|2888|32072|8172|
|100 blocks|4200|11528|50924|42608|
|1_000 blocks|33048|97928|334012|392080|

## Bench PRNG

Time:

|method|Seiran128|SFC64|SFC32|
|---|---|---|---|
|init|172|267|225|

Memory:

|method|Seiran128|SFC64|SFC32|
|---|---|---|---|
|init|0|0|0|
