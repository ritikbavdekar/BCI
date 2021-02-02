clear all
close all
config = set_config;
addpath('C:\Users\ritz\Desktop\BCI\biosig4octmat-3.7.2\biosig\t250_ArtifactPreProcessingQualityControl'); % to use trigg function
addpath('C:\Users\ritz\Desktop\BCI\biosig4octmat-3.7.2\biosig\t200_FileAccess');  

for sub_id = 1:config.sub_num
    [epochs, labels] = load_data(config, sub_id);
    c_ind{1} = find(labels==1); % class 1
    c_step_size(1,1) = ceil(size(c_ind{1},1)/config.cv_num);
    
    c_ind{2} = find(labels==2); % class 2
    c_step_size(1,2) = ceil(size(c_ind{2},1)/config.cv_num);
    
    for pos_ind = 1:config.position_num
        % storage of feature vectors
        f_tr = cell(config.cv_num,config.iter_num,config.method_num);
        f_te = cell(config.cv_num,config.iter_num,config.method_num);
        %extract single-channel epochs
        target_epo = squeeze(epochs(pos_ind,:,:));
        
        % iterations for reducing the effect of random selection
        for iter_ind = 1:config.iter_num
            % all positions must use the same testing and training data
            if pos_ind == 1
               vc_ind{1} = c_ind{1}(randperm(size(c_ind{1},1)));
               vc_ind{2} = c_ind{2}(randperm(size(c_ind{2},1)));
            end
            
            % extract features for 10 10-fold CV
            for cv_ind = 1:config.cv_num
                dammy_vc_ind = vc_ind;
                
                if cv_ind == config.cv_num
                    testing_c{1} = target_epo(:,vc_ind{1}(1+c_step_size(1)*(cv_ind-1):end));
                    testing_c{2} = target_epo(:,vc_ind{2}(1+c_step_size(2)*(cv_ind-1):end));
                    testing = [testing_c{1}, testing_c{2}];
                    dammy_vc_ind{1}(1+c_step_size(1)*(cv_ind-1):end,:) = [];
                    dammy_vc_ind{2}(1+c_step_size(2)*(cv_ind-1):end,:) = [];
                else
                    testing_c{1} = target_epo(:,vc_ind{1}(1+c_step_size(1)*(cv_ind-1):c_step_size(1)+c_step_size(1)*(cv_ind-1)));
                    testing_c{2} = target_epo(:,vc_ind{2}(1+c_step_size(2)*(cv_ind-1):c_step_size(2)+c_step_size(2)*(cv_ind-1)));                    
                    testing = [testing_c{1}, testing_c{2}];
                    dammy_vc_ind{1}(1+c_step_size(1)*(cv_ind-1):c_step_size(1)+c_step_size(1)*(cv_ind-1),:) = [];
                    dammy_vc_ind{2}(1+c_step_size(2)*(cv_ind-1):c_step_size(2)+c_step_size(2)*(cv_ind-1),:) = [];
                end
                
                training_c{1} = target_epo(:,dammy_vc_ind{1});
                training_c{2} = target_epo(:,dammy_vc_ind{2});
                
                % check data size for single-channel CSP
                if size(training_c{1},2) ~= size(training_c{2},2)
                    training_c{1} = training_c{1}(:,1:min(size(training_c{1},2),size(training_c{2},2)));
                    training_c{2} = training_c{2}(:,1:min(size(training_c{1},2),size(training_c{2},2)));
                end
                
                % zero-padding STFT %
                pow_tr_c{1} = zeros(config.bin_num,config.win_num,size(training_c{1},2));
                pow_tr_c{2} = zeros(config.bin_num,config.win_num,size(training_c{2},2));
                pow_te = zeros(config.bin_num,config.win_num,size(testing,2));
                
                % extract 100 sample points from target_epo
                for data_ind = 1:size(training_c{1},2)
                    [~,~,~,ps1] = spectrogram(training_c{1}(:,data_ind),config.window_size,config.overlap,config.nfft,config.Fs);
                    pow_tr_c{1}(:,:,data_ind) = ps1(2:21,:);
                    [~,~,~,ps2] = spectrogram(training_c{2}(:,data_ind),config.window_size,config.overlap,config.nfft,config.Fs);
                    pow_tr_c{2}(:,:,data_ind) = ps2(2:21,:);                    
                end
                
                for data_ind = 1:size(testing,2)
                    [~,~,~,ps] = spectrogram(testing(:,data_ind),config.window_size,config.overlap,config.nfft,config.Fs);
                    pow_te(:,:,data_ind) = ps(2:21,:);
                end
                
                % feature extraction %
                % 1. power spectra with log scale (PS)
                % 2. single-channel SCP (SCCSP)
                % 3. GLCM
                
                class_training = [ones(size(training_c{1},2),1); ones(size(training_c{2},2),1)+1];
                class_testing = [ones(size(testing_c{1},2),1); ones(size(testing_c{2},2),1)+1];
                pow_tr = cat(3,pow_tr_c{1},pow_tr_c{2});
                
                for method_ind = 1:config.method_num
                    switch  method_ind
                        case 1
                            f_train = log10(squeeze(var(pow_tr,[],2))./sum(squeeze(var(pow_tr,[],2))));
                            f_test = log10(squeeze(var(pow_te,[],2))./sum(squeeze(var(pow_te,[],2))));                
                            
                        case 2
                            [f_train, f_test] = sccsp(pow_tr,pow_te,config,pow_tr_c,training_c);
                            
                        case 3
                            [f_train, f_test] = glcm(pow_tr,pow_te,config);

                    end
                    % standardization %
                    m_tr = mean(f_train,2);
                    s_tr = std(f_train,[],2);
                         
                    f_tr{cv_ind,iter_ind,method_ind} = (f_train - repmat(m_tr,1,size(f_train,2))) ./ repmat(s_tr,1,size(f_train,2));
                    f_te{cv_ind,iter_ind,method_ind} = (f_test - repmat(m_tr,1,size(f_test,2))) ./ repmat(s_tr,1,size(f_test,2));               
                end
            end
        end
        
        % save f_tr and f_te
        cd(config.data_dir);
        eval(sprintf('filename=[''feature_s%dch%d''];',sub_id,pos_ind));
        save(filename,'f_tr','f_te','class_training','class_testing')
    end
end
