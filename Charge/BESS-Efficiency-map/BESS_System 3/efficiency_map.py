# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

pgrid = np.array(scipy.io.loadmat("Pot_grid.mat").get("Pot_grid"))
vbat = np.array(scipy.io.loadmat("Vbat.mat").get("Vbat"))
ibat = np.array(scipy.io.loadmat("Ibat.mat").get("Ibat"))

with open("total_losses.json", "r") as arquivo:
    total_power_losses = np.array(json.load(arquivo))

efficiency = (1 - total_power_losses / (-pgrid)) * 100

pnom = 100e3
pref = np.array(
    [
        pnom * 0.3500,
        pnom * 0.3125,
        pnom * 0.2750,
        pnom * 0.2375,
        pnom * 0.2000,
        pnom * 0.1625,
        pnom * 0.1250,
        pnom * 0.0875,
        pnom * 0.0500,
    ]
)
soc = np.array([20, 30, 40, 50, 60, 70, 80, 90, 100])

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(8, 6)

N = 1000  # Number of levels
step = (np.amax(efficiency) - np.amin(efficiency)) / N
levels = np.linspace(np.amin(efficiency), np.amax(efficiency), num=N, endpoint=True)
count1 = ax1.contourf(soc, pref / pnom, efficiency, levels, extend="min", cmap="jet")
ax1.set_xlabel("Soc [%]", fontsize=14)
ax1.set_ylabel("Power [pu]", fontsize=14)
plt.yticks(fontsize=11)
plt.xticks(fontsize=11)
cbar = fig.colorbar(count1, ax=ax1)
cbar.set_label("Efficiency [%]", fontsize=14)
cbar.ax.tick_params(labelsize=11)  # set your label size here
fig.tight_layout()
plt.show(block=False)
input("hit[enter] to end.")
plt.close("all")
