function postprocessing_svm_rbf(config)

for sub_id = 1:config.sub_num
    temp.train_acc = cell(config.cv_num,config.iter_num,config.method_num);
    temp.test_acc = cell(config.cv_num,config.iter_num,config.method_num);
    temp.classification_train = cell(config.cv_num,config.iter_num,config.method_num);
    temp.classification_test = cell(config.cv_num,config.iter_num,config.method_num);
    svm_rbf.train_acc = cell(config.cv_num,config.iter_num,config.method_num);
    svm_rbf.test_acc = cell(config.cv_num,config.iter_num,config.method_num);
    svm_rbf.classification_train = cell(config.cv_num,config.iter_num,config.method_num);
    svm_rbf.classification_test = cell(config.cv_num,config.iter_num,config.method_num);
    
    for pos_ind = 1:config.position_num
        %%%%%%%%%%%%%
        % load data %
        %%%%%%%%%%%%%
        cd(config.data_dir);
        eval(sprintf('filename=[''feature_s%dch%d'']',sub_id,pos_ind));
        load(filename);
        
        class_testing_last = class_testing;
        class_training_last = class_training;
            
        for log2c = 0:2:16
            for log2g = -16:2:-2
                for method_ind = 1:config.method_num
                    for iter_ind = 1:config.iter_num
                        for cv_ind = 1:config.cv_num
                            f_test = f_te{cv_ind,iter_ind,method_ind};
                            f_train = f_tr{cv_ind,iter_ind,method_ind};
                       
                            f_test(isnan(f_test)) = 0;
                            f_train(isnan(f_train)) = 0;
                            
                            if cv_ind == config.cv_num
                                class_training = class_training_last;
                                class_testing = class_testing_last;
                            else
                                if sub_id == 9
                                    class_training =  class_training_last(3:end-2,:);
                                    class_testing = [ones(12,1);ones(13,1)+1];
                                elseif sub_id == 6
                                    class_training =  class_training_last(2:end-1,:);
                                    class_testing = [ones(11,1);ones(12,1)+1];          
                                else
                                    class_training = [ones(size(f_train,2)/2,1);ones(size(f_train,2)/2,1)+1];
                                    class_testing = [ones(size(f_test,2)/2,1);ones(size(f_test,2)/2,1)+1];
                                end
                            end
                       
                            cd(config.code_dir);
                            [temp.train_acc{cv_ind,iter_ind,method_ind},temp.test_acc{cv_ind,iter_ind,method_ind},temp.classification_train{cv_ind,iter_ind,method_ind},temp.classification_test{cv_ind,iter_ind,method_ind}]...
                                = LibsvmRbf(f_train',f_test',class_training,class_testing,log2c,log2g,config);
                            cd(config.code_dir);
                        end    
                    end
                end
                
                test_acc = cell2mat(temp.test_acc);
                test_acc = reshape(test_acc,[config.cv_num*config.iter_num, config.method_num]);
                ave_acc = mean(test_acc,1);
            
                if log2c == 0 && log2g == -16
                    svm_rbf.train_acc = temp.train_acc;
                    svm_rbf.test_acc = temp.test_acc;
                    svm_rbf.classification_train = temp.classification_train;
                    svm_rbf.classification_test = temp.classification_test;
                    svm_rbf.parameter = [[log2c; log2g], [log2c; log2g], [log2c; log2g]];
                    best_test_acc = ave_acc;
                end
                
                for method_ind = 1:config.method_num
                    if best_test_acc(:,method_ind) < ave_acc(:,method_ind)
                        svm_rbf.train_acc(:,:,method_ind) = temp.train_acc(:,:,method_ind);
                        svm_rbf.test_acc(:,:,method_ind) = temp.test_acc(:,:,method_ind);
                        svm_rbf.classification_train(:,:,method_ind) = temp.classification_train(:,:,method_ind);
                        svm_rbf.classification_test(:,:,method_ind) = temp.classification_test(:,:,method_ind);
        
                        svm_rbf.parameter(:,method_ind) = [log2c; log2g];
                        best_test_acc(:,method_ind) = ave_acc(:,method_ind);
                        disp('updated !')
                    end
                end
                disp(['log2c =',num2str(log2c),', log2g =',num2str(log2g)])
            end
        end
        
        cd(config.save_dir);
        eval(sprintf('filename=[''svm_rbf_s%dch%d'',''.mat''];',sub_id,pos_ind));
        save(filename,'svm_rbf');    
    end
end

cd(config.code_dir);