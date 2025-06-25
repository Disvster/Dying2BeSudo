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
- `sudo chage -l <user>` to check for password rules set up by `visudo`
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
## Bonus - Minecraft server commands

- `/xp [amount] [player]` give exp to player
- `/weather [type]` change weather to clear, rain or thunder
- `/give [player] [item] [amount]` give a player a specific item eg.:/give Steve minecraft:diamond 10
- `/kill [player]` pretty self-explanatory

# Q&A during evaluation

1. Q: "The basic functioning of their virtual machine"
-  A: My VM is acting as a local server that is running two services, lighttpd and a minecraft server.

2. Q: "Their choice of operating system"
-  A: I chose Debian because it seemed more user friendly and an OS I might use if I ever want to setup a server for my own personal use.

3. Q: "The basic differences between Rocky and Debian"
-  A: Rocky is an Open Source and free alternative to Red Hat Enterprise Linux (RHEL), which is a more production/corporate based Linux distro. Debian is known for it's stability, user-friendlyness and a common choice for personal servers and desktop use.

4. Q: "The benefits of virtual machines"
-  A: It'a a simulation of a PC, running inside a PC. It exists isolated from thehost, and has the resources (hardware) you choose to allocate it to, and whatever OS you choose. This is particularly useful if you want to test software in an environment with specific settings, which can be replicated with the use of a virtual machine, instead of aquiring whole other PC with specific specs to test it in.

5. Q: "If the chosen operating system is Debian, they must explain the difference between aptitude and apt, and what APPArmor is."
-  A: apt and aptitude are both package management system. apt uses a command-line interface (meaning you use terminal commands to interact with it) and aptitude uses a terminal user interface (as in an interactive menu running inside the terminal). 
APPArmor is a linux kernel security module that allows the system administrator to restrict programs' capabilities with per-program profiles. With it you can limit certain programs to only access certain information inside your system like network access, read-write-execute permissions and available paths it can have access to.
