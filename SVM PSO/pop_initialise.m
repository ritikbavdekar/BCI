function [agent_vector_pos,pbest_val,gbest_val,pbest_cost,gbest_cost,velocity]= pop_initialise(agents,n,d,lb,ub,x,y)
    agent_vector_pos=lb+(ub-lb).*rand(agents,d);
    velocity=rand(agents,d);
    pbest_val=agent_vector_pos;
    pbest_cost=ones(n,1);
    gbest_cost=-1;
    for r=1:n
        pbest_cost(r)=cost_function(x,y,agent_vector_pos(r,:));
        if gbest_cost==-1
            gbest_cost=pbest_cost(r);
            gbest_val=agent_vector_pos(r,:);
        else
            if pbest_cost(r)<gbest_cost
                gbest_cost=pbest_cost(r);
                gbest_val=agent_vector_pos(r,:);
            end
        end
    end