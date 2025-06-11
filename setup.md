# Setting up a clean install of the VM

Todo: resize the LogicalVolumes to match the ones in the bonus part of the subject.

## sudo and user configuration

**sudo**: 'superuser do'; sudo lets a user run commands as if they were `su`.

**su**: the machine's super-user; has perminission to do eveything, also refered to as `root`.

### install su

```
su
[root password]
apt install sudo
sudo reboot
[after reboot]
su
sudo -V (idk why, double check after if needed)
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

#### add user to group
```
sudo adduser manmaria user42
sudo adduser manmaria sudo
```
#### check users in groups
```
getent group sudo user42
```
## VIM

```
sudo apt install vim
```


## SSH

SecureSHell protocol lets you control a machine remotely. It uses a **network _port_** (that you have to set-up) to open the communication between the host machine and the one operating it remotely.

- update pkgs with `sudo apt update`
- install the pkg openssh-service to use the SSH protocol: `sudo apt install openssh-service`

to verify `ssh` is up-and-running we can run one of two commands:
```
sudo systemctl status ssh
sudo service ssh status
```
---

useful info about systemctl vs service command [here](https://askubuntu.com/questions/903354/difference-between-systemctl-and-service-commands)

---
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

In 'Port Forwarding Rules', create a new rule (gree icon at the right), name it "SSH", add a 'Host Port' (2728 is coolio) and a 'Guest Port' (4242).

Now VirtualBox listens to requests on host's port 2728 and forwards them the VM's port 4242.

`netstat | grep 2728`

- try BRIDGED instead of NAT as network protocol; to ssh: `ssh [ip] -p 4242` 
