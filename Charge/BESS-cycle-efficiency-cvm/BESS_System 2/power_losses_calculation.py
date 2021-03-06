# %%
import matlab.engine
import parameters as param
import scipy.io
from scipy.optimize import curve_fit
import numpy as np
import json

# import matplotlib.pyplot as plt

# Carrega os arquivos .m
eng = matlab.engine.start_matlab()

binv = np.array(scipy.io.loadmat("Binv1.mat").get("Binv1"))
bg = np.array(scipy.io.loadmat("Bg1.mat").get("Bg1"))
pcp_ind_lcl = np.array(scipy.io.loadmat("Pcp_ind_LCL.mat").get("Pcp_ind_LCL"))
p_cap_lcl = np.array(scipy.io.loadmat("P_cap_LCL.mat").get("P_cap_LCL"))
pswitches_inv_cond = np.array(
    scipy.io.loadmat("Pchaves_inv_cond.mat").get("Pchaves_inv_cond")
)
pswitches_inv_sw = np.array(
    scipy.io.loadmat("Pchaves_inv_sw.mat").get("Pchaves_inv_sw")
)
i_cap = np.array(scipy.io.loadmat("I_cap.mat").get("I_cap"))
pswitches_conv_cc_cond = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_cond.mat").get("Pchaves_conv_cc_cond")
)
pswitches_conv_cc_sw = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_sw.mat").get("Pchaves_conv_cc_sw")
)
Pcp_inter1 = np.array(scipy.io.loadmat("Pcp_ind_bt.mat").get("Pcp_ind_bt"))
binter1 = np.array(scipy.io.loadmat("Bind1.mat").get("Bind1"))
Pgrid = np.array(scipy.io.loadmat("Pot_grid.mat").get("Pot_grid"))

# Perdas totais nos capacitores do dc-link em relação ao SOC
print("Dc-link loss calculation...")
plosses_dc_link = []
plosses_calc = []
count = 0
for i in range(0, len(i_cap)):
    ic = matlab.double(list(i_cap[i]))

    amplitude, frequency = eng.THD(
        ic, float(1), float(3000), float(0), float(param.ts), float(param.fn)
    )

    # plt.bar(frequency[0], amplitude[0])
    # plt.show()
    def func_fit(x, a, b, c):
        return a * np.float_power(x, b) + c

    popt, pcov = curve_fit(
        func_fit,
        param.freq_c,
        param.ratio_ers,
        bounds=([13.15, -0.9141, 0.7166], [18.87, -0.824, 0.724]),
    )

    # freq_in = np.arange(param.freq_c[0], 60000, 0.01)
    # print(popt)
    # plt.plot(freq_in, func_fit(freq_in, *popt))
    # plt.plot(param.freq_c, param.ratio_ers)
    # plt.show()

    plosses_freq = []
    for n in range(0, len(frequency[0])):
        esr_calc = func_fit((n + 1) * param.fn, *popt) * param.ers_100
        plosses_freq.append(
            param.n_cap_series * param.n_cap_strings * amplitude[0][n] * esr_calc ** 2
        )

    plosses_calc.append(sum(plosses_freq))

plosses_dc_link = np.array(plosses_calc)

# Cálculo das perdas magnéticas nos indutores do filtro LCL
print("Core loss calculation: inverter side inductor of the LCL filter...")


def core_loss_func(mag_flux_dens, count):
    mag_flux_dens = matlab.double(list(np.append(mag_flux_dens, mag_flux_dens[0])))
    time = matlab.double(list(np.arange(0, 1 / param.fn, param.ts)))
    count += 1
    print(count, end=" ")
    return eng.coreloss(
        time, mag_flux_dens, float(param.cn), float(param.xn), float(param.kn), 1
    )  # perdas em W/m3


bg_ac = np.array(
    [
        binv[i][int(len(binv[i]) - ((1 / 60) / (1 / (12000 * 120))) + 1) :]
        for i in range(0, len(binv))
    ]
)

core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(binv))])
plosses_core_linv_lcl = 3 * core_loss * param.vn * 1e-9  # Perdas em W

print("\nCore loss calculation: grid side inductor of the LCL filter...")
bg_ac = np.array(
    [
        bg[i][int(len(bg[i]) - ((1 / 60) / (1 / (12000 * 120))) + 1) :]
        for i in range(0, len(bg))
    ]
)
core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(bg))])
plosses_core_lg_lcl = 3 * core_loss * param.vn * 1e-9  # Perdas em W

print("\nCore loss calculation: interleaved inductor of the dc/dc converter...")
bg_ac = np.array(
    [
        binter1[i][int(len(binter1[i]) - ((1 / param.fswb) / param.ts) + 1) :]
        for i in range(0, len(binter1))
    ]
)
core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(binter1))])
plosses_core_inter1 = 3 * core_loss * param.vn_inter * 1e-9  # Perdas em W

print("\nCopper loss calculation: resistors of the LCL filter...")
plosses_copper_lcl = pcp_ind_lcl

print("ESR loss calculation: capacitors of the LCL filter...")
plosses_esr_lcl = pcp_ind_lcl

print("\nCopper loss calculation: interleaved inductor of the dc/dc converter...")
plosses_copper_inter1 = Pcp_inter1

print("Conduction loss calculation: inverter switches...")
plosses_cond_inv = pswitches_inv_cond

print("Switching loss calculation: inverter switches...")
plosses_switch_inv = pswitches_inv_sw

print("Conduction loss calculation: interleaved switches...")
plosses_cond_inter1 = pswitches_conv_cc_cond

print("Switching loss calculation: interleaved switches...")
plosses_switch_inter1 = pswitches_conv_cc_sw

print("Total power losses calculation...")
total_power_losses = (
    plosses_dc_link
    + plosses_core_linv_lcl
    + plosses_core_lg_lcl
    + plosses_copper_lcl
    + plosses_esr_lcl
    + plosses_cond_inv
    + plosses_switch_inv
    + plosses_core_inter1
    + plosses_copper_inter1
    + plosses_cond_inter1
    + plosses_switch_inter1
)

print("Efficiency calculation...")
efficiency = ((1 - total_power_losses / (-Pgrid)) * 100)[0]

print("Save json file...")
with open("efficiency_bess2.json", "w") as arquivo:
    efficiency_list = efficiency.tolist()
    json.dump(efficiency_list, arquivo)

print("Complete")
# %%
