FROM flink:1.14.4-scala_2.12-java11
ARG dev

# debian (bullseye) source
RUN if [ ! -z "$dev" ]; then \
        echo "deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib \ndeb https://mirrors.aliyun.com/debian-security/ bullseye-security main \ndeb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib \ndeb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib \n" > /etc/apt/sources.list; \
    fi

# install python
RUN echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main \ndeb-src https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main " >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt-get update -y && \
    apt-get install -y python3.6-dev python3.6-distutils && \
    ln -s /usr/bin/python3.6 /usr/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/bin/python

# install pip
RUN curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm -f get-pip.py

# install apache-flink
RUN if [ ! -z "$dev" ]; then pip install -i https://pypi.tuna.tsinghua.edu.cn/simple apache-flink==1.14.4; \
    else pip install apache-flink==1.14.4; fi
