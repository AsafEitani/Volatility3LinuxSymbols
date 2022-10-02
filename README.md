# Volatility3LinuxSymbols
Linux symbols creation tool for Volatility3

# Usage:
```
build_profile.sh [-h] [-v volatility dir] [-f dump path] [-k kernel version] [-d container distro] -- Volatility3 Linux kernel symbols creation tool

where:
    -h|--help    show this help text
    -v|--voldir  Volatility3 directory path
    -f|--file    memory dump path
   [-k|--kernel] memory dump kernel version (default: calculated from the dump with Volatility3 banner plugin)
   [-d|--distro] linux distribution for the symbol creation docker container (default:'ubuntu:focal')
```

# Example:
Automatic kernel version detection:
```
./build_profile.sh -f dump.raw -v /home/ubuntu/volatility3/
```

Manual kernel version:
```
./build_profile.sh -f dump.raw -v /home/ubuntu/volatility3/ -k 5.13.0-46-generic
```

# Notes:
Only tested on Ubuntu focal.
`-d` flag should be an Ubuntu flavor due to `apt-get` usage to install the kernel symbols. The Dockerfile and `install_symbols.sh` can be modified to be used in other distributions.
