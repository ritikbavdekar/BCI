function struct = set_config

% change your directory
main_dir = 'C:\Users\ritz\Desktop\BCI\data\'; % where code and data is avaialble
struct.code_dir = [main_dir, 'BCICIV_2a_gdf']; %% All directories are same right now. Need to change 
struct.data_dir = [main_dir, 'BCICIV_2a_gdf'];
struct.save_dir = [main_dir, 'BCICIV_2a_gdf'];
struct.svm_toolbox = 'C:\Users\ritz\Desktop\BCI\libsvm-3.24\matlab';

% general
struct.Fs = 250;            %Sampling frequency mentioned in dataset
struct.session_num = 2;   % A0_T.gdf A0_E.gdf   
struct.sub_num = 5;       % specifies number of datasets. In BBCI dataset 2a -9 
struct.position_num = 22; % 22 channels
struct.cv_num = 10;       % 10-fold CV
struct.iter_num = 10;     % 10 iterations
struct.method_num = 3;    % PS, GLCM, SCCEP

% filter
fh = 40; % Butterworth filter
fl = 4;
order = 4;
struct.d = designfilt('bandpassiir',...
                      'FilterOrder',order,...
                      'HalfPowerFrequency1',fl,...
                      'HalfPowerFrequency2',fh,...
                      'DesignMethod','butter',...
                      'SampleRate',struct.Fs);

% epoching
struct.pre_time = 2.5;
struct.post_time = 4.5;
                  
% feature extraction
struct.win_num = 9;
struct.window_size = 100;
struct.nfft = 128;
struct.overlap = 50;
struct.bin_num = 20;
struct.L = 7;
struct.offsets = [0 1; -1 1; -1 0; -1 -1]; % offsets for GLCM