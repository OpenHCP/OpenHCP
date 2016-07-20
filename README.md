# IT'S NOT EVEN ALPHA!!!
# DO NOT USE IT IF YOU'RE NOT POWERUSER/ADMIN!!!

## Open Hosting Control Panel - OpenHCP

Assumptions:
- free / libre (ISC License) control panel for hosting
- security features - as much as possible (don't sacrifice security for speed)
- specialized for shared hosting - LAMP - Linux (stable Debian 64-bit) + Apache 2.4 + MariaDB 10 + PHP-FPM
- very flexible quota (for client and per account)
- simple to use by end-client - REALLY SIMPLE :)
- simple to install and maintain for admin
- use of templates for GUI
- replace sendmail script to send mail() from PHP via authenticated accounts
- trash directory for deleted accounts data (chown to openhcptrash and move out of user subdir, so that we free client quota)

Plans (it's easier to say what is done...):
- multiserver design (planned from the beginning - only singleserver supported for now)
- ability to maintain cross-server quota per-client
- ability to maintain database quota
- extend to other distro (CentOS would be a good start) and derivatives
- extend to other service daemons (nginx, exim, etc.)
- APS Standard
- API for everything
- transactions in API and foreign keys in database
- API with embedded ACL
- support for IPv6
- billing (connection to external services via API)
- move some parts to ansible (or other tool for Ops)
- use random numbers in different places (GID, UID, client ID, etc.) - global ID allocator

## How to install (scripts will replace your packages and configs - you have been warned!)

1. Install Debian stable Jessie 64-bit with minimal options (SSH for example)
2. apt-get install git
3. git clone https://github.com/OpenHCP/OpenHCP.git
4. cd OpenHCP/install/
5. Edit (if you want) config in "install-config.sh"
6. Provide (if you want) SSL/TLS certificate+key
7. chmod 700 ./install*
8. ./install.sh

## features (what is working now)

- installing OpenHCP on Debian stable (Jessie) 64-bit
- configuration in database
- dovecot connected with postfix as authentication and delivery agent
- simplified SQL schema with foreign keys and in InnoDB (XtraDB) - not yet finalised
- SSL/TLS security (but you have to provide cert/key for now)
- amavis with support for policies in SQL
- pure-ftpd with virtual users in SQL
- config and chroot env for PHP-FPM
- apache config for http and https
- sieve global config to put SPAM in Junk mail directory
- ability to deactivate client with all his accounts or just one account - www not included
