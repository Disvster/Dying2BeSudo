# Installing Debian

## machine hardware and virtual disk space

- Disk Space: 31.10GiB(bin)
- Base Memory (RAM): 4710MB(bin) (change it to double the swap see bonus)
- Processors: 1 CPU
- vCPU ?? check this

## installing

### Misc

- chose everything America fuck yeah expect country (portugal smh)
- timezone: Lisabona

### root/user info

- hostname: manmaria42
- root password: aCobraFumou42
- user1: manmaria
- password: Cascavel3,22
- Encrypted Password: NaFinaPeneira3,32

## partitions

**Logical volume management** or **LVM**:
provides a method of allocating space on [mass-storage](https://en.wikipedia.org/wiki/Mass_storage) devices that is more flexible than conventional 
[partitioning](https://en.wikipedia.org/wiki/Partition_(computing)) 
schemes to store volumes.

### Manual:

followed this [Guide](https://noreply.gitbook.io/born2beroot/installing-debian/bonus-partition-disks)

- Choose device then create new partition table
- select the partition table available, the one that says **FREE SPACE**

#### "Create new partition":

- sda1 with 537MB,"Primary", OS will be installed here
    - "beginning" we want the partition to be at the beginning of the available space
    - Mount point is `/boot`

- sda5 with 32860MB(32.86GB)
    - logical partition
    - **encrypted**
    - "beginning"
    - "mount point: **Do not mount it**"

- "Configure encrypted volumes", "yes", "Create encrypted volumes"
- we want to encrypt the logical partition aka /dev/sda5
- "Done [...] Finish [...], fill data: yes" (opt: "cancel")
- Encrypted Password: NaFinaPeneira3,32
- "Configure the Logical Volume Manager"

#### "Create new volume group"

- name: LVMGroup
- select sda5

#### "Create Logical Volume[s]" - create sub volumes for LV group sda5

- reserved blocks: 1%
- "Use as:Ext4 journaling file system" exept for `swap` that has its own option

| LVolumes  | size MB | 1% R.B. MB | total MB | mount point |
|-----------|---------|------------|----------|-------------|
| root      |  10737  |    107     |  10844   | `/`         |
| swap      |  2470   |    none    | use size | none        |
| home      |  5369   |    54      |  5423    | `/home`     |
| var       |  3221   |    32      |  3253    | `/var`      |
| srv       |  3221   |    32      |  3253    | `/srv`      |
| tmp       |  3221   |    32      |  3253    | `/tmp`      |
| var-log   |  4295   |    43      |  4338    | `/var/log`  |

### Closing steps

- choose country then deb.debian.org
- "no" to statistics
- install GRUB
- reboot
