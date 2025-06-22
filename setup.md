# Setting up a clean install of the VM

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

# BONUS

## Wordpress Website

we need to set up a WordPress website that our VM will host as a server for it.
to do that we will need to download 3 packages:

- `lighttpd` is an open-source, super fast and lightweight web server;
- `mariadb-server` a fork of MySQL, a data management system;
- `php-cgi` & `php-mysql` PHP is a programming language, there are pkgs to run wb apps and connect to a MariaDB(MySQL) database
- `wget` to download files from the web

we need to open open connections through port 80
- `sudo ufw allow 80` to open and `sudo ufw status` to check active ports
then we need to open VM network settings and add a new rule that redirects port 80 to the host's port 8080, exactly like we did for ssh just diferent ports

### installing WordPress
- cd `/var/www/`
- `sudo wget https://wordpress.org/latest.tar.gz` | latest WP version
- `sudo tar -xpf *.tar.gz` && `sudo rm *.tar.gz` | extrat and delete dwl file
- `sudo mv html html_old` && `sudo mv wordpress html`

### MariaDB
- `sudo mysql_secure_installation` this script is intended to protect your MariaDB server installation. answears are: nnYYYY
- switch to sudo then we'll type `mariadb` to enter it
- `CREATE DATABASE wordpress_db`
- `CREATE USER 'manmaria'@'localhost' IDENTIFIED BY '12345';`
- `GRANT ALL PRIVILEGES ON wp_database.* TO 'manmaria'@'localhost';`

### setting up WordPress
- switch to root
- cd `/var/www/html`
- `cp wp-config-sample.php wp-config.php` and `vim wp-config.php`
- inside the .php file define database, user and password(12345) with the info above
- `sudo lighty-enable-mod fastcgi && sudo lighty-enable-mod fastcgi-php && sudo service lighttpd force-reload`
- connect to site by typing in browser `localhost:8080`
- WP password: dJ#5iXLb6^vue4!HOetR$1rT
- to upload files to WordPress:
```
sudo mkdir /var/www/html/wp-content/uploads
sudo chown -R www-data:www-data wp-content/uploads
```

## Minecraft server hihi

I'm running a minecraft server on my VM as part of the project bonus!

```
sudo apt install default-jre
wget https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.ja
rmkdir ~/minecraft-server && mv server.jar minecraft-server && cd minecraft-server
echo "eula=true" > eula.txt # we have to agree to the EULA
vim server.properties
[
    level-seed=2151901553968352745
    level-name=menu-world
    motd=ft_minecraft_server
    max-players=5
    view-distance=7
]
sudo ufw allow 25565
```
- add a rule to VM to port forward port `25565` to an available port in host (`25565` should be fine)

```
vim start-mining.sh 
"#!/bin/bash
java -Xms512M -Xmx1024 -jar server.jar nogui"
chmod +x start-mining.sh
mv start-mining.sh /usr/local/bin
``` 

### lets create a dedicated user to run this server on:

```
# Create a group called 'minecraft'
sudo groupadd minecraft

# Create a user 'minecraft', add it to the 'minecraft' group
sudo useradd -r -m -d /srv/minecraft -s /bin/bash -g minecraft minecraft

# Move previously created minecraft-server files to new location
sudo mv ~/minecraft-server/* /srv/minecraft/
rmdir ~/minecraft-server

# Set correct ownership and permissions
sudo chown -R minecraft:minecraft /srv/minecraft
sudo chmod -R 750 /srv/minecraft
```
- `-r`: system user (no password, no login)
- `-m`: create home directory
- `-d /srv/minecraft`: set home directory to /srv/minecraft
- `-s /bin/bash`: will run on bash
- `-g minecraft`: primary group

### now to create a systemd service

download the `screen` command to run the server in the background but also be able to reatach to the session it is running on
```
sudo apt install screen
```

create a edit this `/etc/systemd/system/minecraft.service` file:
```
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/srv/minecraft
User=minecraft
Group=minecraft
Restart=always
ExecStart=/usr/bin/screen -DmS minecraft /usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui

[Install]
WantedBy=multi-user.target
```
flags used in `screen`:
- `-D`: Detach an already running screen session with the same name (if it exists).
- `-m`: Start screen in “detached” mode. This means the screen session will start running in the background (you don’t need to attach to it immediately).
- `-S` minecraft: Name the screen session minecraft for easy identification and management.

start the service:
```
# To start it on boot:
sudo systemctl enable minecraft
# To start it now:
sudo systemctl start minecraft
# To check its status:
sudo systemctl status minecraft
```

To attach to the Minecraft server console later, run:
```
sudo su - minecraft
screen -r minecraft
```

You’ll then see the live console and can enter Minecraft server commands. To detach without stopping the server, press `Ctrl+A` then `D`.
