%Armazena as caracteristicas da simulacao atual
mdl = plecs('get', '', 'CurrentCircuit');
%salva path do scope na raiz, se estiver dentro de
%um subsystem usar '/Sub/Scope'
%scopepath = [mdl '/Psemi'];

%carrega um valor inicial
loadStructure = struct('Vref', 0);
loadStructure = struct('SocInit', 0);
%Cria uma estrutura com as variaveis
varStructure = struct('ModelVars', loadStructure);
%Apaga o scope
%plecs('scope', scopepath, 'ClearTraces');

VbatVals = [1109.73270308, 1187.59866294, 1192.13518739, 1195.79736548, ...
       1198.85199236, 1201.47672114, 1203.79733521, 1205.90906535, ...
       1207.89008733, 1209.81142576, 1211.74600686, 1213.77949769, ...
       1216.02692822, 1218.66342031, 1221.99011826, 1226.59873068, ...
       1233.87022681]

% A tensão acima corresponde ao seguinte soc. (Somente para conferências)

  SocVals = [ 20,  24.80994676,  29.61989258,  34.4298378, ...
       39.2397825 ,  44.04972677,  48.85967067,  53.66961424, ...
       58.47955749,  63.28950045,  68.09944312,  72.90938549, ...
       77.71932753,  82.52926921,  87.33921043,  92.14915107, ...
       96.95909083]

for ki = 1:length(VbatVals)
    varStructure.ModelVars.Vref = VbatVals(ki);
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

% Bg_f(kx,:) = Out.Values(8,(end-1/(60*1/(12000*256))):end);
% Bi_f(kx,:) = Out.Values(9,(end-1/(60*1/(12000*256))):end);