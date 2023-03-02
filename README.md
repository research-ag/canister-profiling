# canister-profiling

Profiling things in the canister.

# Run
On first run
```
dfx start --background
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy
```
On the next ones
```
DFX_MOC_PATH="$(vessel bin)/moc" dfx build && ic-repl ic-repl/vector.sh

```