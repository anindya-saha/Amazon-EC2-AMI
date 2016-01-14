import re, nltk
from nltk.stem.porter import PorterStemmer

# sklearn tests
from sklearn.cross_validation import train_test_split
from sklearn.naive_bayes import GaussianNB, MultinomialNB, BernoulliNB
from scipy.optimize import fmin_powell
from sklearn.metrics import log_loss
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.decomposition import PCA
from ml_metrics import quadratic_weighted_kappa

# seaborn tests
import matplotlib.pyplot as plt
import seaborn as sns

# xgboost tests
import xgboost as xgb
xgb.__version__

# keras tests
import keras
keras.__version__
from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation
from keras.optimizers import Adam, SGD
from keras.models import model_from_json
from keras.regularizers import l2, l1l2, activity_l1l2
from keras.layers.advanced_activations import PReLU
from keras.layers.normalization import BatchNormalization
from keras.callbacks import History, EarlyStopping

# BeautifulSoup tests
from bs4 import BeautifulSoup

# sqlalchemy tests
from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy import create_engine