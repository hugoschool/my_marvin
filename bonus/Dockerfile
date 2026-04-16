FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update && \
    apt-get install -y gcc clang make build-essential libcriterion-dev wget sudo

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/llvm.asc && \
    echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/llvm.asc] https://apt.llvm.org/noble/ llvm-toolchain-noble-20 main" | tee /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y clang-20

RUN cd /tmp && \
    wget https://github.com/hugoarnal/cs2/releases/download/v1.7.0/cs2-linux-x86_64 && \
    chmod +x /tmp/cs2-linux-x86_64 && \
    install -Dm755 /tmp/cs2-linux-x86_64 /usr/bin/cs2 && \
    /usr/bin/cs2 install --package=banana-bin && \
    /usr/bin/cs2 install --package=epiclang-bin

COPY mirror.sh /usr/share/mirror.sh

USER jenkins

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
