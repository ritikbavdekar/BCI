[s,h]=sload('A04T.gdf');
component=6;
fs = h.SampleRate;
s=fillmissing(s,'spline');
y_fft=fft(s);
y_fft=y_fft(:,component);
y_fft=abs(y_fft);
Nsamps=length(y_fft);
y_fft = y_fft(1:Nsamps/2);
f = fs*(0:Nsamps/2-1)/Nsamps;

%disp(y_fft);
figure;
plot(f, y_fft); 
%title('FFT of component '); 