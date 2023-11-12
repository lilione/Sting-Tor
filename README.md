# Sting-tor

## Run tor client version

#### Build image and enter container:
```
docker compose build tor
docker compose run --rm tor bash
```

#### Inside the container:
```
rm -rf shadow.data
shadow --template-directory shadow.data.template shadow.yaml > shadow.log
```

#### Check result:
```
for d in shadow.data/hosts/*client*; do grep "stream-success" "${d}"/*.stdout ; done | wc -l
for d in shadow.data/hosts/*server*; do grep "stream-success" "${d}"/*.stdout ; done | wc -l
```
