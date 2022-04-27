# snippets
Snippets for VSCode (various languages)

## Usage
In the root of your target project, run the following command to fetch all snippets:

```bash
bash -c "$(curl -fsSL https://snippets.bojit.org/get.sh)" get --all
```

Or, fetch a specific language using `vscode` language names, e.g.

```bash
bash -c "$(curl -fsSL https://snippets.bojit.org/get.sh)" get cplusplus
```

## Operation

This script does the following:

- Fetches the appropriate snippets and places them in your `.vscode/` folder.

- Adds the snippets to `.gitignore` if present

- Gives the option to set a custom default author (if you're not me :D)