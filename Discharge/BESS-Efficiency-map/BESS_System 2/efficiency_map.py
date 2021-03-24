# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

pbat = np.array(scipy.io.loadmat("Pot_bat.mat").get("Pot_bat"))

with open("total_losses.json", "r") as arquivo:
    total_power_losses = np.array(json.load(arquivo))

efficiency = (1 - total_power_losses / pbat) * 100

pnom = 100e3
pref = np.array(
    [
        pnom,
        pnom * 0.9,
        pnom * 0.8,
        pnom * 0.7,
        pnom * 0.6,
        pnom * 0.5,
        pnom * 0.4,
        pnom * 0.3,
        pnom * 0.2,
    ]
)
soc = np.array([100, 90, 80, 70, 60, 50, 40, 30, 20])

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(8, 6)

N = 19  # Number of levels
step = (np.amax(efficiency) - np.amin(efficiency)) / N
levels = np.linspace(np.amin(efficiency), np.amax(efficiency), num=N, endpoint=True)
count1 = ax1.contourf(soc, pref / np.amax(pref), efficiency, levels, extend="min")
ax1.set_xlabel("Soc [%]")
ax1.set_ylabel("Power [kW]")
cbar3 = fig.colorbar(count1, ax=ax1)
fig.tight_layout()
plt.show()

# %%
