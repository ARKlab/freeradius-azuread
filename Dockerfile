FROM alpine:latest
LABEL maintainer="Andrea Cuneo <andrea.cuneo@ark-energy.eu>"

ENV AzureAdDomain=\
    AzureAdClientId=\
    AzureAdSecret=\
    NASName=\
    NASNetwork=\
    NASSecret=

COPY docker-entrypoint.sh /

RUN apk update && apk upgrade && \ 
   apk add --no-cache --update freeradius freeradius-utils freeradius-perl ca-certificates perl-json perl-libwww perl-lwp-protocol-https && \
   chmod +x /docker-entrypoint.sh

COPY freeradius-oauth2-perl /opt/freeradius-oauth2-perl
COPY inner-tunnel default /etc/raddb/sites-available/

RUN printf '\n$INCLUDE /opt/freeradius-oauth2-perl/dictionary\n' >> /etc/raddb/dictionary && \
   ln -s /opt/freeradius-oauth2-perl/module /etc/raddb/mods-enabled/oauth2 && \
   ln -s /opt/freeradius-oauth2-perl/policy /etc/raddb/policy.d/oauth2

EXPOSE 1812/udp 1813/udp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["radiusd"]

