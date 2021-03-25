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

IbatVals = [-59.9997169 , -58.91279937, -55.53262524, -52.33599238, ...
-49.31020416, -46.44455488, -43.72983291, -41.15795623, ...
-38.7217031 , -36.41451221, -34.23033412, -32.16352093, ...
-30.20874481, -28.36093817, -26.61525025, -24.96701608, ...
-23.41173477, -21.94505471, -20.5627639 , -19.26078387, ...
-18.03516631]

% A tensão acima corresponde ao seguinte soc. (Somente para conferências)

SocVals = [69, 71.55286947, 73.99369395, 76.2942626 , 78.46212749, ...
80.50434352, 82.42754217, 84.2379871 , 85.94161632, 87.54407441, ...
89.05073736, 90.46673196, 91.7969511 , 93.04606609, 94.21853676, ...
95.31862004, 96.35037739, 97.31768145, 98.2242222 , 99.07351277, ...
99.86889507]

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