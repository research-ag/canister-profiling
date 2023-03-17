echo heap deploy
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy heap --quiet
echo stable deploy
DFX_MOC_PATH="$(vessel bin)/moc" dfx deploy stable --quiet
