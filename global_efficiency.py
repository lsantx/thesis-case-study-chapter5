
# %% Loading imports...
import json
import numpy as np
import scipy.io
import matlab.engine
eng = matlab.engine.start_matlab()
# %% System 1...

with open("Discharge/BESS-cycle-efficiency/BESS_System 1/total_power_losses_bess1.json", "r") as arquivo:
    power_losses_dis_bess = np.array(json.load(arquivo))

with open("Charge/BESS-cycle-efficiency-ccm/BESS_System 1/total_power_losses_bess1.json", "r") as arquivo:
    power_losses_ch_bess = np.array(json.load(arquivo))

pbat_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 1/Pot_bat.mat").get("Pot_bat"))

pgrid_ch = np.array(scipy.io.loadmat("Charge/BESS-cycle-efficiency-ccm/BESS_System 1/Pot_grid.mat").get("Pot_grid"))

time_dis = np.array([0, 187.04, 373.68, 562.07, 747.58, 935.86, 1121.36, 1312.41, 1497.92, 1686.20, 1874.48, 2059.92, 2248.2648, 2433.7728, 2624.4, 2810.33, 2998.6056]).reshape(1, 17)

time_ch = np.array([2998.6056, 3538.2816, 4078.368, 4618.548, 5158.69, 5698.152, 6238.476, 6778.62, 7318.51, 7858.224, 8398.332, 8938.404, 9479.16, 10018.116, 10559.41, 11099.16, 11639.16, 11999.88]).reshape(1, 18)

global_eff_sys = eng.global_efficiency_func(matlab.double(time_dis.tolist()), matlab.double(time_ch.tolist()), matlab.double(pbat_dis.tolist()), matlab.double(power_losses_dis_bess.tolist()), matlab.double(pgrid_ch.tolist()), matlab.double(power_losses_ch_bess.tolist()))

print(f'Sys1 Global Efficiency = {round(global_eff_sys, 2)} %')
# %% System 2...

with open("Discharge/BESS-cycle-efficiency/BESS_System 2/total_power_losses_bess2.json", "r") as arquivo:
    power_losses_dis_bess = np.array(json.load(arquivo))

with open("Charge/BESS-cycle-efficiency-ccm/BESS_System 2/total_power_losses_bess2.json", "r") as arquivo:
    power_losses_ch_bess = np.array(json.load(arquivo))

pbat_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 2/Pot_bat.mat").get("Pot_bat"))

pgrid_ch = np.array(scipy.io.loadmat("Charge/BESS-cycle-efficiency-ccm/BESS_System 2/Pot_grid.mat").get("Pot_grid"))

time_dis = np.array([0, 187.04, 373.68, 562.07, 747.58, 935.86, 1121.36, 1312.41, 1497.92, 1686.20, 1874.48, 2059.92, 2248.2648, 2433.7728, 2624.4, 2810.33, 2998.6056]).reshape(1, 17)

time_ch = np.array([2998.6056, 3538.2816, 4078.368, 4618.548, 5158.69, 5698.152, 6238.476, 6778.62, 7318.51, 7858.224, 8398.332, 8938.404, 9479.16, 10018.116, 10559.41, 11099.16, 11639.16, 11999.88]).reshape(1, 18)

global_eff_sys = eng.global_efficiency_func(matlab.double(time_dis.tolist()), matlab.double(time_ch.tolist()), matlab.double(pbat_dis.tolist()), matlab.double(power_losses_dis_bess.tolist()), matlab.double(pgrid_ch.tolist()), matlab.double(power_losses_ch_bess.tolist()))

print(f'Sys2 Global Efficiency = {round(global_eff_sys, 2)} %')
# %% System 3...

with open("Discharge/BESS-cycle-efficiency/BESS_System 3/total_power_losses_bess3.json", "r") as arquivo:
    power_losses_dis_bess = np.array(json.load(arquivo))

with open("Charge/BESS-cycle-efficiency-ccm/BESS_System 3/total_power_losses_bess3.json", "r") as arquivo:
    power_losses_ch_bess = np.array(json.load(arquivo))

pbat_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 3/Pot_bat2.mat").get("Pot_bat2"))

pbat2_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 3/Pot_bat.mat").get("Pot_bat"))

pbat_tot_dis = pbat_dis + pbat2_dis

pgrid_ch = np.array(scipy.io.loadmat("Charge/BESS-cycle-efficiency-ccm/BESS_System 3/Pot_grid.mat").get("Pot_grid"))

time_dis = np.array([0, 187.04, 373.68, 562.07, 747.58, 935.86, 1121.36, 1312.41, 1497.92, 1686.20, 1874.48, 2059.92, 2248.2648, 2433.7728, 2624.4, 2810.33, 2998.6056]).reshape(1, 17)

time_ch = np.array([2998.6056, 3538.2816, 4078.368, 4618.548, 5158.69, 5698.152, 6238.476, 6778.62, 7318.51, 7858.224, 8398.332, 8938.404, 9479.16, 10018.116, 10559.41, 11099.16, 11639.16, 11999.88]).reshape(1, 18)

global_eff_sys = eng.global_efficiency_func(matlab.double(time_dis.tolist()), matlab.double(time_ch.tolist()), matlab.double(pbat_tot_dis.tolist()), matlab.double(power_losses_dis_bess.tolist()), matlab.double(pgrid_ch.tolist()), matlab.double(power_losses_ch_bess.tolist()))

print(f'Sys3 Global Efficiency = {round(global_eff_sys, 2)} %')
# %% System 4...

with open("Discharge/BESS-cycle-efficiency/BESS_System 4/total_power_losses_bess4.json", "r") as arquivo:
    power_losses_dis_bess = np.array(json.load(arquivo))

with open("Charge/BESS-cycle-efficiency-ccm/BESS_System 4/total_power_losses_bess4.json", "r") as arquivo:
    power_losses_ch_bess = np.array(json.load(arquivo))

pbat_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 4/Pot_bat2.mat").get("Pot_bat2"))

pbat2_dis = np.array(scipy.io.loadmat("Discharge/BESS-cycle-efficiency/BESS_System 4/Pot_bat.mat").get("Pot_bat"))

pbat_tot_dis = pbat_dis + pbat2_dis

pgrid_ch = np.array(scipy.io.loadmat("Charge/BESS-cycle-efficiency-ccm/BESS_System 4/Pot_grid.mat").get("Pot_grid"))

time_dis = np.array([0, 187.04, 373.68, 562.07, 747.58, 935.86, 1121.36, 1312.41, 1497.92, 1686.20, 1874.48, 2059.92, 2248.2648, 2433.7728, 2624.4, 2810.33, 2998.6056]).reshape(1, 17)

time_ch = np.array([2998.6056, 3538.2816, 4078.368, 4618.548, 5158.69, 5698.152, 6238.476, 6778.62, 7318.51, 7858.224, 8398.332, 8938.404, 9479.16, 10018.116, 10559.41, 11099.16, 11639.16, 11999.88]).reshape(1, 18)

global_eff_sys = eng.global_efficiency_func(matlab.double(time_dis.tolist()), matlab.double(time_ch.tolist()), matlab.double(pbat_tot_dis.tolist()), matlab.double(power_losses_dis_bess.tolist()), matlab.double(pgrid_ch.tolist()), matlab.double(power_losses_ch_bess.tolist()))

print(f'Sys4 Global Efficiency = {round(global_eff_sys, 2)} %')
