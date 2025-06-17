# Setting up a clean install of the VM

Todo: resize the LogicalVolumes to match the ones in the bonus part of the subject.

## sudo and user/groups configuration

**sudo**: 'superuser do'; sudo lets a user run commands as if they were `su`.

**su**: the machine's super-user; has perminission to do eveything, also refered to as `root`.

### install sudo

```
su
[root password]
apt install sudo
sudo reboot
[after reboot]
su
sudo -V [info about sudo]
```

### adding users to sudo group

for a user to be able to use the `sudo` command we need to (create them, if not done already) add them to the `sudo` group

#### create user
```
sudo adduser <user_login>
```

#### create a group (eg: `user42`)
```
sudo addgroup user42
```

#### add user to groups
```
sudo adduser <user_login> user42
sudo adduser <user_login> sudo
```
#### check users in groups
```
getent group sudo user42
```

### Editing sudo policies

- `sudo visudo` opens a sudo config file that lets us change sudo's settings
- I use vim (default is nano, vim install is below) so to change `visudo`'s editor we type
```
sudo update-alternatives --config editor
[vim for me was number:] 3
```
**CHANGES IN SUDO CONFIGS (using `visudo`)**
- `Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"`
- `Defaults requiretty`
- `Defaults passwd_tries=3`
- `Defaults badpass_message="Success!"` (hihi)
- `Defaults logfile="/var/log/sudo/sudo.log"` | sudo in\outputs will be logged in this file
- outputs are not logged nowhere i think
- `Defaults log_input` & `Defaults log_output` | Logs sudo in/outputs
- `Defaults iolog_dir="/var/log/sudo"` | the directory to save additional output and input logs.

## VIM

```
sudo apt install vim
```

## SSH

SecureSHell protocol lets you control a machine remotely. It uses a **network port** (that you have to set-up) to open the communication between the host machine and (in this case) the VirtualMachine.

- update packages with `sudo apt update`
- install the openssh-service package to use the SSH protocol: `sudo apt install openssh-service`

to verify `ssh` is up-and-running we can run one of two commands:
```
sudo systemctl status ssh
sudo service ssh status
```

- useful info about systemctl vs service command [here](https://askubuntu.com/questions/903354/difference-between-systemctl-and-service-commands)

update **ssh-server config** to set ssh's port to **4242** and to disable logging in as `root` when ssh-ing.

- change to root with `su`
- open ssh-server config file: `vim /etc/ssh/sshd_config`
- uncomment and edit line 14 to `Port 4242`
- uncomment and edit line 33 to `PermitRootLogin no`

now port 4242 is the only port available to ssh into this machine.

to apply changes we restart and check the status of the ssh service (we can use `systemctl` or `service`):
```
sudo service ssh restart
sudo service ssh status
```
`status` should display port 4242 (try adding `| grep port` to `status command`)

### port-forwarding - opening port 4242

In VirtualBox: open the machine's 'Settings -> 'Network' -> 'Advanced' -> 'Port Forwarding'

In 'Port Forwarding Rules', create a new rule (gree icon at the right), name it "SSH", add a 'Host Port' (2332 is coolio) and a 'Guest Port' (4242).

Now VirtualBox listens to requests on host's port 2332 and forwards them to the VM's port 4242.

- `netstat | grep [port number]` on Host machine to check port connection
---
- try BRIDGED instead of NAT as network protocol of VM (VM's settings); to ssh: `ssh [vm's ip] -p 4242` 
---

### SSHing into the VM

on host machine's terminal write `ssh [user]@localhost -p 2332`, insert user's password and now you're connected to the VM as [user]!

## setting up the Firewall - UFW

UFW is user-friendly and effective for managing firewall rules. installing UFW:

- `sudo apt install UFW`
- `sudo ufw defult deny incoming` | Blocks all incoming requests
- `sudo ufw default allow outgoing` | Allow all outgoing requests
- `sudo ufw allow 4242` | Allow incoming traffic on port 4242
- `sudo ufw enable` | Enable ufw system-wide
- `sudo ufw status` | Check status and allowed ports

## Password Policy

we need to edit the password policy config file
- `sudo vim /etc/login.defs`
- `PASS_MAX_DAYS 30` | passwords have a 30 lifespan
- `PASS_MIN_DAYS 2` | min nbr of days allowed between passwd changes
- `PASS_WARN_AGE 7` | nbr of days warning given before passwd expires
we need to set these params for our previous set passwords aka `root` and `<user>`:
- do this for user and root, `-M` is MAX_DAYS and `-m` is MIN_DAYS:
```
sudo chage -M 30 <user>
sudo chage -m 2 <user>
```
- to check user password stats run the `sudo chage -l <user>` 

now to strenghten our password policy we need to install a module called `pwquality`
- `sudo aptget install libpam-pwquality`
- `sudo vim /etc/pam.d/common-password` | to open the config file for the pwquality
- change
```
password    requisite   pam_pwquality.so retry=3
```
to
```
password    requisite   pam_pwquality.so retry=3 minlen=10 ucredit=-1 dcredit=-1 lcredit=-1 maxrepeat=3 difok=7 reject_username enforce_for_root
```
- `retry` number of max password retries (we already set this above but we can keep it)
- `minlen` the minimum character lenght a password has to have
- `ucredit` at least a uppercase character
- `dcredit` at least a digit character
- `lcredit` at least a lowercase letter
- `maxrepeat` the maximum number of allowed consecutive characters 
- `reject_username` doesn't allow the user to input his username in the password
- `enforce_for_root` all the above apply for root password
- `difok` number of characters the new password has to differ from old

change new password for root and user with these new policies `sudo passwd <user>` (if they do not adhere to these policies already)

## Monitoring Script 

- every measuring unit in script will be in power of 1000^x
- for last reboot I'll use the `who - b` command, but `last reboot` is also an option. `| head -1` will get the first linewhereas `tail -1` gets the last line
- installed `mpstat` package for CPU load percentage
