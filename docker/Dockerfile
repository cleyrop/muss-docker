FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ARG user=codatalab
ARG password=test
ARG homedir=/home
ARG branch=unapei-ia

RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        git wget nvidia-utils-440 \
        openssh-server \
        net-tools iputils-ping nano acl \
        gcc g++ \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3 /usr/bin/python

ENV PATH /opt/conda/bin:$PATH

RUN conda create -n muss python=3.7 cudatoolkit cudnn gunicorn -y \
    \
    && mkdir -p ${homedir}/${user}/.ssh \
    && mkdir -p ${homedir}/${user}/input-files \
    && useradd --home ${homedir}/${user} --no-create-home --shell /bin/bash --uid 2001 ${user} --no-log-init \
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
    && echo 'PidFile /var/local/run/sshd.pid' >> /opt/ssh/sshd_config \
    && echo 'Port 2222' >> /opt/ssh/sshd_config \
    && chmod 700 /opt/ssh \
    && chmod 600 /opt/ssh/* \
    && chown -R ${user}:${user} /opt/ssh \
    && mkdir /run/sshd \
    && mkdir -p /var/local/run \
    && chmod -R 777 /var/local/run \
    && chown -R ${user}:${user} /var/local \
    && rm -rf /run/nologin

USER ${user}
WORKDIR ${homedir}/${user}


# FIXED bashrc skipping if ran non interactively causing conda ativate to fail 
# TMP fix processing.py waiting for the issue to be solved by this MR : 
RUN git clone --quiet --depth 1 https://github.com/cleyrop/muss.git -b ${branch} \
    && rm -rf muss/.git* \
    && conda init bash \
    && sed -i '/# If not running interactively/,+5d' ~/.bashrc \
    && echo 'conda activate muss' >> ~/.bashrc \
    && echo 'cd muss' >> ~/.bashrc \
    && echo 'if [ -f ~/.bashrc ]; then' >> ~/.bash_profile \
    && echo '  . ~/.bashrc' >> ~/.bash_profile \
    && echo 'fi' >> ~/.bash_profile

ENV FLASK_APP=ia
ENV FLASK_ENV=production
ENV TMPDIR=${homedir}/${user}/input-files

EXPOSE 2222
COPY --chown=${user} resources/gunicorn.conf.py /usr/local/etc/
COPY resources/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
# CMD tail -f /dev/null
