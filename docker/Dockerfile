FROM continuumio/miniconda3

RUN apt-get update -qq \
    && apt-get install -yqq --no-install-recommends \
        git \
        openssh-server \
        net-tools iputils-ping nano acl \
        gcc g++ \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && conda create -n muss python=3.7 -y

COPY resources/ssh_config /etc/ssh/ssh_config
COPY resources/sshd_config /etc/ssh/sshd_config

RUN useradd -ms /bin/bash codatalab \
    && echo codatalab:test | chpasswd \
    && service ssh start \
    && ssh-keygen -A \
    && setfacl -Rm u:codatalab:r-x /etc/ssh \
    && setfacl -m u:codatalab:r-x /etc/passwd \
    && setfacl -m u:codatalab:r-x /etc/shadow

USER codatalab
WORKDIR /home/codatalab

# FIXED bashrc skipping if ran non interactively causing conda ativate to fail 
# TMP fix processing.py waiting for the issue to be solved by this MR : 
RUN git clone --quiet --depth 1 https://github.com/cleyrop/muss.git -b unapei-ia \
    && rm -rf muss/.git* \
    && conda init bash \
    && sed -i '/# If not running interactively/,+5d' ~/.bashrc \
    && echo 'conda activate muss' >> ~/.bashrc \
    && echo 'cd muss' >> ~/.bashrc \
    && . ~/.bashrc \
    && pip install -r requirements.txt \
    && pip install -e .

RUN . ~/.bashrc \ 
    && pip freeze | grep spacy \
    && python -m spacy download fr_core_news_md \
    && chown -R codatalab /home/codatalab

RUN . ~/.bashrc \ 
    && python -m spacy download es_core_news_md

RUN . ~/.bashrc \ 
    && python -m spacy download en_core_web_md

EXPOSE 22
COPY resources/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD tail -f /dev/null
