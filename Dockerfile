# Builder
FROM ubuntu:latest AS builder

RUN apt-get update -y
RUN apt-get install -y unzip dos2unix wget expect curl

WORKDIR /root

RUN wget -q --progress=bar:force:noscroll --show-progress https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh -O install-ibgateway.sh
RUN chmod a+x install-ibgateway.sh

RUN wget -q --progress=bar:force:noscroll --show-progress https://github.com/IbcAlpha/IBC/releases/download/3.8.4-beta.2/IBCLinux-3.8.4-beta.2.zip -O ibc.zip
RUN unzip ibc.zip -d /opt/ibc
RUN chmod a+x /opt/ibc/*.sh /opt/ibc/*/*.sh

COPY run.sh run.sh
COPY start-ib.sh start-ib.sh
RUN dos2unix run.sh
RUN dos2unix start-ib.sh

# Application
FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get install -y x11vnc xvfb socat expect curl

WORKDIR /root

COPY --from=builder /root/install-ibgateway.sh install-ibgateway.sh
RUN (echo "/root/Jts/ibgateway/981"; echo "n") | ./install-ibgateway.sh

RUN mkdir .vnc
RUN x11vnc -storepasswd 1358 .vnc/passwd

COPY --from=builder /opt/ibc /opt/ibc
COPY --from=builder /root/run.sh run.sh
COPY --from=builder /root/start-ib.sh start-ib.sh

COPY ibc_config.ini ibc/config.ini

RUN chmod a+x ./*.sh

ENV DISPLAY :0
ENV IB_INSTANCES 1
ENV TRADING_MODE paper
ENV VNC_PORT 5900
ENV TWS_PORT_RANGE 4000-4099

EXPOSE $TWS_PORT_RANGE
EXPOSE $VNC_PORT

CMD ./run.sh
