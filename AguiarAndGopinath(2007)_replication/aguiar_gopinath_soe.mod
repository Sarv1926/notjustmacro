// Modified version of the Aguiar & Gopinath (2007) RBC model with trend shocks
//
// Original Dynare implementation adapted from:
//   Pfeifer, Johannes – "A Guide to Specifying Observation Equations for the Estimation of DSGE Models" (2018)
//   Available at: https://github.com/JohannesPfeifer/DSGE_mod/tree/master/Aguiar_Gopinath_2007
//
// Modifications for this project include GMM-based estimation, updated parameters, and moment-matching procedures.
//
// Purpose: GMM Estimation for small open economy model
//
// This file is distributed under the GNU General Public License v3.0.
// See: https://www.gnu.org/licenses/gpl-3.0.html
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free Software Foundation.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


var c k y b q g l u z uc ul c_y i_y invest nx i_y_percentage c_y_percentage 
    log_y log_c log_i
    delta_y;

predetermined_variables k b; //allows using beginning of period stock notation

varexo eps_z eps_g;

parameters mu_g sigma rho_g delta phi psi b_star alpha rho_z r_star beta gamma b_share sigma_g sigma_z;

@#include "param.m"

//compute steady state values and calibrate the model to a steady state debt to GDP 
//ratio of 0.1
 
model;
y = exp(z)*k^(1-alpha)*(exp(g)*l)^alpha; // Production function (1)
z = rho_z*z(-1)+eps_z; // Definition transitory shock (2)
g = (1-rho_g)*mu_g+rho_g*g(-1)+eps_g; // Definition trend shock 
u = (c^gamma*(1-l)^(1-gamma))^(1-sigma)/(1-sigma); // Cobb-Douglas utility function (3)
uc = gamma*u/c*(1-sigma); //Marginal utility
ul = -(1-gamma)*u/(1-l)*(1-sigma); //Disutility of labor
c+exp(g)*k(+1)=y+(1-delta)*k-phi/2*(exp(g)*k(+1)/k-exp(mu_g))^2*k-b+q*exp(g)*b(+1); // Resource constraint (7)
1/q = 1+r_star+psi*(exp(b(+1)-b_star)-1); // Price of debt (5)
uc*(1+phi*(exp(g)*k(+1)/k-exp(mu_g)))*exp(g)=beta*exp(g*(gamma*(1-sigma)))*uc(+1)*(1-delta+(1-alpha)*y(+1)/k(+1)
                                                  -phi/2*(2*(exp(g(+1))*k(+2)/k(+1)-exp(mu_g))*(-1)*exp(g(+1))*k(+2)/k(+1)+
                                                          (exp(g(+1))*k(+2)/k(+1)-exp(mu_g))^2)); // FOC wrt to capital
ul+uc*alpha*y/l=0; // FOC wrt labor 
uc*exp(g)*q=beta*exp(g*(gamma*(1-sigma)))*uc(+1); // Euler equation for Bonds
invest = exp(g)*k(+1)-(1-delta)*k+phi/2*(exp(g)*k(+1)/k-exp(mu_g))^2*k; // Law of motion for capital (8)

//Definitional equations used for IRFs and moment computations
c_y = c/y; // Consumption to GDP ratio
i_y = invest/y; // Investment to GDP ratio
nx=(b-exp(g)*q*b(+1))/y; //Net export to GDP ratio

//Use logarithm to get variables in percentage deviations
i_y_percentage=log(i_y);
c_y_percentage=log(c_y);
log_y=log(y);
log_c=log(c);
log_i=log(invest);

//Define growth rate of output
delta_y=log(y)-log(y(-1))+g(-1);
end;

steady_state_model;
q=beta*exp(mu_g)^(gamma*(1-sigma)-1);
YKbar=((1/q)-(1-delta))/(1-alpha);
c_y=1+(1-exp(mu_g)-delta)*(1/YKbar)-(1-exp(mu_g)*q)*b_share;
l=(alpha*gamma)/(c_y-gamma*c_y+alpha*gamma);
k=(((exp(mu_g)^alpha)*(l^alpha))/YKbar)^(1/alpha);
y=k^(1-alpha)*(l*exp(mu_g))^alpha;
c=c_y*y;
invest=(exp(mu_g)-1+delta)*k;
b_star=b_share*y;
nx=(y-c-invest)/y;
r_star = 1/q-1;

b = b_star;
z = 0;
g = mu_g;
u = (c^gamma*(1-l)^(1-gamma))^(1-sigma)/(1-sigma);
uc = gamma*u/c*(1-sigma);
ul = -(1-gamma)*u/(1-l)*(1-sigma);
i_y = (exp(g)*k-(1-delta)*k)/y;
i_y_percentage=log(i_y);
c_y_percentage=log(c_y);
log_y=log(y);
log_c=log(c);
log_i=log(invest);
delta_y=mu_g;
end;


//%%%%%%%%%%%%%%%%% replicate Figure 3, p. 88-89 %%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%% Uses unit shock              %%%%%%%%%%%%%%%%%%%%%%%%%
shocks;
var eps_g; stderr 1; 
var eps_z; stderr 1;
end;
resid;
steady;

check;

