//..............Contador Para a interrupção e PWM
count = count + inc;

if(count == PRD) inc = -1;
if(count == 0) inc = 1;

//............................................................Interrupção........................................................................................................
if((count == 0) || (count == PRD))
{
////////////////////////////////////////////////////////Transformada abc para alfa-beta da tensão da rede/////////////////////////////////////
Vabc.a = Vga;
Vabc.b = Vgb;
Vabc.c = Vgc;

Valfabeta.alfa = 0.816496580927726 * (Vabc.a - 0.5*Vabc.b - 0.5*Vabc.c);
Valfabeta.beta = 0.816496580927726 * (0.866025403784439*Vabc.b - 0.866025403784439*Vabc.c);

////////////////////////////////////////////////////////Transformada abc para alfa-beta da corrente do inversor/////////////////////////////////////
Isabc.a = Isa;
Isabc.b = Isb;
Isabc.c = Isc;

Isalfabeta.alfa = 0.816496580927726 * (Isabc.a - 0.5*Isabc.b - 0.5*Isabc.c);
Isalfabeta.beta = 0.816496580927726 * (0.866025403784439*Isabc.b - 0.866025403784439*Isabc.c);

////////////////////////////////////////////////////////DSOGI-PLL////////////////////////////////////////////////////////////////////////////////
//SOGI1.freq_res = PIpll.piout/(2*pi);  //Adaptativo

SOGI1.freq_res = 60; 

////Sogi para a componente alfa da tensão e corrente injetada pelo inversor
SOGI1.Vm = Valfabeta.alfa;
SOGI1.Im = Isalfabeta.alfa;

SOGI1.x =  4*Ts*pi * SOGI1.K_damp *  SOGI1.freq_res;
SOGI1.y = (Ts*2*pi * SOGI1.freq_res)*(Ts*2*pi * SOGI1.freq_res);

SOGI1.b1 = SOGI1.x + SOGI1.y + 4;
SOGI1.b2 = SOGI1.x - SOGI1.y - 4;
SOGI1.b3 = 2*(4 - SOGI1.y);

SOGI1.b0 = SOGI1.x * (1/SOGI1.b1);
SOGI1.a1 = SOGI1.b3 * (1/SOGI1.b1);
SOGI1.a2 = SOGI1.b2 * (1/SOGI1.b1);

SOGI1.W = 4*Ts*pi * SOGI1.freq_res;

SOGI1.V_sogi = SOGI1.b0 * SOGI1.Vm - SOGI1.b0 * SOGI1.Vm2 + SOGI1.a1 * SOGI1.V_sogi1 + SOGI1.a2 * SOGI1.V_sogi2;
SOGI1.I_sogi = SOGI1.b0 * SOGI1.Im - SOGI1.b0 * SOGI1.Im2 + SOGI1.a1 * SOGI1.I_sogi1 + SOGI1.a2 * SOGI1.I_sogi2;

SOGI1.V_sogi_q = SOGI1.W * SOGI1.b0 * SOGI1.Vm1 + SOGI1.V_sogi_q1 * SOGI1.a1 + SOGI1.V_sogi_q2 * SOGI1.a2;
SOGI1.I_sogi_q = SOGI1.W * SOGI1.b0 * SOGI1.Im1 + SOGI1.I_sogi_q1 * SOGI1.a1 + SOGI1.I_sogi_q2 * SOGI1.a2;
	
SOGI1.Vm2 = SOGI1.Vm1;
SOGI1.Vm1 = SOGI1.Vm;
SOGI1.Im2 = SOGI1.Im1;
SOGI1.Im1 = SOGI1.Im;
	
SOGI1.V_sogi2 = SOGI1.V_sogi1;
SOGI1.V_sogi1 = SOGI1.V_sogi;
SOGI1.I_sogi2 = SOGI1.I_sogi1;
SOGI1.I_sogi1 = SOGI1.I_sogi;
	
SOGI1.V_sogi_q2 = SOGI1.V_sogi_q1;
SOGI1.V_sogi_q1 = SOGI1.V_sogi_q;
SOGI1.I_sogi_q2 = SOGI1.I_sogi_q1;
SOGI1.I_sogi_q1 = SOGI1.I_sogi_q;

////Sogi para a componente beta da tensão e corrente injetada pelo inversor
SOGI2.Vm = Valfabeta.beta;
SOGI2.Im = Ialfabeta.beta;

SOGI2.x =  4*Ts*pi * SOGI2.K_damp *  SOGI2.freq_res;
SOGI2.y = (Ts*2*pi * SOGI2.freq_res)*(Ts*2*pi * SOGI2.freq_res);

SOGI2.b1 = SOGI2.x + SOGI2.y + 4;
SOGI2.b2 = SOGI2.x - SOGI2.y - 4;
SOGI2.b3 = 2*(4 - SOGI1.y);

SOGI2.b0 = SOGI2.x * (1/SOGI2.b1);
SOGI2.a1 = SOGI2.b3 * (1/SOGI2.b1);
SOGI2.a2 = SOGI2.b2 * (1/SOGI2.b1);

SOGI2.W = 4*Ts*pi * SOGI2.freq_res;

SOGI2.V_sogi = SOGI2.b0 * SOGI2.Vm - SOGI2.b0 * SOGI2.Vm2 + SOGI2.a1 * SOGI2.V_sogi1 + SOGI2.a2 * SOGI2.V_sogi2;
SOGI2.I_sogi = SOGI2.b0 * SOGI2.Im - SOGI2.b0 * SOGI2.Im2 + SOGI2.a1 * SOGI2.I_sogi1 + SOGI2.a2 * SOGI2.I_sogi2;

SOGI2.V_sogi_q = SOGI2.W * SOGI2.b0 * SOGI2.Vm1 + SOGI2.V_sogi_q1 * SOGI2.a1 + SOGI2.V_sogi_q2 * SOGI2.a2;
SOGI2.I_sogi_q = SOGI2.W * SOGI2.b0 * SOGI2.Im1 + SOGI2.I_sogi_q1 * SOGI2.a1 + SOGI2.I_sogi_q2 * SOGI2.a2;
	
SOGI2.Vm2 = SOGI2.Vm1;
SOGI2.Vm1 = SOGI2.Vm;
SOGI2.Im2 = SOGI2.Im1;
SOGI2.Im1 = SOGI2.Im;
	
SOGI2.V_sogi2 = SOGI2.V_sogi1;
SOGI2.V_sogi1 = SOGI2.V_sogi;
SOGI2.I_sogi2 = SOGI2.I_sogi1;
SOGI2.I_sogi1 = SOGI2.I_sogi;
	
SOGI2.V_sogi_q2 = SOGI2.V_sogi_q1;
SOGI2.V_sogi_q1 = SOGI2.V_sogi_q;
SOGI2.I_sogi_q2 = SOGI2.I_sogi_q1;
SOGI2.I_sogi_q1 = SOGI2.I_sogi_q;

// Cálculo da Seq positiva da tensão e corrente injetada pelo inversor
Valfa_pos = 0.5*(SOGI1.V_sogi-SOGI2.V_sogi_q);
Vbeta_pos = 0.5*(SOGI2.V_sogi+SOGI1.V_sogi_q);
Ialfa_pos = 0.5*(SOGI1.I_sogi-SOGI2.I_sogi_q);
Ibeta_pos = 0.5*(SOGI2.I_sogi+SOGI1.I_sogi_q);

// Potência
P3f = Valfa_pos*Ialfa_pos  + Vbeta_pos*Ibeta_pos;
//Ibat = P3f/Vdc;                                         //Corrente na bateria estimada

///////////////////////////////////////////////PLL
PLL.Valfa_in = Valfa_pos;
PLL.Vbeta_in = Vbeta_pos;

// Transformada alfabeta-dq da tensão
Vdq.d = PLL.Valfa_in*cos(PLL.angle) + PLL.Vbeta_in*sin(PLL.angle);
Vdq.q = PLL.Vbeta_in*cos(PLL.angle) - PLL.Valfa_in*sin(PLL.angle);

// Normalização pelo pico da tensão da rede
PIpll.erropi = Vdq.q/(sqrt(Vdq.q*Vdq.q + Vdq.d*Vdq.d) + 1e-2);

// Controlador PI da PLL
PIpll.inte = PIpll.inte_ant + Ts/2 * (PIpll.erropi  + PIpll.erropi_ant);
PIpll.inte_ant = PIpll.inte;
PIpll.erropi_ant = PIpll.erropi;

PIpll.piout = Kp_pll*PIpll.erropi + Ki_pll*PIpll.inte + PLL.wf; 

// Integrador da PLL para o cálculo do ângulo. Método de integração (Foward)
PLL.angle = PLL.angle_ant + Ts*PLL.pi_out_ant;
PLL.pi_out_ant = PIpll.piout;
if(PLL.angle > 6.283185307179586)  PLL.angle -= 6.283185307179586;
if(PLL.angle < 0.0)  PLL.angle += 6.283185307179586;
PLL.angle_ant = PLL.angle;

//////////////////////////////////////////////////// Modo de carga: manual ou automática (em relação ao Soc)

// Verifica se o sistema está em Stand-by
if(Bt_mode == 0 && enable_vmode == 1)
{
   flag_charge_mode = 1;
   count_iref_charge = 0;
   count_iref = 0;
   enable_vmode=0;
   enable_cmode=0;
}

// Verifica se o modo "Carga da Bateria" está acionado (Bt_mode==2)
if(Bt_mode == 2 && flag_charge_mode == 1) 
{
  enable_cmode=1;
  flag_charge_mode = 0;   // entra uma vez nesse if se Bt_mode == 2
}

/////////////////////////////////////////////////////////////  Standby (Bt_mode == 0) -> Float mode //////////////////////////////////////////////////////////////////

// if(Bt_mode == 0)       
// {

// PIvdc.Xref = Vfloat*Nb_series*Vfloat*Nb_series;                   // Na prática, seria bom colocar em rampa


// PIvdc.Xm = Vdc*Vdc;                                               //Corrente medida para o modo boost (Descarga)

// PIvdc.erro = PIvdc.Xref - PIvdc.Xm;

// PIvdc.erropi = PIvdc.erro - (1/Kpouter)*PIvdc.dif;

// PIvdc.inte = PIvdc.inte_ant + Ts/2 * (PIvdc.erropi  + PIvdc.erropi_ant);
// PIvdc.inte_ant = PIvdc.inte;
// PIvdc.erropi_ant = PIvdc.erropi;

// PIvdc.piout = (-Kpouter*PIvdc.erro - Kiouter*PIvdc.inte); 

// PIvdc.piout_sat = PIvdc.piout;
// if(PIvdc.piout>psat) PIvdc.piout_sat = psat;
// if(PIvdc.piout<-psat) PIvdc.piout_sat= -psat;

// PIvdc.dif = PIvdc.piout - PIvdc.piout_sat;
// }

/////////////////////////////////////////////////////////////  Descarga  //////////////////////////////////////////////////////////////////

if(soc>=Soc_min && Bt_mode == 1 && enable_cmode==0 && enable_vmode==0)        // Condição para inicio da descarga. Soc maior do que o Soc minimo && Bt_mode == 1 (descarga) && carga à corrente constante desabilitada (enable_cmode) && carga à tensão constante (enable_vmode)
{
if(count_iref>=I_disc) 
{
  Iref = I_disc;
}  
else if(count_iref<I_disc) 
{
  count_iref = count_iref + 0.2;
  Iref = count_iref;
}

PIvdc.piout_sat = Iref*Vdc;
}
else if(soc<=Soc_min && Bt_mode == 1)              //Uma vez que o modo de descarga está habilitada (Bt_mode == 1) e o Soc apresenta seu menor valor permissível, os parametros do modo boost são zerados e a carga à corrente constante é acionada (enable_cmode = 1)
{
  enable_cmode = 1;
  count_iref = 0;
}

/////////////////////////////////////////////////////////////  Carga à corrente constante///////////////////////////////////////////////////
if(enable_cmode==1)                // Verifica se o modo de recarga à corrente constante está habilitado e se a tensão da bateria está abaixo da tensão de recarga desejada.          
{

PIvdc.Xref = Vboost*Nb_series*Vboost*Nb_series;
PIvdc.Xm = Vdc*Vdc;                                               //Corrente medida para o modo boost (Descarga)

PIvdc.erro = PIvdc.Xref - PIvdc.Xm;

PIvdc.erropi = PIvdc.erro - (-1/Kpouter)*PIvdc.dif;

PIvdc.inte = PIvdc.inte_ant + Ts/2 * (PIvdc.erropi  + PIvdc.erropi_ant);
PIvdc.inte_ant = PIvdc.inte;
PIvdc.erropi_ant = PIvdc.erropi;

PIvdc.piout = (-Kpouter*PIvdc.erro - Kiouter*PIvdc.inte); 

PIvdc.piout_sat = PIvdc.piout;
//if(PIvdc.piout>psat) PIvdc.piout_sat = psat;
//if(Vdc >= Vboost*Nb_series) enable_vmode = 1;

if(PIvdc.piout<-I_char*Vdc) PIvdc.piout_sat = -I_char*Vdc;

//Vdc_ant = Vdc;

PIvdc.dif = PIvdc.piout - PIvdc.piout_sat;
}
else
{
  flagv = 1;
  enable_vmode = 0;
}

/////////////////////////////////////////////////////////////Inicio do Controle de Corrente///////////////////////////////////////////////////
Ialfabeta.alfa = (PLL.Valfa_in*(PIvdc.piout_sat) + Qref*PLL.Vbeta_in)/(PLL.Valfa_in*PLL.Valfa_in + PLL.Vbeta_in*PLL.Vbeta_in + 1e-2);
Ialfabeta.beta = (PLL.Vbeta_in*(PIvdc.piout_sat) - Qref*PLL.Valfa_in)/(PLL.Valfa_in*PLL.Valfa_in + PLL.Vbeta_in*PLL.Vbeta_in + 1e-2);

// saturalção da corrente
if(Ialfabeta.alfa>Ir) Ialfabeta.alfa = Ir;
if(Ialfabeta.alfa<-Ir) Ialfabeta.alfa = -Ir;
if(Ialfabeta.beta>Ir) Ialfabeta.beta = Ir;
if(Ialfabeta.beta<-Ir) Ialfabeta.beta = -Ir;

/////////////////////////////////////////////////////////Controladores ressonantes////////////////////////////////////////////////////////////

// Componente Alfa
PRf_alfa.Xref = Ialfabeta.alfa;
PRf_alfa.Xm = Isalfabeta.alfa;

PRf_alfa.erro = PRf_alfa.Xref - PRf_alfa.Xm;

PRf_alfa.res = PRf_alfa.c1*PRf_alfa.erro + PRf_alfa.c2*PRf_alfa.erro_ant2 - PRf_alfa.c3*PRf_alfa.res_ant - PRf_alfa.c4*PRf_alfa.res_ant2;
PRf_alfa.res_ant2 = PRf_alfa.res_ant;
PRf_alfa.res_ant = PRf_alfa.res;
PRf_alfa.erro_ant2 = PRf_alfa.erro_ant;
PRf_alfa.erro_ant = PRf_alfa.erro;

//if(counti<10) PRf_alfa.pr_out = Kp_res*PRf_alfa.erro + Ki_res*PRf_alfa.res;
//if(counti>=10)  
PRf_alfa.pr_out = Kp_res*PRf_alfa.erro + Ki_res*PRf_alfa.res + PLL.Valfa_in;

// Componente Beta
PRf_beta.Xref = Ialfabeta.beta;
PRf_beta.Xm = Isalfabeta.beta;

PRf_beta.erro = PRf_beta.Xref - PRf_beta.Xm;

PRf_beta.res = PRf_beta.c1*PRf_beta.erro + PRf_beta.c2*PRf_beta.erro_ant2 - PRf_beta.c3*PRf_beta.res_ant - PRf_beta.c4*PRf_beta.res_ant2;
PRf_beta.res_ant2 = PRf_beta.res_ant;
PRf_beta.res_ant = PRf_beta.res;
PRf_beta.erro_ant2 = PRf_beta.erro_ant;
PRf_beta.erro_ant = PRf_beta.erro;

//if(counti<10) 
//{ 
//counti++;
//PRf_beta.pr_out = Kp_res*PRf_beta.erro + Ki_res*PRf_beta.res;
//}

//if(counti>=10)  
PRf_beta.pr_out = Kp_res*PRf_beta.erro + Ki_res*PRf_beta.res + PLL.Vbeta_in;

////////////////////////////////////////////////Transformada abc para alfabeta da tensão de referência////////////////////////////////////
Vpwm_alfabeta.alfa = PRf_alfa.pr_out;
Vpwm_alfabeta.beta = PRf_beta.pr_out;

Vpwm_abc.a = 0.816496580927726*Vpwm_alfabeta.alfa;
Vpwm_abc.b = 0.816496580927726*(-0.5*Vpwm_alfabeta.alfa + 0.866025403784439*Vpwm_alfabeta.beta);
Vpwm_abc.c = 0.816496580927726*(-0.5*Vpwm_alfabeta.alfa - 0.866025403784439*Vpwm_alfabeta.beta);

////////////////////////////////////////////////Normalização pela tensão do barramento cc////////////////////////////////////
Vpwm_norm_a = Vpwm_abc.a*1.732050807568877/Vdc;
Vpwm_norm_b = Vpwm_abc.b*1.732050807568877/Vdc;
Vpwm_norm_c = Vpwm_abc.c*1.732050807568877/Vdc;

if(Vpwm_norm_a > 1) Vpwm_norm_a = 1;
if(Vpwm_norm_a < -1) Vpwm_norm_a = -1;
if(Vpwm_norm_b > 1) Vpwm_norm_b = 1;
if(Vpwm_norm_b < -1) Vpwm_norm_b = -1;
if(Vpwm_norm_c > 1) Vpwm_norm_c = 1;
if(Vpwm_norm_c < -1) Vpwm_norm_c = -1;

//Cálculo da seq zero para o SVPWM
if(Vpwm_norm_a<Vpwm_norm_b && Vpwm_norm_a<Vpwm_norm_c && Vpwm_norm_b>Vpwm_norm_c) 
{
  vmin = Vpwm_norm_a;
  vmax = Vpwm_norm_b;
}  
else if(Vpwm_norm_a<Vpwm_norm_b && Vpwm_norm_a<Vpwm_norm_c && Vpwm_norm_c>Vpwm_norm_b) 
{
  vmin = Vpwm_norm_a;
  vmax = Vpwm_norm_c;
}  
else if(Vpwm_norm_b<Vpwm_norm_a && Vpwm_norm_b<Vpwm_norm_c && Vpwm_norm_a>Vpwm_norm_c) 
{
  vmin = Vpwm_norm_b;
  vmax = Vpwm_norm_a;
}  
else if(Vpwm_norm_b<Vpwm_norm_a && Vpwm_norm_b<Vpwm_norm_c && Vpwm_norm_c>Vpwm_norm_a) 
{
  vmin = Vpwm_norm_b;
  vmax = Vpwm_norm_c;
} 
else if(Vpwm_norm_c<Vpwm_norm_a && Vpwm_norm_c<Vpwm_norm_b && Vpwm_norm_a>Vpwm_norm_b) 
{
  vmin = Vpwm_norm_c;
  vmax = Vpwm_norm_a;
} 
else if(Vpwm_norm_c<Vpwm_norm_a && Vpwm_norm_c<Vpwm_norm_b && Vpwm_norm_b>Vpwm_norm_a) 
{
  vmin = Vpwm_norm_c;
  vmax = Vpwm_norm_b;
} 

vsa_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_a;
vsb_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_b;
vsc_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_c;

dutya = PRD_div2 + 2/sqrt(3)*vsa_svpwm*PRD_div2;
dutyb = PRD_div2 + 2/sqrt(3)*vsb_svpwm*PRD_div2;
dutyc = PRD_div2 + 2/sqrt(3)*vsc_svpwm*PRD_div2;

} // fecha a interrupção

///////////////////////////////PWM//////////////////////////////////////////////
if(dutya>=count)
{
  S1 = 1;
  S2 = 0;
}
else
{
  S1 = 0;
  S2 = 1;
}

if(dutyb>=count)
{
  S3 = 1;
  S4 = 0;
}
else
{
  S3 = 0;
  S4 = 1;
}

if(dutyc>=count)
{
  S5 = 1;
  S6 = 0;
}
else
{
  S5 = 0;
  S6 = 1;
}

Output(0) = S1;
Output(1) = S2;
Output(2) = S3;
Output(3) = S4;
Output(4) = S5;
Output(5) = S6;
Output(6) = PRf_alfa.Xm;
Output(7) = PRf_alfa.Xref;
Output(8) = PRf_beta.Xm;
Output(9) = PRf_beta.Xref;
Output(10) = sqrt(PIvdc.Xref);
Output(11) = sqrt(PIvdc.Xm);
Output(12) = Vpwm_norm_a;
Output(13) = Vpwm_norm_b;
Output(14) = Vpwm_norm_c;
Output(15) = -I_char*Vboost*Nb_series;
Output(16) = PIvdc.piout;