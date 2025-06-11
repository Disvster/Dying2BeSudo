# Installing Debian

## machine hardware and virtual disk space

- Disk Space: 30.8GB
- Base Memory (RAM): 4710MB (change it to double the swap see bonus)
- Processors: 1 CPU
- vCPU ?? check this

## installing

### Misc

- chose everything America fuck yeah expect country (portugal smh)
- timezone: Lisabona

### root/user info

- hostname: manmaria42
- root password: aCobraFumou42
- user1: manmaria (full name: Manuel Couto)
- password: Cascavel3,22

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

- sda1 with 537MB, OS will be installed here
    - "biginning" we want the partition to be at the beginning of the available space
    - Mount point is `/boot`
- sda5 with 30.3G (max), logical partition, **encrypted**
    - "mount point: **Do not mount it**", has no mounting point
- "Configure encrypted volumes", "yes", "Create encrypted volumes"
- we want to encrypted the logical partition aka /dev/sda5
- "Done [...] Finish [...], fill data: yes" (opt: "cancel")
- Encrypted Password: NaFinaPeneira3,32
- "Configure the Logical Volume Manager"
#### "Create new volume group"

- name: LVMGroup
- select sda5
#### "Create Logical Volume[s]" - create sub volumes for LV group sda5

- reserved blocks: 1%

10737 ---- 100%
  x   ---- 1%

10737 ? 100 = 107.37
            
| LVolumes  | size MB | 1% R.S. MB | total MB | mount point |
|-----------|---------|------------|----------|-------------|
| root      |  10737  |    107     |  10844   | `/`         |
| swap      |  2470   |    25      |  2495    | none        |
| home      |  5369   |    54      |  5423    | `/home`     |
| var       |  3221   |    32      |  3253    | `/var`      |
| srv       |  3221   |    32      |  3253    | `/srv`      |
| tmp       |  3221   |    32      |  3253    | `/tmp`      |
| var-log   |  4295   |    43      |  4338    | `/var/log`  |

            actual size  +   RS. 1%
- root    - size 10737MB + 107MB(RS1%) = 10844 MB
- swap    - size 2470MB  + 
- home    - size 5369MB
- var     - size 3221MB
- srv     - size 3221MB
- tmp     - size 3221MB
- var-log - size 

### Guided:

- [...] **"Guided - use entire disk and set up encrypted LVM"** then select **"Separate /home, /var and /tmp partitions"** [...]
- LVM stands for Local Volume Manager
- Encrypted Password: NaFinaPeneira3,32

after all the disk space is partitioned and encrypted:
- selected only 15GB out of the max when prompted (this is to have the rest of the space available to create new LogicalVolumes)
- I went to "Configure the Logical Volume Manager" then "Create Logical volume name".
- Created `srv` with 3GB and `var-log` with 4GB, both as "Ext4 journaling file system" and mounted on `/srv` and `/var/log/`
need to devide partitions into groups
