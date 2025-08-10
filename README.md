### system requirements

[![IsaacSim 5.0.0](https://img.shields.io/badge/IsaacSim-5.0.0-silver.svg)](https://developer.nvidia.com/isaac-sim)
[![Python 3.11](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/release/python-31013/)
[![Platform: Linux-64](https://img.shields.io/badge/platform-linux--64-orange.svg)](https://releases.ubuntu.com/20.04/)
[![Platform: Windows-64](https://img.shields.io/badge/platform-windows--64-orange.svg)](https://www.microsoft.com/en-ca/windows/windows-11)

```bash
# Official compatibility Checker
bash scripts/compatibility_check.sh
```

> [!Note]
> GUI checker -> [Isaac Sim Compatibility Checker](https://docs.isaacsim.omniverse.nvidia.com/5.0.0/installation/requirements.html#id6)

### Clone

```bash
git clone --recurse-submodules git@github.com:AtticusZeller/IsaacLab-uv.git
```

### install deps which contains issac sim and issaclab

```bash
uv sync --dev
```

### test `isaac sim`

```bash 
isaacsim isaacsim.exp.full.streaming 

```

headless for GPU server

```bash
isaacsim isaacsim.exp.full.streaming --no-window
```

### install issaclab

install all

```bash
find -L ./issaclab/source -mindepth 1 -maxdepth 1 -type d -exec bash -c 'if [ -f "$1/setup.py" ]; then echo "Installing: $1"; uv add --editable "$1"; fi' _ {} \;
```

install manually

```bash
uv add --editable issaclab/source/isaaclab
```

[isaac sim install guide](https://isaac-sim.github.io/IsaacLab/main/source/setup/quickstart.html)
official install script

```bash
uv run issaclab/isaaclab.sh --install
```

### disable IOMMU

* Editing your GRUB configuration file:

```bash
sudo nano /etc/default/grub
```

* Adding iommu=off or intel_iommu=off (for Intel systems) or amd_iommu=off (for AMD systems) to the GRUB_CMDLINE_LINUX_DEFAULT line.

* Updating GRUB and rebooting:

```bash
sudo update-grub
sudo reboot
```

> [!Note]
> Disabling IOMMU may improve performance for applications like Isaac Sim but could reduce system security and break certain virtualization features. Consider your specific requirements before making this change.

## [Demos](https://isaac-sim.github.io/IsaacLab/main/source/overview/showroom.html)

> [!Note]
> it takes a while to load the first time you run it.

### quadrupeds

![dogs](assets/dogs.png)

```bash
python  issaclab/scripts/demos/quadrupeds.py
```

### unitree H1

![h1](assets/h1.png)

```bash
python issaclab/scripts/demos/h1_locomotion.py
```
