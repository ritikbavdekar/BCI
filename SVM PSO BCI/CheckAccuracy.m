function train_acc=CheckAccuracy(w,x,y)
    x=[ones(size(x',1),1) x'];
    n=size(x,1);
    d=size(x,2);
    val=w*x';
    val=val(1:250);
    error= ((val<0)==y');
    train_acc=sum(error)/250
    
    