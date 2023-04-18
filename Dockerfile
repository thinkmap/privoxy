FROM alpine:latest

# change source list
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories
RUN apk update --no-cache && apk upgrade --no-cache

EXPOSE 8118
HEALTHCHECK --interval=30s --timeout=3s CMD nc -z localhost 8118
RUN apk --no-cache --update add privoxy wget ca-certificates bash
RUN \
    wget https://raw.githubusercontent.com/essandess/adblock2privoxy/master/privoxy/ab2p.action -O /etc/privoxy/ab2p.action && \
    wget https://raw.githubusercontent.com/essandess/adblock2privoxy/master/privoxy/ab2p.filter -O /etc/privoxy/ab2p.filter && \
    wget https://raw.githubusercontent.com/essandess/adblock2privoxy/master/privoxy/ab2p.system.action -O /etc/privoxy/ab2p.system.action && \
    wget https://raw.githubusercontent.com/essandess/adblock2privoxy/master/privoxy/ab2p.system.filter -O /etc/privoxy/ab2p.system.filter
    
RUN mv /etc/privoxy/config.new /etc/privoxy/config && \
    sed -i'' 's/127\.0\.0\.1:8118/0\.0\.0\.0:8118/' /etc/privoxy/config && \
    sed -i'' 's/#max-client-connections/max-client-connections/' /etc/privoxy/config && \
    sed -i'' 's/accept-intercepted-requests\ 0/accept-intercepted-requests\ 1/' /etc/privoxy/config && \
    sed -i'' 's/http/https/g' /etc/privoxy/ab2p.system.filter && \
    echo 'actionsfile ab2p.system.action' >> /etc/privoxy/config && \
    echo 'actionsfile ab2p.action' >> /etc/privoxy/config && \
    echo 'filterfile ab2p.system.filter' >> /etc/privoxy/config && \
    echo 'filterfile ab2p.filter' >> /etc/privoxy/config && \
    echo 'forward-socks5t / 172.17.0.1:9151 .'  >> /etc/privoxy/config && \
    echo 'enable-remote-toggle 0' >> /etc/privoxy/config && \
    apk del bash
    
RUN chown privoxy.privoxy /etc/privoxy/*
ENTRYPOINT ["privoxy"]
CMD ["--no-daemon","--user","privoxy","/etc/privoxy/config"]
