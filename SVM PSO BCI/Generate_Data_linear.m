function [x,y] = Generate_Data_linear(n,D,S)

x=[D+S*randn(n/2,2);
   -D + S*randn(n/2,2)]';
y=[ones(n/2,1);zeros(n/2,1)]';


