%% Projeto ganho controle de tensão do link-dc
clear; close all; clc;

s = tf('s');
Cdc = 3e-3;
fs = 6000;
fc = fs/100;
wc = 2*pi*fc;
MF = 60;

%Código

Tplanta = 2/(Cdc*s);

[Amp,PH] = bode(Tplanta,wc);
Gain_PI = 1/Amp;
Phase_PI = -PH - 180 + MF;
Tan_PI = (1/wc)*tan(pi*(Phase_PI + 90)/180);
Kpi = (Gain_PI*wc)/(sqrt(1+(wc*Tan_PI)^2));
KP = Kpi*Tan_PI;
KI = Kpi;

PI = (KP*s +KI)/s;

MF = PI*Tplanta/(1+Tplanta*PI);

% figure
% bode(Tplanta)
% hold
% bode(PI*Tplanta)
% grid
% legend('MA sem PI','MA com PI')
% set(gca,'fontname','times','FontSize',12)

% figure
% bode(MF)
% grid

disp('____________________________________________________');
disp('-------------Ganhos do Controle do Dc-link ----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});

%% Projeto ganho controle de corrente do conversor Dc/Dc 
clear; close all; clc;

s = tf('s');
L = 2.3e-3;
R = 18.59e-3;
Vdc = 1015;
fsw = 12000;
N = 3;                 % numero de braços do interleaved
fc = fsw/10;
Nbseries = 22;
Nbstrins = 2;
Rint = (5.2e-3)*Nbseries/Nbstrins;

K = (Vdc/2)/(R+N*Rint);
Tm = L/(R+N*Rint);

KP = 2*pi*fc*Tm/K;
KI = 2*pi*fc/K;

% s = tf('s');
% PI = KP + KI/s;
% F = K/(1+Tm*s);
% MA = PI*F;
% bode(MA)
% grid


disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente do Boost----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});

disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente do Buck----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});


%COntrole da tensão nas baterias
Ke = N*Rint;
fc1 = 20;
fc2 = fc1/20;
KP = 2*pi*fc2/(2*pi*Ke*(fc1-fc2));
KI = 2*pi*fc1*KP;

s = tf('s');
PI = KP + KI/s;
MA = PI*Ke;
bode(MA)
grid

disp('____________________________________________________');
disp('-------------Ganhos do Controle de Tensão do Buck----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});
%% Coeficientes controlador ressonante
clc;
clear;
Ts = 1/(12000);
wn = 2*pi*60;
h = 1;

s = tf('s');
Gc =  s/(s^2+(h*wn)^2);
opt = c2dOptions('Method','tustin','PrewarpFrequency',h*wn);
Gcz = c2d(Gc,Ts,opt);
[num,den,Tsm] = tfdata(Gcz);

c1 = num{1}(1)/den{1}(1)
c2 = num{1}(3)/den{1}(1)
c3 = den{1}(2)/den{1}(1)
c4 = den{1}(3)/den{1}(1)
