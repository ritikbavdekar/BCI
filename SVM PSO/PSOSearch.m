function [w,error]=PSOSearch(agents,generations,x,y)

    x=[ones(size(x',1),1) x'];
    y=y';
    n=size(x,1);
    d=size(x,2);
    lb=-10;
    ub=+10;
    c1=0.5;
    c2=0.5;
    [agent_vector_pos,pbest_val,gbest_val,pbest_cost,gbest_cost,velocity]=pop_initialise(agents,n,d,lb,ub,x,y);
    disp(pbest_cost(100,:));
    for genNo=1:generations
        new_velocity=zeros(agents,d);
        for agentNo=1:agents
            new_velocity(agentNo,:)=velocity(agentNo,:)+ c1*(pbest_val(agentNo,:)-agent_vector_pos(agentNo,:)) +c2*(gbest_val-agent_vector_pos(agentNo,:));
            agent_vector_pos(agentNo,:)=agent_vector_pos(agentNo,:)+new_velocity(agentNo,:);
            w_temp=agent_vector_pos(agentNo,:);
            cost=cost_function(x,y,w_temp);
            if cost<pbest_cost(agentNo,:)
                pbest_val(agentNo,:)=agent_vector_pos(agentNo,:);
                pbest_cost(agentNo,:)=cost;
            end
            if cost<gbest_cost
                gbest_cost=cost;
                gbest_val=pbest_val(agentNo,:);
            end
        end
        velocity=new_velocity;
    end
    w=gbest_val;
    error=gbest_cost;
    
            
            
            
        
    
    