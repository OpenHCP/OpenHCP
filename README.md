## IT'S NOT EVEN ALPHA!!!
## DO NOT USE IT IF YOU'RE NOT POWERUSER/ADMIN!!!

# Open Hosting Control Panel - OpenHCP

Assumptions:
- free / libre control panel for hosting
- security features - as much as possible (don't sacrifice security for speed)
- specialized for shared hosting - LAMP - Linux (stable Debian 64-bit) + Apache 2.4 + MariaDB 10 + PHP-FPM
- very flexible quota (for client and per account)
- simple to use by end-client - REALLY SIMPLE :)
- simple to install and maintain for admin
- use of templates for GUI
- replace sendmail script to send mail() from PHP via authenticated accounts

Plans (it's easier to say what is done...):
- multiserver design (planned from the beginning - only singleserver supported for now)
- extend to other distro (CentOS would be a good start) and derivatives
- extend to other service daemons (nginx, exim, etc.)
- APS Standard
- API for everything
- support for IPv6
- billing (connection to external services via API)

# How to install

1. Install Debian stable Jessie 64-bit with minimal options (SSH for example)
2. apt-get install git
3. git clone https://github.com/OpenHCP/OpenHCP.git
4. cd OpenHCP/install/
5. Edit (if you want) config in "install-config.sh"
6. Provide (if you want) SSL/TLS certificate+key
7. chmod 700 ./install*
8. ./install.sh
