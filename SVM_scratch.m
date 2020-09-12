%%mathematics reference on 
%%https://in.mathworks.com/help/stats/support-vector-machines-for-binary-classification.html
%%http://www.engr.mun.ca/~baxter/Publications/LagrangeForSVMs.pdf
function SVM_scratch(n,D,S,C)  %% C is SVM parameter,n is number of data points,D refers to points (D,D) and (-D,-D) and S standard deviation of data along (D,D) and (-D,-D)
[x,y]=Generate_Data(n,D,S);
ClassA=find(y==1);
ClassB=find(y==-1);

H=zeros(n,n);
for i=1:n
    for j=i:n
        H(i,j)=y(i)*y(j)*x(:,i)'*x(:,j);  %% defining kernel
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

Decision_boundary_plot(ClassA,ClassB,S,x,w,b);






