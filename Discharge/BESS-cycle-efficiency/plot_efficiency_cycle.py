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

soc = np.array([100, 95, 90, 85, 80, 75, 70, 65, 60, 55, 50, 45, 40, 35, 30, 25, 20])

fig, ax = plt.subplots()

ax.plot(soc, efficiency_bess1, "ko-", label="T1")
ax.plot(soc, efficiency_bess2, "ro-", label="T2")
ax.plot(soc, efficiency_bess3, "go-", label="T3")
ax.plot(soc, efficiency_bess4, "bo-", label="T4")
ax.set_xlabel("SOC [%]", fontsize=14)
plt.gca().invert_xaxis()
ax.set_ylabel("Efficiency [%]", fontsize=14)
ax.set_ylim([92, 94.5])
plt.yticks(fontsize=11)
plt.xticks(fontsize=11)
plt.legend(bbox_to_anchor=[0.4, 0.03], loc="lower left", fontsize=13)
plt.grid()
plt.show(block=False)
input("hit[enter] to end.")
plt.close("all")
# %%
