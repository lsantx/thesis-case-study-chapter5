# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

pbat = np.array(scipy.io.loadmat("Pot_bat.mat").get("Pot_bat"))

with open('total_losses.json', 'r') as arquivo:
    total_power_losses = np.array(json.load(arquivo))

print(pbat)
efficiency = (1 - total_power_losses / pbat) * 100

pnom = 105E3
pref = np.array([pnom, pnom * 0.9, pnom * 0.8, pnom * 0.7, pnom * 0.6, pnom * 0.5, pnom * 0.4, pnom * 0.3, pnom * 0.2, pnom * 0.1])
# pref = np.reshape(pref, (-1, 1))
print(efficiency)
soc = np.array([100, 90, 80, 70, 60, 50, 40, 30, 20, 10])

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(8, 6)

level = [value for value in np.arange(89, 94.5, 0.5)]
count1 = ax1.contourf(soc, pref / 1000, efficiency, level)
ax1.set_xlabel('Soc [%]')
ax1.set_ylabel('Power [kW]')
cbar3 = fig.colorbar(count1, ax=ax1)
fig.tight_layout()
plt.show()

# %%
