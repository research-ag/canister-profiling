# canister-profiling

Profiling things in canisters.

## Run

It's better to run `dfx` in background to see debug outputs and ic-repl calls in the same terminal and to clean everything happened before, allow the scripts to run.
```
dfx start --background --clean
chmod +x profile.sh profile_heap.sh profile_stable.sh
```
To run a separate benchmark:
```
./profile.sh vector
```

To profile heap call:
```
./profile_heap.sh vector
./profile_heap.sh array
```
or enumeration in comparison with rb_tree, etc.

To profile stable memory edit `src/measure/stable.mo` and call:
```
./profile_stable.sh
```

### Note

`--force-gc` dfx option is required for heap and stable profiling.

## Notes on benches

Time is measured in Wasm instructions per call. For most functions each call takes eaxactly the same amount of instructions. But in some cases there can be component to it that occurs sporadically. For example, `add` and `removeLast` for Buffer are vastly more expensive when the Buffer grows or shrinks its capacity. In those case the displayed value is the average over `n` calls, i.e. the sporadic overhead is amortized over `n` calls.

Memory is measured in bytes of heap size increase due to the call to the function or, in some cases, to `n` calls to the function. 

In heap profiling:

* heap size is the size without the garbage of the data structure returned by the profiled function.
* gc size is the size of the garbage produced by the profiled function.
* collector instructions is the number of instructions required to collect the garbage of the profiled function.
* mutator instructions is the number of instructions for execution of the profiled function without garbage collector.

In stable profiling:

* mutator instructions are the instructions for deserialization of data returned by the profiled function.
* stable var query is the result of executing stableVarQuery function, the size of the serialized data.

## Bench List against Refactored List

#### Instructions & heap

n = 100000

Time:

|method|List|Refactored|
|---|---|---|
|find|196|151|
|findIndex|163|191|
|all|175|146|
|any|163|151|

Memory:

|method|List|Refactored|
|---|---|---|
|find|172|36|
|findIndex|8|48|
|all|24|36|
|any|8|36|

## Bench Vector against Buffer, Array

#### Instructions & heap

Testing for n = 100,000

Time:

|method|vector|vector class|buffer|array|
|---|---|---|---|---|
|init|15|15|14|14|
|addMany|17|17|-|-|
|clone|188|188|298|-|
|add|336|378|561|-|
|get|205|247|137|72|
|getOpt|261|303|149|-|
|put|266|309|152|82|
|size|183|224|101|69|
|removeLast|315|356|397|-|
|indexOf|182|182|173|56|
|firstIndexWith|163|163|-|-|
|lastIndexOf|222|222|180|-|
|lastIndexWith|203|203|-|-|
|forAll|175|175|157|-|
|forSome|163|163|162|-|
|forNone|163|163|162|-|
|iterate|106|106|140|-|
|iterateRev|133|133|-|-|
|vals|156|156|127|20|
|valsRev|163|163|-|-|
|items|266|266|-|-|
|itemsRev|292|292|-|-|
|keys|105|105|-|-|
|iterateItems|142|142|-|-|
|iterateItemsRev|177|177|-|-|
|addFromIter|406|406|357|-|
|toArray|155|155|118|-|
|fromArray|164|164|190|-|
|toVarArray|223|223|171|114|
|fromVarArray|164|164|190|64|
|clear|139|180|339|-|
|contains|182|182|163|56|
|max|174|174|191|57|
|min|174|174|197|57|
|equal|350|350|245|133|
|compare|391|391|286|133|
|toText|454|454|401|0|
|foldLeft|163|163|176|69|
|foldRight|190|190|193|135|
|reverse|426|426|244|145|
|reversed|412|412|244|145|
|isEmpty|116|157|120|88|
|concat|761|-|586|-|

Memory:

|method|vector|vector class|buffer|array|
|---|---|---|---|---|
|init|408688|409096|400504|400008|
|addMany|408640|408640|-|-|
|clone|425032|425440|553568|-|
|add|416060|416060|1659216|-|
|get|0|0|0|0|
|getOpt|0|0|0|-|
|put|0|0|0|0|
|size|0|0|0|0|
|removeLast|7404|7404|553112|-|
|indexOf|28|28|0|0|
|firstIndexWith|8|8|-|-|
|lastIndexOf|20|20|0|-|
|lastIndexWith|0|0|-|-|
|forAll|24|24|48|-|
|forSome|8|8|48|-|
|forNone|8|8|48|-|
|iterate|8|8|48|-|
|iterateRev|0|0|-|-|
|vals|204|204|48|0|
|valsRev|68|68|-|-|
|items|1600104|1600104|-|-|
|itemsRev|1600080|1600080|-|-|
|keys|44|44|-|-|
|iterateItems|8|8|-|-|
|iterateItemsRev|0|0|-|-|
|addFromIter|416060|416060|1200008|-|
|toArray|400212|400212|400024|-|
|fromArray|408716|409124|600504|-|
|toVarArray|400212|400212|400008|400008|
|fromVarArray|408716|409124|600504|400024|
|clear|20|20|40|-|
|contains|28|28|48|0|
|max|36|36|48|0|
|min|36|36|48|0|
|equal|408|408|0|0|
|compare|408|408|0|0|
|toText|3200196|3200196|3199992|296|
|foldLeft|36|36|48|0|
|foldRight|28|28|0|0|
|reverse|0|0|0|400028|
|reversed|416144|416552|0|400028|
|isEmpty|0|0|0|0|
|concat|812812|-|1800016|-|

