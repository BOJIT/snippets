#!/bin/bash

# ---------------------------------------------------------------------------- #

BASE_URL="https://snippets.bojit.org/snippets"

LANGUAGES=(cplusplus javascript matlab shell)

AUTHOR="James Bennion-Pedley"
INPUT_AUTHOR=""

# ---------------------------------------------------------------------------- #

function getSnippet() {
	URL="$BASE_URL/$1.code-snippets"
	FILE=".vscode/$1.code-snippets"
	GITIGNORE=".gitignore"

	# Download File
	echo "Fetching $URL"
	curl $URL -s --output $FILE

	# Change author name
	sed -i "s/###AUTHOR###/$AUTHOR/" $FILE

	# Add to .gitignore file if present
	if [ -f "$GITIGNORE" ]; then
		if grep -q "$FILE" "$GITIGNORE"
		then
			echo "$FILE already added to .gitignore"
		else
			echo -en "\n$FILE" >> "$GITIGNORE"
			echo "Added $FILE to .gitignore"
		fi
	fi

	echo "---------------------------------------------------------------------"
}

# ---------------------------------------------------------------------------- #

mkdir -p .vscode

# Get name for substitution
read -p "Enter Author Name (default = $AUTHOR): " INPUT_AUTHOR

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