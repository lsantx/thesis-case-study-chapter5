# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

with open("BESS_System 1/efficiency_bess1.json", "r") as arquivo:
    efficiency_bess1 = np.array(json.load(arquivo))

with open("BESS_System 2/efficiency_bess2.json", "r") as arquivo:
    efficiency_bess2 = np.array(json.load(arquivo))

with open("BESS_System 3/efficiency_bess3.json", "r") as arquivo:
    efficiency_bess3 = np.array(json.load(arquivo))

with open("BESS_System 4/efficiency_bess4.json", "r") as arquivo:
    efficiency_bess4 = np.array(json.load(arquivo))
# %%
