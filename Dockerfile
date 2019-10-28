FROM justinribeiro/chrome-headless

# default values for environment variables
ENV URL=https://www.allaboutaws.com
ENV AWS_ACCESS_KEY_ID=EMPTY
ENV AWS_SECRET_ACCESS_KEY=EMPTY
ENV AWS_DEFAULT_REGION=EMPTY
ENV AWS_S3_LINK_TTL=EMPTY
ENV AWS_S3_BUCKET=EMPTY
ENV LIGHTHOUSE_SCORE_THRESHOLD=0.80

USER root
RUN apt-get update && \
    apt-get install -y bc curl gnupg2 sudo && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g lighthouse && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    pip install awscli && \
    apt-get purge --auto-remove -y python gnupg2 curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/lighthouse_score && chown chrome:chrome /tmp/lighthouse_score

ADD ./run.sh /tmp/run.sh

ENTRYPOINT /bin/bash /tmp/run.sh