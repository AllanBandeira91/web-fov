FROM debian:13.7-slim

RUN apt update && apt install ffmpeg curl wget unzip -y

COPY ./publisher.sh .

CMD [ "bash", "publisher.sh" ]
