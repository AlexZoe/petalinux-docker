# petalinux-docker

Copy petalinux-v2019.2-final-installer.run file to this folder. Then run:

```
./build.sh
```

After installation, launch petalinux with:

```
docker compose run -v <petalinux_prj_dir/../>:/home/ubuntu/src -v /tftpboot:/tftpboot --rm app
```
