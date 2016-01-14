#!/usr/bin/env bash

# Firewall, security
sudo apt-get --assume-yes --quiet install ufw
sudo ufw disable
sudo bash -c 'yes yes | ufw reset'
sudo ufw allow ssh
sudo ufw limit ssh
sudo ufw allow 8192/tcp
sudo bash -c 'yes yes | ufw enable'
sudo ufw status verbose

# sysctl
sudo tee /etc/sysctl.conf >/dev/null <<EOF
# Hardlinks cannot be created by users if they do not already own the source
# file
fs.protected_hardlinks = 1

# Softlinks can only be followed if
# - they are outside a sticky world-writable directory, or
# - when the uid of the symlink and follower match, or 
# - when the directory owner matches the symlink's owner
fs.protected_symlinks = 1

# any process which has changed privilege level or is execute only will not
# be dumped
fs.suid_dumpable = 0

# hide exposed kernel pointers specifically via /proc interfaces. they
# contain easily memory locations of writable structures of 
# triggerable function pointers
# https://lwn.net/Articles/420403/
kernel.kptr_restrict = 2

# Restricted ptrace. A process can only ptrace another if there's an explicit
# relationship set up in code.
# https://www.kernel.org/doc/Documentation/security/Yama.txt
kernel.yama.ptrace_scope = 1

# Protect ICMP attacks
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Turn on protection for bad icmp error messages
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Turn on syncookies for SYN flood attack protection
net.ipv4.tcp_syncookies = 1

# Log suspcicious packets, such as spoofed, source-routed, and redirect
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.default.send_redirects = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.default.accept_ra_defrtr = 0
net.ipv6.conf.default.accept_ra_pinfo = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.default.autoconf = 0
net.ipv6.conf.default.dad_transmits = 0
net.ipv6.conf.default.max_addresses = 1
net.ipv6.conf.default.router_solicitations = 0
net.ipv6.conf.eth0.accept_ra_rtr_pref = 0

# Turn on execshild. Not supported by Ubuntu, Red Hat only.
# kernel.exec-shield = 1

# After Ubuntu 8.10 default value is 2, https://wiki.ubuntu.com/Security/Features
# kernel.randomize_va_space = 1
EOF

sudo sed -i 's|[#]*PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
sudo sed -i 's|[#]*Banner.*|Banner /etc/issue.net|g' /etc/ssh/sshd_config
sudo tee /etc/issue.net >/dev/null <<EOF
========================================================================
NOTICE TO USERS

THIS IS A PRIVATE COMPUTER SYSTEM. Only authorized users may access this
system. Access by unauthorized users is prohibited. Users (authorized or
unauthorized) have no explicit or implicit expectation of privacy.

Any or all uses of this system and all files on this system may be
intercepted, monitored, recorded, copied, audited, inspected, and
disclosed to authorized site and law enforcement personnel, as well as
authorized officials of other agencies, both domestic and foreign. By
using this system, the user consents to such interception, monitoring,
recording, copying, auditing, inspection, and disclosure at the
discretion of authorized site personnel.

Unauthorized or improper use of this system may result in administrative
disciplinary action and civil and criminal penalties. By continuing to
use this system you indicate your awareness of and consent to these
terms and conditions of use. LOG OFF IMMEDIATELY if you do not agree to
the conditions stated in this warning.
========================================================================

EOF
sudo service ssh restart

sudo apt-get --assume-yes --quiet install fail2ban
