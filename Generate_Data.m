function [x,y] = Generate_Data(n,D,S)

x=[D+S*randn(n/2,2);
   -D + S*randn(n/2,2)]';
y=[ones(n/2,1);-ones(n/2,1)]';


