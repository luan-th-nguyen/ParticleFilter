function plot2dDistribution(k,par_ensemble,wght,en_mean,en_cov)
% Plot parameter distributions in 2D plane (valide only for 2 parameters)
% par: parameter vector
% k: time step
% nsample: number of particles
% par_ensembles: parameter ensembles
% as_ensembles: assimilated ensembles

x = par_ensemble{:,1};
y = par_ensemble{:,2};
z = cell2mat(wght)';

% plot scattered particles
figure
scatter(x,y,40,z,'filled');
colorbar;
hold on
% plot mean
xbar = en_mean(1,k);
ybar = en_mean(2,k);
plot(xbar,ybar,'*k','MarkerSize',10);
hold on
title(['Distribution of assimilated parameters at time step ',num2str(k-1)]);
xlabel('Parameter 1'); ylabel('Parameter 2');
% plot covariance ellipse
xarr = [];
yarr1 = [];
yarr2 = [];
Px = sqrt(en_cov(1,k));
Py = sqrt(en_cov(2,k));
ellipse(Px,Py,0,xbar,ybar,'k');
% for xi = xbar-Px : Px / 100 : xbar+Px
%     xarr = [xarr xi];
%     yi = ybar + Py * sqrt(abs(1 - ((xi - xbar) / Px)^2));
%     yarr1 = [yarr1 yi];
%     yi = ybar - Py * sqrt(abs(1 - ((xi - xbar) / Px)^2));
%     yarr2 = [yarr2 yi];
% end
% plot(xarr, yarr1, 'r'); hold on
% plot(xarr, yarr2, 'r');

end