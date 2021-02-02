%%mathematics reference on 
%%https://in.mathworks.com/help/stats/support-vector-machines-for-binary-classification.html
%%http://www.engr.mun.ca/~baxter/Publications/LagrangeForSVMs.pdf
function SVM_scratch(n,D,S,C,k)  %% C is SVM parameter,n is number of data points,D refers to points (D,D) and (-D,-D) and S standard deviation of data along (D,D) and (-D,-D)
[x,y]=Generate_Data_linear(n,D,S);
ClassA=find(y==1);
ClassB=find(y==-1);
%disp(x(:,1));
H=zeros(n,n);
for i=1:n
    for j=i:n
        if k=="linear"
            H(i,j)=y(i)*y(j)*x(:,i)'*x(:,j);  %%linear kernel
        elseif k=="rbf"
            H(i,j)=y(i)*y(j)*(rbf(x(:,i),x(:,j),1.0));
        elseif k=="poly"
            H(i,j)=y(i)*y(j)*(poly_kernel(x(:,i),x(:,j),2,2));
        else
            H(i,j)=y(i)*y(j)*x(:,i)'*x(:,j); %%define custom kernel and implement.Presently linear kept
        end
        
        %H(i,j)=y(i)*y(j)*x(:,i)'*x(:,j);
        H(j,i)=H(i,j);
    end
end 
f=-ones(n,1);  %to accomodate sum(-alphaj)
Aeq=y;  %Sum(yj*lambdaj)=0 (equality constraint)
beq=0;    
lb=zeros(n,1); %lower bound of lagrange multiplier. HElps with 
ub=C*ones(n,1); %upper bound of lagrange multipliers as  0<=alphaj<=C
%%NOTE:We need to find maxm of value of SVM Objective function but quadprog
%%finds minimum. So we find minm of -f(x) instead of max f(x)

min_sol=quadprog(H,f,[],[],Aeq,beq,lb,ub,[])'; %% Contains all lambdaj values
AlmostZero=(abs(min_sol)<max(abs(min_sol))/1e5); %% Remove all lamdas that are 0
min_sol(AlmostZero)=0;
S=find(min_sol>0 & min_sol<C);  %%ALL lambdas greater than zero contribute towards w.
w=0;
for i=S
    w=w+min_sol(i)*y(i)*x(:,i);  %% Calculating W of W.X + b (only summing over non zero lambdas as others give 0 value)
end
b=mean(y(S)-w'*x(:,S)); %% Calculating b using only S as remaining have lambda =0 so don't contribute towards b
%%Predict
if k=="linear"
    Decision_boundary_plot(ClassA,ClassB,S,x,w,b);
    %%%print sign(w.x+b)
elseif k=="rbf"
    y_pred=zeros(n,1);
    for i=1:n
        value=0;
        for j=S
            value=value + (min_sol(j) *rbf(x(:,i),x(:,j),1.0)); 
        end
        y_pred(i)= (value)<=1;
    end
elseif k=="poly"
    for i=1:n
        value=0;
        for j=S
            value=value + (min_sol(j)*(poly_kernel(x(:,i),x(:,j),2,2)));
        end
        y_pred(i)= (value);
    end
else
end

disp(y_pred)
        
            
    










