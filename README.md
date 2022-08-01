## Tools

This repository is a set of scripts aiming to help to easily create the development workspace needed for the team.

In the scripts/ directory you will find several scripts in which the entry point is the ```main.sh``` file.

Maybe you'll need to make this script executable:

```shell
$ chmod +x main.sh
```

After that:

```shell
$ ./main.sh
```

This script has several flags of options:

> **-a, --all** - Install everything.<br>
> **-l, --libs** - Install the libs necessary for some of the programs to work.<br>
> **-p, --pulse** - Install the PulseSecure program.<br>
> **-A, --android** - Install Android Studio.<br>
> **-c, --code** - Install Visual Studio Code.<br>
> **-r, --cyber** - Install Cyberreason program.<br>
> **-v, --vysor** - Install Vysor program.<br>
> **-s, --ssh** - Create the ssh key and set the config file.<br>
> **-h, --help** - Show how to use the program.<br>

So, this is a valid use of the script:

```shell
$ ./main -a
```

This command will install everything. Be aware that sometimes you'll have to give yes or no answers to the prompt, so you can't just run the script and go lunch.

## The Android Studio Installation

The Android Studio installation can be triggered by choosing the ```-a | --all``` flags, or by specifically selecting to install only this program with the ```-A | --android``` flag. The script will download the most up-to-date Android Studio binary from its repository and, at some point, will question you if you want to install it. It is recommended to say yes to this question because after the installation, we export the platform-tools directory to ```$PATH```, so you can access tools such as ```adb``` and ```fastboot```.

## The SSH configuration

This script will set a SSH key into your machine. This is necessary to access tools such as ```Gerrit``` and to make it easier to login into the *build server*. Follow [this tutorial](https://docs.google.com/document/d/1UFVoLMMWVDtZdRW41DAtouhqyThGHwrxl9KKC4NWihY/edit#) to configure Gerrit with your SSH key.

After this script run, you'll be able to login into the build server just by typing:

```shell
$ ssh zbr|indt # zbr OR indt
```

```zbr``` to login into the Jaguariúna build server
```indt``` to login into the INDT build server

### Set your SSH key into the build server

To set your SSH key into the build server and free yourself of the need to type your user and password every time, simply:

```shell
$ ssh-copy-id -i <path/to/your/key/id_coreid>.pub <zbr|indt>
```

