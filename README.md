# Sting-tor

## Run torpy version

#### Run demo

```
docker compose -f docker-compose-nosgx.yml build tor
docker compose -f docker-compose-nosgx.yml run --rm tor bash
//inside the container
$ cd ../network-torpy
$ rm -rf shadow.data
$ shadow --template-directory shadow.data.template shadow.yaml > shadow.log
```

#### View logs 

node names/configurations found in [network-torpy/shadow.yml](network-torpy/shadow.yaml)
```
//view logs replace {node name} with node name you want to see
$ cat shadow.data/hosts/{node name}/*.stdout
$ cat shadow.data/hosts/{node name}/*.stderr
```

## Run tor client version

#### Run demo

```
docker compose -f docker-compose-nosgx.yml build tor
docker compose -f docker-compose-nosgx.yml run --rm tor bash
//inside the container
$ rm -rf shadow.data
$ shadow --template-directory shadow.data.template shadow.yaml > shadow.log
```
#### View logs 

node names/configurations found in [network/shadow.yml](network/shadow.yaml)

```
//view logs replace {node name} with node name you want to see
$ cat shadow.data/hosts/{node name}/*.stdout
$ cat shadow.data/hosts/{node name}/*.stderr
```