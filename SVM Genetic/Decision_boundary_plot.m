function Decision_boundary_plot(ClassA,ClassB,x,w,b)
Line = @(x1,x2) w(1)*x1+w(2)*x2+b;
LineA = @(x1,x2) w(1)*x1+w(2)*x2+b+1;
LineB = @(x1,x2) w(1)*x1+w(2)*x2+b-1;
figure;
plot(x(1,ClassA),x(2,ClassA),'ro');
hold on;
plot(x(1,ClassB),x(2,ClassB),'bs');
x1min = min(x(1,:));
x1max = max(x(1,:));
x2min = min(x(2,:));
x2max = max(x(2,:));
handle = ezplot(Line,[x1min x1max x2min x2max]);
set(handle,'Color','k','LineWidth',2);
handleA = ezplot(LineA,[x1min x1max x2min x2max]);
set(handleA,'Color','k','LineWidth',1,'LineStyle',':');
handleB = ezplot(LineB,[x1min x1max x2min x2max]);
set(handleB,'Color','k','LineWidth',1,'LineStyle',':');
legend('Class A','Class B');