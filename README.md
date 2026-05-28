# Workspace Setup Tools

This repository provides a set of scripts to easily provision the development workspace needed for the team.

## Prerequisites

- **OS:** Ubuntu/Debian-based Linux distribution.
- **Permissions:** `sudo` privileges are required for several installations.

## Usage

Navigate to the `scripts/` directory and make the main script executable:

```shell
$ cd scripts/
$ chmod +x main.sh
```

After that, run the script:

```shell
$ ./main.sh
```

The script will open a `whiptail` interactive checklist where you can select the tools you want to install. Use the **Spacebar** to select/deselect items and **Enter** to confirm your selection.

### Available Options:

- **a**: All standard scripts.
- **F**: Skip `libs.sh` (Force skip of basic library installation).
- **p**: Install Anyconnect.
- **A**: Install Android Studio.
- **c**: Install Visual Studio Code.
- **r**: Install Sentinel One.
- **v**: Install Scrcpy.
- **t**: Install Tmux.
- **s**: Configure SSH.
- **i**: Configure Git.
- **d**: Install Adrive (Google Drive client).

**Note:** If you select the **'a'** option, it will automatically include all standard scripts regardless of other individual selections.
