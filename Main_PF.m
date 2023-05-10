close all; clear;   % close all figures and clear all variables
set(0,'defaulttextinterpreter','latex','DefaultAxesFontSize',12) % for plotting

%% Input data
% Read the particles from file
path_data = '.\data_TL_400samples';
%path_data = '.\data_TL_40samples';
filename = '\input.csv';
parameters = ["E", "Su"];
par_ensemble = readtable([path_data, filename], 'VariableNamingRule', 'preserve');
nprm = width(par_ensemble);         % number of parameters 
nsample = height(par_ensemble);     % number of particles
%par_ensemble.(parameters(1))       % E
%par_ensemble.(parameters(2))       % Su

% Read observation data from file
stages = ["Stage0", "Stage1", "Stage2", "Stage3", "Stage4"];
filename = '\observations.csv';
d_obs = readtable([path_data, filename], 'VariableNamingRule', 'preserve');
obs_number = height(d_obs);         % number of observation points
sstep = width(d_obs);               % number of data assimilation steps


% Read calculation data from files
filename = '\output.csv';
d_calc = readtable([path_data, filename], 'VariableNamingRule', 'preserve');
%d_calc.(stages(2))

% Covariance matrix
cvrc = 20.0^2*diag(ones(obs_number,1));


%% Data assimilation
% Perform particle filter data assimilation
wght = cell(nsample,1);         % storage for each particle's weight
wght(1:end) = {1/nsample};      % initial weights 
en_mean = zeros(nprm,sstep+1);    % ensemble' mean at each time step
en_std = zeros(nprm,sstep+1);     % ensemble' standard deviation at each time step
en_cov = zeros(nprm,sstep+1);     % ensemble' covariance at each time step

%Plot distribution at the initial configuration
as_ensemble = zeros(nprm,nsample); % assimilated ensemble
for e=1:nsample
    as_ensemble(:,e) = par_ensemble{e,:}*wght{e};
end
en_mean(:,1) = sum(as_ensemble,2);
en_cov(:,1) = zeros(nprm,1);
for e=1:nsample
    en_cov(:,1) = en_cov(:,1) + wght{e}*(par_ensemble{e,:}'-en_mean(:,1)).^2;
end
en_std(:,1) = sqrt(en_cov(:,1));
plot2dDistribution(1,par_ensemble,wght,en_mean,en_cov)
for i=1:nprm
    plotDistribution(i,1,nsample,par_ensemble,wght);
end

% Loop over time step and perform assimilation
for k=1:sstep
    pe = cell(nsample,1);       % likelihood of each ensemble
    w_sum_pe = 0;               % weighted sum over the particles' likelihood
    for e=1:nsample
        % Evaluation of the likelihood
        pe{e} = evaluateLikelihood(k,d_obs,d_calc{e, :},cvrc);     
        w_sum_pe = w_sum_pe + pe{e}*wght{e};
    end
    
    % Update weights
    for e=1:nsample
        se = pe{e}/w_sum_pe;
        wght{e} = se*wght{e};
    end
    
    % Assimilated parameters
    as_ensemble = zeros(nprm,nsample); % assimilated ensemble
    for e=1:nsample
        as_ensemble(:,e) = par_ensemble{e,:}'*wght{e};
    end
    
    % Mean and standard deviation of parameters
    en_mean(:,k+1) = sum(as_ensemble,2); 
    for e=1:nsample
        en_cov(:,k+1) = en_cov(:,k+1) + wght{e}*(par_ensemble{e,:}'-en_mean(:,k+1)).^2;
    end
    en_std(:,k+1) = sqrt(en_cov(:,k+1));
    
    % Plot distribution of the weights at some chosen time steps
    
    plot2dDistribution(k+1,par_ensemble,wght,en_mean,en_cov);
    for i=1:nprm
        plotDistribution(i,k+1,nsample,par_ensemble,wght)
    end
    
end

%% Plot results
% Plot mean with std of parameters along assimilation time
for i=1:nprm
    figure; plot(1:sstep+1,en_mean(i,1:sstep+1),'-b','Linewidth',2); hold on
    plot(1:sstep+1,en_mean(i,1:sstep+1)+en_std(i,1:sstep+1),'--r','Linewidth',1); hold on
    plot(1:sstep+1,en_mean(i,1:sstep+1)-en_std(i,1:sstep+1),'--r','Linewidth',1);
    legend('mean','mean+/-std');
    title(['Assimilated parameter ',par_ensemble.Properties.VariableNames(i), 'kPa']);
    xlabel('Time step'); ylabel('Mean parameter value');
end
