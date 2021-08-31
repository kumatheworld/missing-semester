FROM ubuntu:latest

RUN apt update \
  && apt install software-properties-common \
  && add-apt-repository universe \
  && apt install python3-proselint

ADD entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
