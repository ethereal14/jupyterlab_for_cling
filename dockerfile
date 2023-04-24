FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

USER root

RUN mkdir /opt/notebooks \
    && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
    && apt update -y \
    && apt install -y nodejs npm vim curl wget python3 python3-pip libz3-dev -y \
    && alias python=python3

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ jupyterlab \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ pandas \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ jupyterlab-language-pack-zh-CN \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ numpy \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ matplotlib \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ tqdm \
    && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ scikit-learn \
    && jupyter lab --generate-config \
    && chmod -R 777 /root/.jupyter/jupyter_lab_config.py \
    && chmod -R 777 /opt/notebooks

RUN pip install "jupyterlab-kite>=2.0.2" \
    && pip install jupyterlab_code_formatter \
    && pip install ipympl

# RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple/ jupyterlab-language-pack-zh-CN

ADD ./cling/ /opt/cling

VOLUME /opt/notebooks

EXPOSE 8888

ENV PATH="/opt/cling/bin/:${PATH}"

CMD jupyter lab --notebook-dir=/opt/notebooks --ip='*' --port=8888 --allow-root --no-browser