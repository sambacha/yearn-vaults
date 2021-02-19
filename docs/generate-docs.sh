#!/bin/bash
echo "Generating Documentation from TypeScript Source..."
 typedoc --ignoreCompilerErrors --mode file docs/ src/
cd docs
serve
