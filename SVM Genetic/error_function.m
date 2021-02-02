function TC = error_function(x,y,w)
    n=size(x,2);
    d=size(x,1);
    x_ones=[ones(size(x',1),1) x'];
    y_check=y';
    h=x_ones*w';
    error= ((h>=0)==y_check);
    TC=sum(error);
    