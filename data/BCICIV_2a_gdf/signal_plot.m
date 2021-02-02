file='A04T.gdf';
channel=11;
[s,h]=sload(file);
M = fillmissing(s,'spline');
M=movingmean(M,1,[],1);

M=M(:,channel);
%disp(s(:,channel));
%%eegplot(s(:,channel));
plot(M);