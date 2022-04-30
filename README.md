# 构建镜像

在 ARM 架构下编译要记得参数 `--platform linux/amd64`，否则 `pyarrow` 编译时会出问题。在中国大陆编译则需要带上 `--build-arg dev=1` 以启用国内源加快构建速度。

```sh
docker build --platform linux/amd64 --build-arg dev=1 -t pyflink:1.14.4-scala_2.12-java11-python3.6 .
```

# 使用镜像

```Dockerfile
FROM pyflink:1.14.4-scala_2.12-java11-python3.6
...
```

# 基于此镜像调试

```sh
docker run --rm -it --name demo \
    --platform linux/amd64 \
    --entrypoint bash \
    -v $PWD:/opt/demo \
    pyflink:1.14.4-scala_2.12-java11-python3.6
```


# 构建此镜像的过程

如在 ARM 架构下（如 Mac M1/M1X）编译，需加入 `--platform linux/amd64` 指定 docker 以 amd64 架构启动容器

`--entrypoint bash` 为让容器在 root 环境下启动

```sh
docker run --rm -it \
    --platform linux/amd64 \
    --entrypoint bash \
    flink:1.14.4-scala_2.12-java11
```

然后逐步执行以下指令以安装 `pyflink`

```sh
echo "
deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
" > /etc/apt/sources.list
# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32

apt-get update -y

echo "
deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main 
deb-src https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu focal main 
" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776

apt-get update -y

apt-get install -y python3.6-dev python3.6-distutils
ln -s /usr/bin/python3.6 /usr/bin/python3
ln -s /usr/bin/python3.6 /usr/bin/python

curl https://bootstrap.pypa.io/pip/3.6/get-pip.py -o get-pip.py
python3 get-pip.py
rm -f get-pip.py

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple apache-flink==1.14.4
```

注意：之所以选用 Python 3.6，是因为高于此版本 `apache-flink` 编译不过
