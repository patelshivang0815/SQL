# SQL-
Overview

import pandas as pd
import requests
from pprint import pprint
from pandas.compat import StringIO
import matplotlib.pyplot as plt
import csv
import matplotlib 
from config import app_token 
from matplotlib.ticker import FormatStrFormatter
import numpy as np
from sodapy import Socrata

client = Socrata("data.ny.gov", app_token)
