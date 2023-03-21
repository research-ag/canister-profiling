#!/bin/bash

# setup temp directory
TEMPD=$(mktemp -d)
if [ ! -e "$TEMPD" ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi
trap 'rm -rf "$TEMPD"; exit 0' EXIT
trap 'rm -rf "$TEMPD"; exit 2' HUP INT QUIT TERM STOP

echo working in ${TEMPD}
cp test_ledger.repl ${TEMPD}
cp *.mo ${TEMPD}
pushd ${TEMPD}

# pull and build HPL
git clone git@github.com:research-ag/hpl.git
pushd hpl/test
sed -i -E 's/"args": "/"args": "--force-gc /' dfx.json
echo -e "$(cat ../../hpl_patch_imports.mo)\n$(sed '$d' test_api/ledger_test_api.mo)\n$(cat ../../hpl_patch_functions.mo)\n};\n" > test_api/ledger_test_api.mo
dfx build --check
popd

# pull and build ICRC1
git clone https://github.com/NatLabs/icrc1.git
pushd icrc1
sed -i -E 's/"args": "/"args": "--force-gc /' dfx.json
echo -e "$(cat ../icrc1_patch_imports.mo)\n$(sed '$d' src/ICRC1/Canisters/Token.mo)\n$(cat ../icrc1_patch_functions.mo)\n};\n" > src/ICRC1/Canisters/Token.mo
dfx build --check
popd

# run tests
ic-repl test_ledger.repl
popd

mv -f ${TEMPD}/stats.md .
