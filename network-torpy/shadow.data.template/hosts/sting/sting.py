from torpy import TorClient
import requests
import logging

logging.basicConfig()
# logging.getLogger().setLevel(logging.INFO)
logging.getLogger().setLevel(logging.DEBUG)

hostname = 'myserver'  # It's possible use onion hostname here as well
port = 80

r = requests.get(f"http://{hostname}:{port}")
print(r.status_code)
print(r.text)
print("*" * 100)

with TorClient() as tor:
    # Choose random guard node and create 3-hops circuit
    with tor.create_circuit(3) as circuit:
        # Create tor stream to host 
        print(f"circuit: nodes {c.router() for c in circuit._circuit_nodes}")
        # print(f"circuit: map {circuit._circuits_map}")
        # print(f"circuit: guard {circuit._guard}")
        with circuit.create_stream((hostname, port)) as stream:
            print(f"2circuit: nodes {c.router() for c in circuit._circuit_nodes}")
            # Now we can communicate with host
            stream.send(b'GET / HTTP/1.0\r\nHost: %s\r\n\r\n' % hostname.encode())
            recv = stream.recv(1024)