## Tools

---

This repository is a set of scripts aiming to help to easily create the development workspace needed for the team.

In the scripts/ directory you will find several scripts in which the entry point is the config.sh file.

Maybe you'll need to make this script executable:

```shell
$ chmod +x config.sh
```

After that:

```shell
$ ./config.sh
```

This script has several flags of options:

> **-a, --all** - Install everything.<br>
> **-l, --libs** - Install the libs necessary for some of the programs to work.<br>
> **-p, --pulse** - Install the PulseSecure program.<br>
> **-A, --android** - Install Android Studio.<br>
> **-c, --code** - Install Visual Studio Code.<br>
> **-r, --cyber** - Install Cyberreason program.<br>
> **-i, --aras** - Install Aras program.<br>
> **-v, --vysor** - Install Vysor program.<br>
> **-h, --help** - show how to use the program.<br>

*For now, this flags cannot be used concomitantly.*

So, this is a valid use of the script:

```shell
$ ./config -a
```

This command will install everything. Be aware that sometimes you'll have to give yes or no answers to the prompt, so you can't just run the script and go lunch.

