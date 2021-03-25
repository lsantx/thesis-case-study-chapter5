%Armazena as caracteristicas da simulacao atual
mdl = plecs('get', '', 'CurrentCircuit');
%salva path do scope na raiz, se estiver dentro de
%um subsystem usar '/Sub/Scope'
%scopepath = [mdl '/Psemi'];

%carrega um valor inicial em Ih e H  A=Ih 
loadStructure = struct('Iref', 0);
loadStructure = struct('SocInit', 0);
%Cria uma estrutura com as variaveis
varStructure = struct('ModelVars', loadStructure);
%Apaga o scope
%plecs('scope', scopepath, 'ClearTraces');

IbatVals = [-29.99943379, -29.45641858, -27.76633048, -26.16801309, ...
-24.65511808, -23.2222926 , -21.86493081, -20.57899172, ...
-19.36086443, -18.20726831, -17.11517861, -16.08177139, ...
-15.10438273, -14.18047885, -13.30763435, -12.48351674, ...
-11.70587559, -10.97253509, -10.28138924,  -9.6303988 , ...
 -9.01758962]

% A tensão acima corresponde ao seguinte soc. (Somente para conferências)

SocVals = [69, 71.55284214, 73.99366819, 76.29423832, 78.46210462, ...
80.50432198, 82.42752188, 84.23796801, 85.94159836, 87.54405752, ...
89.05072148, 90.46671704, 91.79693709, 93.04605294, 94.21852442, ...
95.31860846, 96.35036653, 97.31767127, 98.22421266, 99.07350384, ...
99.86888671]


for ki = 1:length(IbatVals)
    varStructure.ModelVars.Iref = IbatVals(ki);
    varStructure.ModelVars.SocInit = SocVals(ki);
    Out = plecs('simulate', varStructure);
    Pot_grid(ki) = Out.Values(1,end);
    Pot_bat(ki) = Out.Values(2,end);
    Pchaves_inv_cond(ki) = Out.Values(3,end);
    Pchaves_inv_sw(ki) = Out.Values(4,end);
    Binv1(ki,:) = Out.Values(5,(end-(2/(60)/(1/(12000*120))):end));
    Bg1(ki,:) = Out.Values(6,(end-(2/(60)/(1/(12000*120))):end));
    Pcp_ind_LCL(ki) = Out.Values(7,end);
    P_cap_LCL(ki) = Out.Values(8,end);
    I_cap(ki, :) = Out.Values(9,(end-(2/(60)/(1/(12000*120))):end));
    Ibat(ki) = Out.Values(10,end);
    Vbat(ki) = Out.Values(11,end);
    Pchaves_conv_cc_cond(ki,:) = Out.Values(12,end);
    Pchaves_conv_cc_sw(ki,:) = Out.Values(13,end);
    Pcp_ind_bt(ki,:) = Out.Values(14,end);
    Bind1(ki,:) = Out.Values(15,(end-(2/(60)/(1/(12000*120))):end));
    Pot_bat2(ki) = Out.Values(16,end);
    Pchaves_conv_cc_cond2(ki,:) = Out.Values(17,end);
    Pchaves_conv_cc_sw2(ki,:) = Out.Values(18,end);
    Bind2(ki,:) = Out.Values(19,(end-(2/(60)/(1/(12000*120))):end));
    Pcp_ind_bt2(ki,:) = Out.Values(20,end);
    Ibat2(ki) = Out.Values(21,end);
    Vbat2(ki) = Out.Values(22,end);
end    
                       
%salva a variavel
save("Pot_grid.mat", "-mat", "Pot_grid")
save("Pot_bat.mat", "-mat", "Pot_bat")
save("Pchaves_inv_cond.mat", "-mat", "Pchaves_inv_cond")
save("Pchaves_inv_sw.mat", "-mat", "Pchaves_inv_sw")
save("Binv1.mat", "-mat", "Binv1")
save("Bg1.mat", "-mat", "Bg1")
save("Pcp_ind_LCL.mat", "-mat", "Pcp_ind_LCL")
save("P_cap_LCL.mat", "-mat", "P_cap_LCL")
save("I_cap.mat", "-mat", "I_cap")
save("Ibat.mat", "-mat", "Ibat")
save("Vbat.mat", "-mat", "Vbat")
save("Pchaves_conv_cc_cond.mat", "-mat", "Pchaves_conv_cc_cond")
save("Pchaves_conv_cc_sw.mat", "-mat", "Pchaves_conv_cc_sw")
save("Pcp_ind_bt.mat", "-mat", "Pcp_ind_bt")
save("Bind1.mat", "-mat", "Bind1")
save("Pot_bat2.mat", "-mat", "Pot_bat2")
save("Pchaves_conv_cc_cond2.mat", "-mat", "Pchaves_conv_cc_cond2")
save("Pchaves_conv_cc_sw2.mat", "-mat", "Pchaves_conv_cc_sw2")
save("Bind2.mat", "-mat", "Bind2")
save("Pcp_ind_bt2.mat", "-mat", "Pcp_ind_bt2")
save("Ibat2.mat", "-mat", "Ibat2")
save("Vbat2.mat", "-mat", "Vbat2")

% Bg_f(kx,:) = Out.Values(8,(end-1/(60*1/(12000*256))):end);
% Bi_f(kx,:) = Out.Values(9,(end-1/(60*1/(12000*256))):end);