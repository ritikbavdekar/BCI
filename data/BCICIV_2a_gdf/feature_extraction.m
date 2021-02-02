%Channels: data 1,3,11,6
%fft channels: data 1,6
%dct channels: data 1,6
function features=feature_extraction(file)
channels=[1,3,11,6];
fft_channels=[1,6];
dct_channels=[1,6];
[s,h]=sload(file);
s=fillmissing(s,"spline");
%bandpass filters
fs=h.SampleRate;
[b,a] = butter(5, [7, 30]/(fs/2));  % [5,30]/(fs/2) is lower and higher cutoff of filter
s = filter(b,a,s);   %filtered value stored
features=[];
for index=channels
    features=[features,s(:,index)];
end
fs = h.SampleRate;
for index=fft_channels
    y_fft=fft(s(:,index));
    y_fft=abs(y_fft);
    features=[features,y_fft];
end
for index=dct_channels
    y_dct=dct(s(:,index));
    features=[features,y_dct];
end
end
