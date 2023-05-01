function plotDistribution(par,k,nsample,par_ensemble,wght)
% Plot parameter distributions
% par: parameter vector
% k: time step
% nsample: number of particles
% par_ensembles: parameter ensembles
% as_ensembles: assimilated ensembles

figure;
for e=1:nsample
    %plot(par_ensemble(par,e),as_ensembles(par,e),'o','MarkerSize',5); hold on;
    plot(par_ensemble{e,par},wght{e},'o','MarkerSize',5); hold on;
end
title(['Distribution of assimilated parameter at time step ',num2str(k-1)]);
%xlabel(['Parameter ',num2str(par)]); ylabel('Weight');
xlabel([par_ensemble.Properties.VariableNames(par), ' kPa']); ylabel('Weight');

end