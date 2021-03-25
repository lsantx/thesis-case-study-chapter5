%Armazena as caracteristicas da simulacao atual
mdl = plecs('get', '', 'CurrentCircuit');
%salva path do scope na raiz, se estiver dentro de
%um subsystem usar '/Sub/Scope'
%scopepath = [mdl '/Psemi'];

%carrega um valor inicial
loadStructure = struct('Iref', 0);
loadStructure = struct('SocInit', 0);
%Cria uma estrutura com as variaveis
varStructure = struct('ModelVars', loadStructure);
%Apaga o scope
%plecs('scope', scopepath, 'ClearTraces');

IbatVals = [-29.45644379, -27.76635431, -26.16803563, ...
       -24.65513943, -23.22231282, -21.86494997, -20.57900986, ...
       -19.36088162, -18.20728458, -17.11519401, -16.08178596, ...
       -15.10439651, -14.18049187, -13.30764664, -12.48352835, ...
       -11.70588654, -10.97254542, -10.28139897,  -9.63040796, ...
       -9.01759824]

% A tensão acima corresponde ao seguinte soc. (Somente para conferências)

SocVals = [71.55280569, 73.99363383, 76.29420594, 78.46207411, ...
       80.50429324, 82.42749483, 84.23794254, 85.9415744 , 87.54403499, ...
       89.0507003 , 90.46669714, 91.7969184 , 93.04603539, 94.21850795, ... 
       95.31859302, 96.35035205, 97.31765769, 98.22419994, 99.07349192, ...
       99.86887555]

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