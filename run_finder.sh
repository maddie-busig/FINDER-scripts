#!/usr/bin/bash

if [ $# -lt 3 ]; then
	echo 'USAGE: run_finder.sh PROJECT INPUT_DIR RESULTS_DIR [PROJ_CONFIGS_DIR]'
	exit -1
fi

SCRIPT_DIR=$(dirname "$0")
TEMPCONFIG_DIR="$SCRIPT_DIR/config_template"

PROJECT=$1
INPUT_DIR=$2
RESULTS_DIR=$3
CONFIG_DIR=${4:-"$SCRIPT_DIR/project_config"}

PROJECT_DIR=$(realpath "$INPUT_DIR/$PROJECT")
RAWRESULTS_DIR=$(realpath "$RESULTS_DIR/$PROJECT/raw")
PROJCONFIG_DIR=$(realpath "$CONFIG_DIR/$PROJECT")

export PROJECT
export PROJECT_DIR
export PROJCONFIG_DIR
export RAWRESULTS_DIR

mkdir -p "$CONFIG_DIR"
mkdir -p "$RAWRESULTS_DIR"

echo "Copying template configuration"
cp -r -T "$TEMPCONFIG_DIR" "$PROJCONFIG_DIR"

echo "Performing configuration substitutions"
for file in $PROJCONFIG_DIR/*; do
	echo "$(envsubst < $file)" > "$file"
done

echo "Running FINDER using $PROJCONFIG_DIR/run.properties"
finderDPD "$PROJCONFIG_DIR/run.properties"

