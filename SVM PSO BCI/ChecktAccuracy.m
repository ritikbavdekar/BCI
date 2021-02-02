function test_acc=ChecktAccuracy(w,x,y)
    x=[ones(size(x',1),1) x'];
    n=size(x,1);
    d=size(x,2);
    val=w(1)*x;
    error= ((val<0)==y');
    test_acc=call(error);
    
    