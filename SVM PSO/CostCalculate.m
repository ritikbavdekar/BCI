function cost=CostCalculate(w,x,y,n)
    cost_vector=(w*x')';
    for r=1:n
    cost_vector(r,:)= y(r).*cost_vector(r,:);
    end
    cost_vector=cost_vector-1;
    cost_vector=abs(cost_vector);
    cost=0;
    for r=1:n
    if cost_vector(r,:)<1
        cost=cost+1-cost_vector(r,:);
    end
    end
    
    
    