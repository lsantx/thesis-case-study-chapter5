#include <math.h>

#define Vdc Input (0)
#define Vga Input (1)
#define Vgb Input (2)
#define Vgc Input (3)
#define Isa Input (4)
#define Isb Input (5)
#define Isc Input (6)
#define soc Input (7)
#define Bt_mode Input (8)
#define I_disc Input (9)        
#define I_char Input (10)     
#define Vboost Input (11)
#define Vfloat Input (12)
#define Ibat Input (13)

#define fsw ParamRealData(0,0)    
#define Ts ParamRealData(1,0)   
#define fdsp ParamRealData(2,0)  
#define Kpouter ParamRealData(3,0)  
#define Kiouter ParamRealData(4,0)  
#define Kp_pll ParamRealData(5,0)
#define Ki_pll ParamRealData(6,0)
#define Kp_res ParamRealData(7,0)
#define Ki_res ParamRealData(8,0)
#define Vdc_ref ParamRealData(9,0)
#define Kpp ParamRealData(10,0)
#define Kip ParamRealData(11,0)
#define Kpq ParamRealData(12,0)
#define Kiq ParamRealData(13,0)
#define Soc_min ParamRealData(14,0)
#define Nb_series ParamRealData(15,0)   
#define Nb_strings ParamRealData(16,0)  

#define PRD  (fdsp/fsw)/2           						 // COntador Up e Down, PRD = (fdsp/fsw)/2 
#define PRD_div2  PRD/2              						 // PRD_div2 = PRD/2;
#define pi    3.141592653589793   
#define wn    2*pi*fn                 						//Frequência angular fundamental 

//Variaveis de controle 
int enable_vmode = 0;
int enable_cmode = 0;
int enable_dis_mode = 1;
int flag_charge_mode = 1; 
int flagv = 1;
int teste = 0;

//...............Variáveis de Potência e Controle da tensão do link cc
float Qref = 0;
float psat = 200e3;
float count_iref = 0;
float count_iref_charge = 0;
float count_vref_charge = 0;
float Iref = 0;
float P3f = 0;
float Vdc_ant = 0;

//...............Variáveis do Controle de corrente do inversor
float Ir = 300;
float Vpwm_norm_a = 0;
float Vpwm_norm_b = 0;
float Vpwm_norm_c = 0;
float vmin = 0;
float vmax = 0; 
float vsa_svpwm = 0;
float vsb_svpwm = 0;
float vsc_svpwm = 0;
float dutya = 0;
float dutyb = 0;
float dutyc = 0;
int counti = 0;
float Valfa_pos = 0;
float Vbeta_pos = 0;
float Ialfa_pos = 0;
float Ibeta_pos = 0;
//

typedef struct {
	float Xref;
	float Xm;
	float erro;
	float erro_ant;
	float inte;
	float inte_ant;
	float duty;
	float piout;
	float piout_ant;
	float piout_sat;
	float erropi;
	float erropi_ant ;
	float dif;
} sPI;

#define PI_default {0,0,0,0,0,0,0,0,0,0,0,0,0}

sPI PIvdc = PI_default;
sPI PIpll = PI_default;

typedef struct {
float Xref;
float Xm;
float erro;
float erro_ant;
float erro_ant2;
float res;
float res_ant;
float res_ant2;
float pr_out;
float c1;
float c2;
float c3;
float c4;
} sPR;

#define PR_default {0,0,0,0,0,0,0,0,0,0.00004165981311293952,-0.00004165981311293952,-1.999013120731463,1.000000000000000}

sPR PRf_alfa = PR_default;
sPR PRf_beta = PR_default;

typedef struct {
	float x;
	float y;
	float W;
	float b0;
	float b1;
	float b2;
	float b3;
	float a1;
	float a2;
	float V_sogi;
	float V_sogi1;
	float V_sogi2;
	float V_sogi_q;
	float V_sogi_q1;
	float V_sogi_q2;
	float Vm;
	float Vm1;
	float Vm2;
   float I_sogi;
	float I_sogi1;
	float I_sogi2;
	float I_sogi_q;
	float I_sogi_q1;
	float I_sogi_q2;
	float Im;
	float Im1;
	float Im2;

	float K_damp;
	float freq_res;
} sSOGI;

#define SOGI_default {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1.414213562373095,60}

sSOGI SOGI1 = SOGI_default;
sSOGI SOGI2 = SOGI_default;

typedef struct{
float a;
float b;
float c;
} sABC;

#define ABC_default {0,0,0}

sABC Vabc = ABC_default;
sABC Vpwm_abc = ABC_default;
sABC Isabc = ABC_default;

typedef struct{
float alfa;
float beta;
} sAlfaBeta;

#define AlfaBeta_default {0,0}

sAlfaBeta Valfabeta = AlfaBeta_default;
sAlfaBeta Vpwm_alfabeta = AlfaBeta_default;
sAlfaBeta Ialfabeta = AlfaBeta_default;
sAlfaBeta Isalfabeta = AlfaBeta_default;

typedef struct{
float d;
float q;
} sDQ;

#define dq_default {0,0}

sDQ Vdq = dq_default;

typedef struct{
float Valfa_in;
float Vbeta_in;
float angle;
float angle_ant;
float pi_out_ant;
float wf;
} spll;

#define pll_default {0,0,0,0,0,376.99111843077}

spll PLL = pll_default;

//................Parametros do PWM
int count = 0;
int inc = 1;
int S1 = 0;
int S2 = 0;
int S3 = 0;
int S4 = 0;
int S5 = 0;
int S6 = 0;