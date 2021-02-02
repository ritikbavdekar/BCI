[s,h]=sload('A04E.gdf');
fs = h.SampleRate;
s=fillmissing(s,'previous');
eegchan=find(h.CHANTYP=='E');
s=s(:,eegchan);
y_dct=dct(s);
%y_dct=mean(y_dct,2)
figure
plot(y_dct(:,6)); 
title('DCT of 6th component'); 



%[XX,ind] = sort(abs(y_dct),'descend');
%i = 1;
%while norm(y_dct(ind(1:i)))/norm(y_dct) < 0.5
%   disp(i);
%   i = i + 1;
%end
%needed = i;
