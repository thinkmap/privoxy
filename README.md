# privoxy

A privoxy docker image based on Alpine Linux. This image also incoperates AdBlock lists which is from https://projects.zubr.me/wiki/adblock2privoxy

Has socks5 forwarding to 172.17.0.1:9151 enabled by default.

```
docker run -d --restart unless-stopped --name privoxy -p 8118:8118 grinco/privoxy
```
Once the proxy started and set your browser goes through the proxy, you can edit the proxy config at http://config.privoxy.org/

# tor-privoxy
A Tor/Privoxy docker-compose setup for routing from an SSH connection to the Tor network.

# Running the container
To build and start the Tor/privoxy connection, simply run:

```
sudo docker-compose up
```

# Proxy connection
Use SSH to connect to the server running the Docker containers with the following command to create tunnels to Tor/Privoxy

```
ssh -L 127.0.0.1:9050:127.0.0.1:9050 -L 127.0.0.1:8118:127.0.0.1:8118  server.example.com
```

# Do your web requests
You will now need to set up your browser / client to use the HTTP Privoxy proxy on local port 8118 and/or the SOCKS5 Tor proxy on local port 9050

The connection can be confirmed with the following commands from your client machine:

```
curl --proxy localhost:8118 https://www.privoxy.org/
curl --socks5 localhost:9151 https://www.privoxy.org
```
