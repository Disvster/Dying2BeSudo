# Commands you'll need to use during the B2BR evaluation

- `sudo ufw status` check ufw status (should be active) and opened ports
- `dpkg -s ufw` to show additional ufw info
- for services that should be running on boot (initiated by systemctl):
```
sudo systemctl status ufw
sudo systemctl status apparmor
sudo systemctl status ssh
sudo systemctl status lighttp
sudo systemctl status minecraft
```
- `uname --kernel-version` check which OS you're running
- `getent group sudo user42` check if user is in these groups
- for the create and setup a new user part of the eval:
```
sudo adduser <user_name> # create a new user
sudo addgroup evaluating # create evaluating group
sudo adduser <user_name> evaluating # add new user to evaluating group
```
- `hostname` check machine's name
- replace hostname and login with evaluator's:
```
sudo vim /etc/hostname # change my username with evaluator's
sudo vim /etc/hosts # change my username with evaluator'
```
- `lsblk` for partitions
- `which sudo` check if sudo is installed
- `sudo adduser <user_name> sudo` add new user to sudo group
- `getent group sudo` check if user is in this group
- to check for all the sudo and pasword policies we set up:
```
sudo visudo # open sudo configs
vim /etc/login.defs # to open passord policies
vim /etc/pam.d/common-password # to open additional password policies we set up
```
- `sudo car /var/log/sudo/sudo.log` to show sudo input logs
- `sudo ufw status numbered` to list active rules (ports) numbered
- to create and delete a new rule:
```
sudo ufw allow 8080
sudo ufw status numbered
sudo ufw delete <rule_num> # 8080 number
sudo ufw status numbered # check for 8080(v6) number
sudo ufw delete <rule_num> # delete the v6 number
```
- `which ssh` check if ssh is installed
- ssh into VM with root (should'nt work) then with newly created user:
```
ssh root@localhost -p 2332
ssh <user_name>@localhost -p 2332
```
- to modify the runtime of the script we'll go to the script itself and change `sleep 600` line to `sleep 60`:
```
sudo vim /usr/local/bin/machinestate.sh
[line 33]sleep 600 -> sleep 60
```
