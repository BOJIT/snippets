#!/bin/bash

# ---------------------------------------------------------------------------- #

BASE_URL="https://snippets.bojit.org"

LANGUAGES=(cplusplus javascript matlab shell)

AUTHOR="James Bennion-Pedley"
INPUT_AUTHOR=""

# ---------------------------------------------------------------------------- #

function addGitignore() {
	GITIGNORE=".gitignore"

	# Add to .gitignore file if present
	if [ -f "$GITIGNORE" ]; then
		if grep -q "$1" "$GITIGNORE"
		then
			echo "$1 already added to .gitignore"
		else
			echo -en "\n$1" >> "$GITIGNORE"
			echo "Added $1 to .gitignore"
		fi
	fi
}

function getSnippet() {
	URL="$BASE_URL/snippets/$1.code-snippets"
	FILE=".vscode/$1.code-snippets"

	# Download File
	echo "Fetching $URL"
	curl $URL -s --output $FILE

	# Change author name
	sed -i "s/###AUTHOR###/$AUTHOR/" $FILE

	addGitignore $FILE

	echo "---------------------------------------------------------------------"
}

# ---------------------------------------------------------------------------- #

# Check language flag is passed
if [[ $1 = "" ]]
then
	echo "No Language Selected!"
	exit 1
fi

mkdir -p .vscode

# Get name for substitution
read -p "Enter Author Name (default = $AUTHOR): " INPUT_AUTHOR

# Get settings.json?
read -p "Do you want to override settings.json? (y/n) " yn

echo "---------------------------------------------------------------------"

case $yn in 
y )
	SETTINGS_URL="$BASE_URL/settings.json"
	SETTINGS_FILE=".vscode/settings.json"

	# Download File
	echo "Fetching $SETTINGS_URL"
	curl $SETTINGS_URL -s --output $SETTINGS_FILE
	addGitignore $SETTINGS_FILE
	;;
n )
	echo "Ignoring settings.json..."
	;;
* )
	echo "invalid response - exiting system"
	exit 1
	;;
esac

echo "---------------------------------------------------------------------"

if [[ $INPUT_AUTHOR != "" ]]
then
	AUTHOR=$INPUT_AUTHOR
fi

case $1 in
--all)
	echo "Fetching all languages..."
	for i in "${LANGUAGES[@]}";
	do
		getSnippet $i
	done
	;;
*)
	if [[ ! "${LANGUAGES[*]}" =~ "$1" ]]; then
		echo "$1 is not a valid language!"
		exit 1
	fi

	getSnippet $1
	;;
esac

echo "Snippets Added: Restart VSCode for snippets to load."

# ---------------------------------------------------------------------------- #