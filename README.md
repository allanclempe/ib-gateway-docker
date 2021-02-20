# ib-gateway-docker

This builds a Docker image with the latest version of [Interactive Brokers](https://interactivebrokers.com)' [IB Gateway](https://www.interactivebrokers.com/en/index.php?f=5041), the modern [IbcAlpha/IBC](https://github.com/IbcAlpha/IBC) for automation, and a VNC server for debugging purposes.

## Building

```sh
docker build . -t ib-gateway-docker
```

## Running

```sh
docker run -p 4002:4002 -p 5900:5900 \
    --env-file .env
    ib-gateway-docker:latest
```

This will expose port 4002 for the TWS API (usable with, e.g., [ib_insync](https://github.com/erdewit/ib_insync)) and 5900 for VNC (with default password `1358`). **Neither are secure for public internet access**, as the expectation is that private, secure services will sit on top and be the only open interface to the internet.


## Multi instances

Run more than one instance if you want to work with multi clients. Set .env file `IB_INSTANCES` paramater with number of instances. Username, password and ports will be sufixed with underscore + number of instance.

eg:

```bash
IB_INSTANCES=2 # number of instances
TWS_PORT_RANGE=4000-4003 # increase TWS port range
VNC_PORT_RANGE=5900-5002 # increase VNC port range

# first instance config
TWSUSERID_1=<your_username>
TWSPASSWORD_1=<your_password>
TWS_PORT_1=4002
VNC_PORT_1=5900

# second instance config
TWSUSERID_2=<your_username>
TWSPASSWORD_2=<your_password>
TWS_PORT_2=4003
VNC_PORT_2=5901
```

running it:

```cmd
docker run -p 4002:4002 -p 5900:5900 \
           -p 4003:4003 -p 5901:5901 \
           --env-file .env \
           ib-gateway-docker:latest
```