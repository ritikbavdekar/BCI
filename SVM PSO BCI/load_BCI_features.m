function [x_train,y_train,x_test,y_test]= load_BCI_features()
    y_train=load("feature_s1ch1.mat","class_training");
    y_train=cell2mat(struct2cell(y_train));
    y_train=y_train(1:250);
    y_test=load("feature_s1ch1.mat","class_testing");
    y_test=cell2mat(struct2cell(y_test));
    ind= y_train==2;
    for it=ind
        y_train(it)=0;
    end
    ind=y_test==2;
    for it=ind
        y_test(it)=0;
    end 
    f_tr=load("feature_s1ch1.mat","f_tr");
    f_te=load("feature_s1ch1.mat","f_te");
    x_train=[];
    x_test=[];
    f_tr=struct2cell(f_tr);
    f_tr=[f_tr{:}];
    f_te=struct2cell(f_te);
    f_te=[f_te{:}];
    x_train=[];
    x_test=[];
    for ind=1:5
        val=f_tr{ind};
        val=val(:,1:250);
        x_train=[x_train;val];
        
    end
    for ind=150:154
        val=f_tr{ind};
        val=val(:,1:250);
        x_train=[x_train;val];
    end
    for ind=250:254
        val=f_tr{ind};
        val=val(:,1:250);
        x_train=[x_train;val];
    end
        
    
            
    