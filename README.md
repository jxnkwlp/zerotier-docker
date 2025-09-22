# zerotier-docker

## Source

https://github.com/zyclonite/zerotier-docker

## 

1. Run image
2. Modify planet.json
   1. identity can copy from `/var/lib/zerotier-one/identity.public` in container
3. Copy planet.json to container `/var/lib/zerotier-one/`
4. Run `mkplanet -j ` 


``` shell
$ mkdir ./temp
$ # cp my_planet.json ./temp/planet.json
$ docker run -it --rm  -v ./temp:/temp ghcr.io/jxnkwlp/zerotier:dev /bin/sh
$ cd /temp
$ mkplanet -j
$ exit
$ # cp ./temp/planet <you saved>
```