# os-rhel7
**os-rhel7** is a os base image based on a RHEL7 system with systemd enabled. It can be used as server image when simulating environments using docker (for examole for developing/testing ansible playbooks).

# content
the following programs & tools are included and enabled by default:

### /sbin/init as default command
that allows us to run services via systemd like on normal servers

### preinstalled OS packages
the following packages have been explicitely installed:
- ansible
- cronie
- curl
- git
- htop
- net-tools
- openssh-clients
- openssh-server
- python2-pip
- rsync
- sudo


# usage

### example of use within a service
see `test/docker-compose.yml` for an example compose file using this image as both **control** ans **target** servers. Please note, that those containers need to run `privileged`. So make sure to have those entries in your compose file:
```yaml
  cap_add:
    - SYS_ADMIN
  security_opt:
    - seccomp:unconfined
  volumes:
    - /sys/fs/cgroup:/sys/fs/cgroup:ro
```


# troubleshooting
you may encounter one of the following errors:
### Failed to get D-Bus connection: Operation not permitted
that happens when you use other `command` as **/sbin/init** to start the container and then try to use `systemd` commands. I think some dependencies like D-Bus are only started automatically by init