//%%%%%%%%%%%%%%%%%%%%%% zPlot impulse response functions  %%%%%%%%%%%%%%%%
//histoch_simul(order=1,nomoments,nofunctions) nx c_y_percentage i_y_percentage;

//%%%%%%%%%%%%%%%%%%%%%% zPlot impulse response functions of  %%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%% non-stationary time series          %%%%%%%%%%%%%%

//generate IRF of stationary model variables
//stoch_simul(order=1,nograph) log_y log_c log_i g;
//send_irfs_to_workspace;

//Now back out IRF of non-stationary model variables by adding trend growth back

//log_Gamma_0=0; //Initialize Level of Technology at t=0;
//log_Gamma(1,1)=g_eps_g(1,1)+log_Gamma_0; //Level of Tech. after shock in period 1

// reaccumulate the non-stationary level series; note that AG2007 detrend with X_t-1, thus the technology level in the loop is shifted by 1 period 
//log_y_nonstationary = zeros(options_.irf,1);
//log_c_nonstationary = zeros(options_.irf,1);
//log_i_nonstationary = zeros(options_.irf,1);
//for ii=2:options_.irf
  //  log_Gamma(ii,1)=g_eps_g(ii,1)+log_Gamma(ii-1,1);
    //log_y_nonstationary(ii,1)=log_y_eps_g(ii,1)+log_Gamma(ii-1,1);
    //log_c_nonstationary(ii,1)=log_c_eps_g(ii,1)+log_Gamma(ii-1,1);
    //log_i_nonstationary(ii,1)=log_i_eps_g(ii,1)+log_Gamma(ii-1,1);
//end

//%%%%%%%%%%%%%%%%% Replicate Table 5, p. 94-95  %%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%% Panel A, Column 2 (specification 1) %%%%%%%%%%%%%%%%%%

//reset shocks to specification 1 of Table 4
shocks;
var eps_g; stderr sigma_g/100;
var eps_z; stderr sigma_z/100;
end;



// Simulate series on which to compute moments (Paper uses analytical moments)
stoch_simul(irf=0,order=1,periods=100000,nomoments,nofunctions) log_y delta_y c invest nx;
send_endogenous_variables_to_workspace;    

// Rebuild non-stationary time series by remultiplying with trend Gamma_{t-1}

log_Gamma_0=0; //Initialize Level of Technology at t=0;
log_Gamma(1,1)=g(1,1)+log_Gamma_0; //Level of Tech. after shock in period 1

// reaccumulate the non-stationary level series
log_y_nonstationary = zeros(options_.periods,1);
log_c_nonstationary = zeros(options_.periods,1);
log_i_nonstationary = zeros(options_.periods,1);
for ii=2:options_.periods
    log_Gamma(ii,1)=g(ii,1)+log_Gamma(ii-1,1);
    log_y_nonstationary(ii,1)=log_y(ii,1)+log_Gamma(ii-1,1);
    log_c_nonstationary(ii,1)=log_c(ii,1)+log_Gamma(ii-1,1);
    log_i_nonstationary(ii,1)=log_i(ii,1)+log_Gamma(ii-1,1);
end

// HP-filter the non-stationary time series; note that nx is share of 
// net exports in GDP and does not contain a trend by construction 

[ytrend,ycyclical]=sample_hp_filter([log_y_nonstationary log_c_nonstationary log_i_nonstationary nx],1600);

//compute standard deviations
standard_devs=std(ycyclical)*100;
standard_dev_first_diff=std(delta_y)*100;

//compute relative standard deviations
relative_standard_devs=standard_devs./standard_devs(1);

//compute autocorrelations
autocorrelations(1,1)=corr(ycyclical(2:end,1),ycyclical(1:end-1,1));
autocorrelations(2,1)=corr(delta_y(2:end,1),delta_y(1:end-1,1));

//compute correlations
correlations=corr(ycyclical(:,1),ycyclical(:,2:end));

//Display everything
fprintf('\n Table 5 - Moments\n');
fprintf('%20s \t %3.2f\n','sigma(y)',standard_devs(1,1));
fprintf('%20s \t %3.2f\n','sigma(c)',standard_devs(1,2));
fprintf('%20s \t %3.2f\n','sigma(delta y)',standard_dev_first_diff);
fprintf('%20s \t %3.2f\n','sigma(c)/sigma(y)',relative_standard_devs(2));
fprintf('%20s \t %3.2f\n','sigma(i)/sigma(y)',relative_standard_devs(3));
fprintf('%20s \t %3.2f\n','sigma(nx)/sigma(y)',relative_standard_devs(4));
fprintf('%20s \t %3.2f\n','rho(y)',autocorrelations(1,1));
fprintf('%20s \t %3.2f\n','rho(delta y)',autocorrelations(2,1));
fprintf('%20s \t %3.2f\n','rho(y,nx)',correlations(3));
fprintf('%20s \t %3.2f\n','rho(y,c)',correlations(1));
fprintf('%20s \t %3.2f\n','rho(y,i)',correlations(2));

// Save simulated moments to oo_.simulated_moments
oo_.simulated_moments.standard_devs = standard_devs;
oo_.simulated_moments.standard_dev_first_diff = standard_dev_first_diff;
oo_.simulated_moments.relative_standard_devs = relative_standard_devs;
oo_.simulated_moments.autocorrelations = autocorrelations;
oo_.simulated_moments.correlations = correlations;

