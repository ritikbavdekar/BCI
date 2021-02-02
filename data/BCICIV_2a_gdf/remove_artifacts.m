filename='A01E.gdf';
[s,h] =sload(filename);
s(isnan(s)) = 0;


%high-lowpass filtering

fs=h.SampleRate;
[b,a] = butter(5, [7, 30]/(fs/2));  % [5,30]/(fs/2) is lower and higher cutoff of filter
s_filtered = filter(b,a,s);   %filtered value stored
reduce_artifacts


eegchan=find(h.CHANTYP=='E');
%s=s(:,eegchan);

%eogchan=identify_eog_channels(h);
eogchan=[23,24,25];
R = regress_eog(s,eegchan,eogchan);
%s = s*R.r0;
%hdr=get_regress_eog(filename);



