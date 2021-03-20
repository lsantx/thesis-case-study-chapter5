%Armazena as caracteristicas da simulacao atual
mdl = plecs('get', '', 'CurrentCircuit');
%salva path do scope na raiz, se estiver dentro de
%um subsystem usar '/Sub/Scope'
%scopepath = [mdl '/Psemi'];

%carrega um valor inicial em Ih e H  A=Ih 
loadStructure = struct('Pref', 0);
loadStructure = struct('SocInit', 0);
%Cria uma estrutura com as variaveis
varStructure = struct('ModelVars', loadStructure);
%Apaga o scope
%plecs('scope', scopepath, 'ClearTraces');

Pnom = 103e3;
PVals = [Pnom Pnom*0.9 Pnom*0.8 Pnom*0.7 Pnom*0.6 Pnom*0.5 Pnom*0.4 Pnom*0.3 Pnom*0.2 Pnom*0.1];

SocVals = [100 90 80 75 70 60 50 40 30 20];

i = 1
for ki = 1:length(PVals)
    for kj = 1:length(SocVals)
        varStructure.ModelVars.Pref = PVals(ki);
        varStructure.ModelVars.SocInit = SocVals(kj);
        Out = plecs('simulate', varStructure);
        Pot_grid(ki,kj) = Out.Values(1,end);
        Pot_bat(ki,kj) = Out.Values(2,end);
        Pchaves_inv_cond(ki,kj) = Out.Values(3,end);
        Pchaves_inv_sw(ki,kj) = Out.Values(4,end);
        Binv1(i,:) = Out.Values(5,(end-(2/(60)/(1/(12000*120))):end));
        Bg1(i,:) = Out.Values(6,(end-(2/(60)/(1/(12000*120))):end));
        Pcp_ind_LCL(ki,kj) = Out.Values(7,end);
        P_cap_LCL(ki,kj) = Out.Values(8,end);
        I_cap(i,:) = Out.Values(9,(end-(2/(60)/(1/(12000*120))):end));
        Ibat(ki,kj) = Out.Values(10,end);
        Vbat(ki,kj) = Out.Values(11,end);
        Pchaves_conv_cc_cond(ki,kj) = Out.Values(12,end);
        Pchaves_conv_cc_sw(ki,kj) = Out.Values(13,end);
        Pcp_ind_bt(ki,kj) = Out.Values(14,end);
        Bind1(i,:) = Out.Values(15,(end-(2/(60)/(1/(12000*120))):end));
        i = i + 1;
    end    
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