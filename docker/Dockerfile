FROM python:3.7-slim AS builder

ARG user=codatalab
ARG password=test
ARG homedir=/home

RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends wget gzip \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash ${user}

WORKDIR ${homedir}/${user}
USER ${user}

RUN wget -q https://dl.fbaipublicfiles.com/muss/muss_en_mined.tar.gz
RUN ls -al
RUN mkdir muss_en_mined
RUN tar zxf muss_en_mined.tar.gz --directory muss_en_mined
RUN ls -al muss_en_mined
RUN mv muss_en_mined/tmpur8jggas/* muss_en_mined/
RUN ls -al
RUN wget -q https://dl.fbaipublicfiles.com/muss/muss_fr_mined.tar.gz
RUN ls -al
RUN tar zxf muss_fr_mined.tar.gz 
RUN ls -al
# RUN wget -q https://dl.fbaipublicfiles.com/muss/muss_es_mined.tar.gz
# RUN ls -al
# RUN tar zxf muss_es_mined.tar.gz



FROM continuumio/miniconda3

ARG user=codatalab
ARG password=test
ARG homedir=/home

RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        git \
        openssh-server \
        net-tools iputils-ping nano acl \
        gcc g++ \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && conda create -n muss python=3.7 -y \
    \
    && mkdir -p ${homedir}/${user}/.ssh \
    && useradd --home ${homedir}/${user} --no-create-home --shell /bin/bash ${user} --no-log-init \
    && chmod 0700 ${homedir}/${user}/.ssh \
    && chown -R ${user}:${user} ${homedir}/${user} \
    && echo "${user}:${password}" | chpasswd \
    \
    && mkdir /opt/ssh \
    && /usr/bin/ssh-keygen -A \
    && cp /etc/ssh/ssh_host_* /opt/ssh/ \
    && cp /etc/ssh/sshd_config /opt/ssh/ \
    && sed -i -E 's:#?HostKey /etc:HostKey /opt:' /opt/ssh/sshd_config \
    && sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication yes/' /opt/ssh/sshd_config \
    && echo 'Port 2222' >> /opt/ssh/sshd_config \
    && chmod 700 /opt/ssh \
    && chmod 600 /opt/ssh/* \
    && chown -R ${user}:${user} /opt/ssh \
    && mkdir /run/sshd

RUN rm -rf /run/nologin

USER ${user}
WORKDIR ${homedir}/${user}

# FIXED bashrc skipping if ran non interactively causing conda ativate to fail 
# TMP fix processing.py waiting for the issue to be solved by this MR : 
RUN git clone --quiet --depth 1 https://github.com/cleyrop/muss.git -b unapei-ia \
    && rm -rf muss/.git* \
    && conda init bash \
    && sed -i '/# If not running interactively/,+5d' ~/.bashrc \
    && echo 'conda activate muss' >> ~/.bashrc \
    && echo 'cd muss' >> ~/.bashrc \
    && echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile \
    && echo '  . ~/.bashrc' >> ~/.bash_profile \
    && echo 'fi' >> ~/.bash_profile \
    && . ~/.bashrc \
    && pip install -r requirements.txt \
    && pip install -e .

COPY --from=builder ${homedir}/${user}/muss_en_mined ${homedir}/${user}/capfalcnlp/resources/models/muss_en_mined
COPY --from=builder ${homedir}/${user}/muss_fr_mined ${homedir}/${user}/capfalcnlp/resources/models/muss_fr_mined
# COPY --from=builder ${homedir}/${user}/muss_es_mined ${homedir}/${user}/capfalcnlp/resources/models/muss_es_mined

COPY --from=builder ${homedir}/${user}/.local ${homedir}/${user}/.local

RUN . ~/.bashrc \ 
    && pip freeze | grep spacy
EXPOSE 2222
COPY resources/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD tail -f /dev/null
