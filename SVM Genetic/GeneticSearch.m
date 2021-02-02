function w = GeneticSearch(x,y)
    n=size(x,2);
    d=size(x,1);
    x_ones=[ones(size(x',1),1) x'];
    y_temp=-y';
    for r=1:n
    x_ones(r,:)= y_temp(r).*x_ones(r,:);
    end
    func=@(w) error_function(x,y,w);
    B=ones(n,1);
    [w,error_val]=ga(func,d+1,x_ones,B);
    %[w,error_val]=ga(@min_function,d+1,x_ones,B);
    disp(w);
    disp(error_val);
    
    