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

VbatVals = [1106.097014 1211.08696 1217.64524616 1223.45983184 1228.89066966 ... 
1234.20672333 1239.63897576 1245.41690426 1251.80186304 1259.12808426]

VbatVals = [1106.09701401, 1207.36979859, 1211.0869696 , 1214.48724801, ...
       1217.64524616, 1220.6200541 , 1223.45983184, 1226.20502078, ...
       1228.89066966, 1231.54818682, 1234.20672333, 1236.89432771, ...
       1239.63897576, 1242.46955866, 1245.41690426, 1248.51490815, ...
       1251.80186304, 1255.32209857, 1259.12808426, 1263.28321417]

% A tensão acima corresponde ao seguinte soc

  SocVals = [20, 22.55989738, 25.11979419, 27.6796907 , 30.23958692, ...
       32.79948289, 35.35937861, 37.91927409, 40.47916934, 43.03906436, ...
       45.59895915, 48.15885372, 50.71874805, 53.27864215, 55.838536, ...
       58.3984296 , 60.95832292, 63.51821595, 66.07810867, 68.63800105]

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