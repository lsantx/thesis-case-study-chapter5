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



%% Projeto ganho controle de tensão da malha de potência (não usado por enquanto)
% clear; close all; clc;
% 
% s = tf('s');
% Vd = 220*sqrt(2);
% H = (3/2) * Vd;
% fs = 6000;
% fc1 = fs/10;
% fc2 = fc1/10
% 
% %Alocação de polo
% 
% KP = 2*pi*fc2/(2*pi*H*(fc1-fc2));
% KI = 2*pi*fc1*KP;
% 
% disp('____________________________________________________');
% disp('-------------Ganhos do Controle da Potência ativa ----------------');
% disp('____________________________________________________');
% disp({'KP =',num2str(KP)});
% disp({'KI =',num2str(KI)});
% 
% %% Projeto ganho controle de tensão da malha de potência reativa (não usado por enquanto)
% clear; close all; clc;
% 
% s = tf('s');
% Vd = 220*sqrt(2);
% H = (-3/2) * Vd;
% fs = 6000;
% fc1 = fs/10;
% fc2 = fc1/10
% 
% %Alocação de polo
% 
% KP = 2*pi*fc2/(2*pi*H*(fc1-fc2));
% KI = 2*pi*fc1*KP;
% 
% disp('____________________________________________________');
% disp('-------------Ganhos do Controle da Potência Reativa ----------------');
% disp('____________________________________________________');
% disp({'KP =',num2str(KP)});
% disp({'KI =',num2str(KI)});

