%% Cálculo eficiência global
function global_eff= global_efficiency_func(time_dis,time_ch,pin_dis,plosses_dis,pin_ch,plosses_ch)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Descarga
Pot_bat = pin_dis;
Plosses_tot  = plosses_dis;

t    =   time_dis;
pin  =   Pot_bat;
ploss =  Plosses_tot;

%Integtal da energia de entrada e saída
ein_int_dis = cumtrapz(t,pin)*0.000277778;   %% *0.000277778 conversão de kWs para kWh
eloss_int_dis = cumtrapz(t,ploss)*0.000277778;  %% *0.000277778 conversão de kWs para kWh

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Carga
Pot_grid = pin_ch;
Plosses_tot = plosses_ch;

t     =   time_ch;
pin   =   abs(Pot_grid);
ploss =   Plosses_tot;

%Integtal da energia de entrada e saída
ein_int_ch = cumtrapz(t,pin)*0.000277778;   %%*0.000277778 conversão de kWs para kWh
eloss_int_ch = cumtrapz(t,ploss)*0.000277778;  %%*0.000277778 conversão de kWs para kWh

global_eff = (1 - (eloss_int_dis(end) + eloss_int_ch(end))/((ein_int_dis(end) + ein_int_ch(end)))) * 100