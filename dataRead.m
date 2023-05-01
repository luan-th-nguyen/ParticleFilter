function data = dataRead(filename,sstep,obs_number)
% Read data from file
% sstep: time step (data length)
% obs_number: number of observation
% data(obs_number,sstep)

fid = fopen(filename,'r');
data = zeros(obs_number,sstep);   
for k=1:sstep 
       tline = sscanf(fgetl(fid),'%f');
       for i=1:obs_number
           data(i,k) = tline(i); 
       end
end
fclose(fid);

end