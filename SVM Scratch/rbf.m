function val=rbf(a,b,gamma)
val=exp(-gamma*sum((a-b).^2));
