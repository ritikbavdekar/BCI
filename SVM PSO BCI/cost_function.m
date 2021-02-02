function cost = cost_function(x,y,w)
    tolerance=0.000000001;
    n=size(x,2);
    d=size(x,1);
    h=w*x';
    error= ((h>=0)==y');
    cost=sum(error);
    h=abs(h);
    if(cost==0)
        %cost=-1/(sum(w.*w)+tolerance)
        for it=1:n
            min_dist_A=-1;
            min_dist_B=-1;
            if y(it,:)==1
                if min_dist_A==-1
                    min_dist_A=h(:,it);
                else
                    min_dist_A=min(min_dist_A,h(:,it));
                end
            else
                if min_dist_B==-1
                    min_dist_B=h(:,it);
                else
                    min_dist_B=min(min_dist_B,h(:,it));
                end
            end
        end
        cost=-(min_dist_A+min_dist_B);
    end
    cost=sum(cost);
    