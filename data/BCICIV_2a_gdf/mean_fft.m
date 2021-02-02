[s,h]=sload('A04E.gdf');
fs = h.SampleRate;
s=fillmissing(s,'spline');
y_fft=fft(s);
y_fft=abs(y_fft);
y_fft=mean(y_fft,2);
Nsamps=length(y_fft);
y_fft = y_fft(1:Nsamps/2);
f = fs*(0:Nsamps/2-1)/Nsamps;

figure
plot(f, y_fft(:,1)); 
title('Mean FFT of all components'); 



