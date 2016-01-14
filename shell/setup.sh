#!/bin/bash

set -e

# update OS
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get install -y gcc g++ gfortran build-essential git wget linux-image-generic libopenblas-dev htop python-qt4

cd $HOME

ANACONDA2_INSTALLER=Anaconda2-2.4.1-Linux-x86_64.sh
ANACONDA2_HOME=$HOME/anaconda2

# install Anaconda2, most dependencies (except theano, keras, xgboost)
wget https://repo.continuum.io/archive/$ANACONDA2_INSTALLER
bash $ANACONDA2_INSTALLER -b -p $ANACONDA2_HOME -f
rm -f $ANACONDA2_INSTALLER

# Refer to http://docs.continuum.io/anaconda/pkg-docs for packages available in the installer
$ANACONDA2_HOME/bin/conda install -y ipython ipython-notebook seaborn supervisor

#$CONDA install -y ipython ipython-notebook pandas numpy scipy matplotlib scikit-learn supervisor cython nltk

PIP=$ANACONDA2_HOME/bin/pip

# install bleeding edge of theano
$PIP install --upgrade --no-deps git+git://github.com/Theano/Theano.git

# install keras
$PIP install keras

# install xgboost
$PIP install xgboost hyperopt

# other modules: ml_metrics
$PIP install ml_metrics

PYTHON=$ANACONDA2_HOME/bin/python

# update nltk corpus
$PYTHON -c "import nltk; nltk.download('all')"

# set theano to default to using CPU
cat >> $HOME/.theanorc <<EOF
[global]
floatX=float32
device=cpu
mode=FAST_RUN

[nvcc]
fastmath=True
EOF

cat >> $HOME/.bashrc <<EOF
export PATH=/home/ubuntu/anaconda2/bin:$PATH
export LD_LIBRARY_PATH=/home/ubuntu/anaconda2/bin/python:$LD_LIBRARY_PATH
EOF

# create a Kaggle folder
mkdir kaggle
chmod -R 775 kaggle