# kb54_zmk_config

## Build

### Local build

It is possible to build the firmware locally using docker. Under scripts directory, there are utility scripts to build the firmware.

```bash
./scripts/docker.build.sh
```

After the build script is executed, the firmware files will be available under the `artifacts` directory.

Without docker, the complete toolchain for zmk has to be locally available. After that, the firmware can be built using the following command.

```bash
HOME_DIR=$(pwd) ./scripts/build.sh
```

During the build process, all necessary files will be downloaded in the current repository directory. To clean up the repo and restore it to the original state, the following command can be used.

```bash
./scripts/clean.sh
```
