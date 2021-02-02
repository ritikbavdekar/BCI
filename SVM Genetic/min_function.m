function TC = min_function(w)
    TC=0;
    for r=1:size(w,2)    %% 2 as first w is bias
        TC=TC+(w(:,r)*w(:,r));
    end
    TC=sqrt(TC);
    
        