Notes on Time:

* Time is measured in Wasm instructions per call. For most functions each call takes eaxactly the same amount of instructions. But in some cases there can be component to it that occurs sporadically. For example, `add` and `removeLast` for Buffer are vastly more expensive when the Buffer grows or shrinks its capacity. In those case the displayed value is the average over `n` calls, i.e. the sporadic overhead is amortized over `n` calls. 
* Vector is a 2-dimensional array, hence we expect random access to be roughly twice as expensive as for Buffer/Array. More precisely, the outer array of a Vector is plain and the inner array is of an option type. Matching this fact, we can see in the `get/put` rows that the Vector cost is roughly the sum of the Buffer cost plus the Array cost.
* Functions that iterate through a vector take advantage of the inner structure and eliminate the overhead a 2-step lookup. This can be seen in the rows `indexOf, lastIndexOf, forAll, forSome, forNone, iterate, vals, addFromIter, toArray, fromArray, toVarArray, fromVarArray` where Vector is performing close to Buffer.
* The `add` row is an average over many additions. The reason that Vector performs better is that Buffer has an expensive O(n) allocation and copying operation each time the Buffer grows its capacity. Vector avoids copying of data blocks entirely. Vector only does allocation and copying in the order of O(sqrt(n)) for its index block.

Notes on Memory:

* Memory is measured in bytes of heap size increase due to the call to the function or, in some cases, to `n` calls to the function. 
* The `add` row shows the garbage created by Buffer's growth events when the entire data is copied into a newly allocated array. Similarly `removeLast` produces garbage on shrink events.
* The `items` function returns pairs. This leads to a heap allocations of 16 bytes per entry as we can see in the table.

#### Heap & GC profiling

|method|heap size|gc size|collector instructions|mutator instructions|
|---|---|---|---|---|
|vector|40_097_980|79_984|377_979_749|2_866_169_088|
|buffer|47_835_248|95_669_512|460_218_016|4_462_255_651|
|array|40_000_128|24|375_004_331|120_002_552|

#### Serialization & Deserialization profiling

|method|mutator instructions|stable var query|
|---|---|---|
|vector|5_843_585_345|20_082_525|
|array|1_604_184_162|10_000_038|

## Bench Enumeration against RBTree

#### Instructions & heap

Testing for n = 4096

|method|enumeration|red-black tree|ordered-map|zhus|stable enum|stable trie|
|---|---|---|---|---|---|---|
|random blobs outside average|2674|2196|2246|1912|207757|3716|
|random blobs inside average|2136|1605|1674|1096|214093|2323|
|root|1060|965|0|0|0|0|
|leftmost|2514|2039|0|0|0|0|
|rightmost|3116|2565|0|0|0|0|
|min blob|1746|1265|0|0|0|0|
|max blob|2373|1816|0|0|0|0|
|min leaf|2362|1963|0|0|0|0|
|max leaf|3330|2665|0|0|0|0|

min leaf in enumeration: 9

min leaf in red-black tree: 9

max leaf in enumeration: 16

max leaf in red-black tree: 16


#### Heap & GC profiling

|method|heap size|gc size|collector instructions|mutator instructions|
|---|---|---|---|---|
|enumeration|278_848|171_613_248|4_349_072|3_472_314_656|
|rb_tree|377_172|172_176_312|7_690_532|3_471_603_610|

#### Serialization & Deserialization profiling

|method|mutator instructions|stable var query|
|---|---|---|
|enumeration|3_821_911_243|37_732_293|
|rb_tree|5_799_815_192|38_780_862|
|stable_enumeration|21_242|57_936|227|

## Bench Sha2

#### Instructions & heap

The columns refer to the following code:

* Sha256, Sha512: https://github.com/research-ag/motoko-lib
* timohanke: https://github.com/timohanke/motoko-sha2
* aviate-labs: https://github.com/skilesare/crypto.mo

Columns 1,3,4 are comparable because they all perform Sha256. 1 block refers to 64 bytes of all 0xff. 0 blocks refers to the empty message.

Column 2 performs Sha512 and 1 block refers to 128 bytes of all 0xff.

Time:

|method|Sha256|Sha512|timohanke|aviate-labs|
|---|---|---|---|---|
|0 blocks|18504|30562|492537|98431|
|1 blocks|23595|42215|434235|95601|
|10 blocks|19120|34890|87274|53644|
|100 blocks|18716|34165|53170|49325|
|1_000 blocks|18671|34089|49218|48887|

Memory:

|method|Sha256|Sha512|timohanke|aviate-labs|
|---|---|---|---|---|
|0 blocks|800|1348|26472|4376|
|1 blocks|864|2128|23424|4104|
|10 blocks|1624|11188|28280|10092|
|100 blocks|10336|102064|80836|68152|
|1_000 blocks|96472|1009588|577836|648488|

#### Heap & GC profiling

|method|heap size|gc size|collector instructions|mutator instructions|
|---|---|---|---|---|
|sha256|160|13_025_772|4_396|124_716_639|

## Bench PRNG

#### Instructions & heap

Time:

|method|Seiran128|SFC64|SFC32|
|---|---|---|---|
|next|251|377|253|

Memory:

|method|Seiran128|SFC64|SFC32|
|---|---|---|---|
|next|36|48|8|

