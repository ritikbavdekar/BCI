function SVM_scratch(n,D,S,C,k)  %% C is SVM parameter,n is number of data points,D refers to points (D,D) and (-D,-D) and S standard deviation of data along (D,D) and (-D,-D)
[x,y]=Generate_Data_linear(n,D,S);
%disp(size(x,2));
ClassA=find(y==1);
ClassB=find(y==-1);
w=GeneticSearch(x,y);
b=w(:,1);
w=w(:,2:size(w,2));
Decision_boundary_plot(ClassA,ClassB,x,w,b);
