function [x,y] = Generate_Data_nonlinear(n,D,S)

 x = [S*randn(n/2,2); D+ S*randn(n/2,2)]';
y=[ones(n/2,1);zeros(n/2,1)]';
