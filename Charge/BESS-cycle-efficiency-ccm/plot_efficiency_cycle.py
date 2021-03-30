# %%
import numpy as np
import json
import matplotlib.pyplot as plt

with open("BESS_System 1/efficiency_bess1.json", "r") as arquivo:
    efficiency_bess1 = np.array(json.load(arquivo))

with open("BESS_System 2/efficiency_bess2.json", "r") as arquivo:
    efficiency_bess2 = np.array(json.load(arquivo))

with open("BESS_System 3/efficiency_bess3.json", "r") as arquivo:
    efficiency_bess3 = np.array(json.load(arquivo))

with open("BESS_System 4/efficiency_bess4.json", "r") as arquivo:
    efficiency_bess4 = np.array(json.load(arquivo))

soc = np.array(
    [
        20,
        24.79981119,
        29.59962137,
        34.39943088,
        39.19923984,
        43.99904834,
        48.79885644,
        53.59866416,
        58.39847156,
        63.19827863,
        67.99808539,
        72.79789183,
        77.59769792,
        82.39750361,
        87.19730882,
        91.99711339,
        96.79691704,
        100,
    ]
)

fig, ax = plt.subplots()

ax.plot(
    soc[: len(soc) - 1],
    efficiency_bess1[: len(efficiency_bess1) - 1],
    "ko-",
    label="T1",
)
ax.plot(
    soc[: len(soc) - 1],
    efficiency_bess2[: len(efficiency_bess2) - 1],
    "ro-",
    label="T2",
)
ax.plot(
    soc[: len(soc) - 1],
    efficiency_bess3[: len(efficiency_bess3) - 1],
    "go-",
    label="T3",
)
ax.plot(
    soc[: len(soc) - 1],
    efficiency_bess4[: len(efficiency_bess4) - 1],
    "bo-",
    label="T4",
)
ax.set_xlabel("SOC [%]", fontsize=14)
ax.set_ylabel("Efficiency [%]", fontsize=14)
ax.set_ylim([91.5, 93.5])
plt.yticks(fontsize=11)
plt.xticks(fontsize=11)
plt.legend(bbox_to_anchor=[0.785, 0.5], loc="center", fontsize=13)
plt.grid()
plt.show(block=False)
input("hit[enter] to end.")
plt.close("all")
# %%
