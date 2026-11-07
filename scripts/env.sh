# scripts/env.sh — pick 4 random lowercase letters/digits for SUFFIX once, then never change it
export RG=rg-fitops-dev
export LOC=eastus2
export SUFFIX=a1b2
export WS=mlw-fitops-$SUFFIX
export FOUNDRY=fdy-fitops-$SUFFIX
export SEARCH=srch-fitops-$SUFFIX
az configure --defaults group=$RG workspace=$WS location=$LOC