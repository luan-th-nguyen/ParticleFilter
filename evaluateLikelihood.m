function p = evaluateLikelihood(k,d_obs,d_cal_e,cvrc)
% Calculate the likelihood at each time step 
% k: time t_k
% e: the e-th particle
% d_obs: observation data
% d_cal: calculation data
% cvrc: covariance matrix of observation noise

    L1 = d_obs{:,k} - d_cal_e(:,k);
    L2 = cvrc\L1;   % inv(cvrc)*L1
    p = exp(-0.5*L1'*L2);
    
end