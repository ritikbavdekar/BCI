config=set_config;
config.sub_num=1;
config.position_num=7;
classifier_ind = 6;
    lib_acc = zeros(3,900);
    for sub_id = 1:config.sub_num
        for pos_ind = 1:config.position_num
            eval(sprintf('filename=[''svm_rbf_s%dch%d'',''.mat''];',sub_id,pos_ind));
            load(filename);
            acc = cell2mat(svm_rbf.test_acc); 
            acc = reshape(acc,[config.cv_num*config.iter_num,config.method_num]);
            ave_acc = mean(acc,1);
            
            if pos_ind == 1
                best_acc = ave_acc;
                lib_acc(:,1+100*(sub_id-1):100+100*(sub_id-1)) = acc';
            end
            
            for method_ind = 1:3
                if best_acc(1,method_ind) < ave_acc(1,method_ind)
                    best_acc(1,method_ind) = ave_acc(1,method_ind);
                    lib_acc(method_ind,1+100*(sub_id-1):100+100*(sub_id-1)) = acc(:,method_ind)';
                end 
            end
        end
    end
all_acc(:,:,classifier_ind) = lib_acc;