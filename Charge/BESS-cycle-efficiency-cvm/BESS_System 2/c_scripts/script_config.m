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

IbatVals = [-59.99943379, -58.91281196, -55.53263714, -52.33600364, ...
-49.31021482, -46.44456498, -43.72984248, -41.15796529, ...
-38.72171169, -36.41452035, -34.23034181, -32.16352821, ...
-30.20875169, -28.36094468, -26.6152564 , -24.96702188, ...
-23.41174024, -21.94505987, -20.56276876, -19.26078845, ...
-18.03517062]

% A tensão acima corresponde ao seguinte soc. (Somente para conferências)

SocVals = [69, 71.55286036, 73.99368537, 76.29425451, 78.46211987, ...
80.50433634, 82.42753541, 84.23798074, 85.94161034, 87.54406878, ...
89.05073207, 90.46672699, 91.79694643, 93.04606171, 94.21853265, ...
95.31861618, 96.35037377, 97.31767806, 98.22421902, 99.0735098 , ...
99.86889229]


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

% Bg_f(kx,:) = Out.Values(8,(end-1/(60*1/(12000*256))):end);
% Bi_f(kx,:) = Out.Values(9,(end-1/(60*1/(12000*256))):end);