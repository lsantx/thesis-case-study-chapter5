# %% Libraries
import matplotlib.pyplot as plt
import pandas as pd
from math import pi

# Set data
df = pd.DataFrame(
    {
        "group": ["T1", "T2", "T3", "T4"],
        "Global Efficiency": [92.53 / 100, 92.63 / 100, 92.43 / 100, 92.39 / 100],
        "Number of \n Semiconductors": [12 / 36, 24 / 36, 36 / 36, 36 / 36],
        "Number of \n Inductors": [6 / 12, 9 / 12, 12 / 12, 12 / 12],
        "Maximum dc-link \n Voltage": [
            1267.2 / 1267.2,
            1015 / 1267.2,
            1015 / 1267.2,
            1015 / 1267.2,
        ],
        "Inverter IGBT \n Voltage Class": [
            3300 / 3300,
            1700 / 3300,
            1700 / 3300,
            1700 / 3300,
        ],
        "Cost": [0.445, 0.6278, 0.6133, 1],
    }
)

# ------- PART 1: Create background

# number of variable
categories = list(df)[1:]
N = len(categories)

# What will be the angle of each axis in the plot? (we divide the plot / number of variable)
angles = [n / float(N) * 2 * pi for n in range(N)]
angles += angles[:1]

# Initialise the spider plot
ax = plt.subplot(111, polar=True)

# If you want the first axis to be on top:
ax.set_theta_offset(pi / 2)
ax.set_theta_direction(-1)

# Draw one axe per variable + add labels
plt.xticks(angles[:-1], categories)
for tick in ax.xaxis.get_majorticklabels():
    if tick.get_position()[0] < pi:
        tick.set_horizontalalignment("left")
    else:
        tick.set_horizontalalignment("right")

# Draw ylabels
ax.set_rlabel_position(0)
plt.yticks([0.2, 0.4, 0.6, 0.8], [], color="grey", size=7)
plt.ylim(0, 1)


# ------- PART 2: Add plots

# Plot each individual = each line of the data
# I don't make a loop, because plotting more than 3 groups makes the chart unreadable

# Ind1
values = df.loc[0].drop("group").values.flatten().tolist()
values += values[:1]
ax.plot(angles, values, linewidth=2, linestyle="solid", label="T1")
ax.fill(angles, values, "b", alpha=0.1)
plt.xticks(fontsize=14)

# Ind2
values = df.loc[1].drop("group").values.flatten().tolist()
values += values[:1]
ax.plot(angles, values, linewidth=2, linestyle="dashed", label="T2")
ax.fill(angles, values, "r", alpha=0.1)

# Ind3
values = df.loc[2].drop("group").values.flatten().tolist()
values += values[:1]
ax.plot(angles, values, linewidth=2, linestyle="solid", label="T3")
ax.fill(angles, values, "r", alpha=0.1)

# Ind4
values = df.loc[3].drop("group").values.flatten().tolist()
values += values[:1]
ax.plot(angles, values, linewidth=2, linestyle="dotted", label="T4")
ax.fill(angles, values, "r", alpha=0.1)

# Add legend
plt.legend(loc="upper right", bbox_to_anchor=(-0.01, 1.16), fontsize=14)

# Show the graph
plt.show(block=False)
input("hit[enter] to end.")
plt.close("all")
# %%
