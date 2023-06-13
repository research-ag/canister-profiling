# canister-profiling

Profiling various libraries in canisters.

## Run

It's better to run `dfx` in background to see debug outputs and ic-repl calls in the same terminal and to clean everything happened before, allow the scripts to run.
```
dfx start --background --clean --artificial-delay 0
chmod +x profile.sh profile_heap.sh profile_stable.sh
```
To benchmark instructions call one of:
```
./profile.sh vector
./profile.sh enumeration
./profile.sh sha2
./profile.sh prng
```
Note that you need `moc` version `>= 0.9.2` to be able to run all benchmarks.

To profile heap usage call one of:
```
./profile_heap.sh vector
./profile_heap.sh array
./profile_heap.sh buffer
./profile_heap.sh enumeration
./profile_heap.sh rb_tree 
./profile_heap.sh sha2
```

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

## Bench Vector against Buffer, Array

#### Instructions & heap

Testing for n = 100,000

Time:

|method|vector|vector class|buffer|array|
|---|---|---|---|---|
|init|13|13|12|12|
|addMany|14|14|-|-|
|clone|176|0|253|-|
|add|291|321|490|-|
|get|195|225|118|71|
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
|iterateRev|114|114|-|-|
|vals|147|147|117|14|
|items|247|247|-|-|
|valsRev|140|140|-|-|
|itemsRev|267|267|-|-|
|keys|92|92|-|-|
|addFromIter|368|368|311|-|
|toArray|138|138|102|-|
|fromArray|148|148|152|-|
|toVarArray|199|199|156|110|
|fromVarArray|148|148|152|56|
|clear|161|189|266|-|
|contains|148|-|138|34|
|max|147|-|163|37|
|min|147|-|168|37|
|equal|291|-|204|112|
|compare|331|-|244|112|
|toText|409|-|366|0|
|foldLeft|137|-|153|50|
|foldRight|158|-|159|113|
|reverse|396|-|209|128|
|reversed|365|-|209|128|
|isEmpty|89|-|89|61|

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
|contains|28|-|48|0|
|max|36|-|48|0|
|min|36|-|48|0|
|equal|344|-|0|0|
|compare|344|-|0|0|
|toText|3200164|-|3199992|296|
|foldLeft|36|-|48|0|
|foldRight|28|-|0|0|
|reverse|0|-|0|400028|
|reversed|416144|-|0|400028|
|isEmpty|0|-|0|0|

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

## Bench Enumeration against RBTree, btree and hashmaps

#### Instructions & heap

Testing for n = 4096

|method|enumeration|red-black tree|b-tree|zhus v8|zhus v7|
|---|---|---|---|---|---|
|random blobs inside average|2519|2483|4972|2060|1934|
|random blobs average|2026|1983|4972|2060|1934|
|root|1006|952|0|0|0|
|leftmost|2935|2751|0|0|0|
|rightmost|2676|2787|0|0|0|
|min blob|2235|2025|0|0|0|
|max blob|1980|2090|0|0|0|
|min leaf|2234|2200|0|0|0|
|max leaf|3286|3382|0|0|0|

min leaf in enumeration: 9

min leaf in red-black tree: 9

max leaf in enumeration: 16

max leaf in red-black tree: 16

#### Heap & GC profiling

|method|heap size|gc size|collector instructions|mutator instructions|
|---|---|---|---|---|
|enumeration|278_848|171_613_248|4_349_072|3_472_314_656|
|rb_tree|377_172|172_176_312|7_690_532|3_471_603_610|
|zhus v8|393_324|169_653_956|7_224_268|3_454_631_268|
|zhus v7|327_772|170_031_220|4_832_131|3_456_238_067|

#### Serialization & Deserialization profiling

|method|mutator instructions|stable var query|
|---|---|---|
|enumeration|3_821_911_243|37_732_293|
|rb_tree|5_799_815_192|38_780_862|


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
