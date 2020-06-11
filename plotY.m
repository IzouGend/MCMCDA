function plotY(Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global nt
global Hfinal

x=zeros(1,1);
y=zeros(1,1);
z=zeros(1,1);
for t=1:Hfinal
   for k=1:nt(t)
       switch k
			case 1
				kcolor = [0 0 1];
			case 2
				kcolor = [1 0 0];
			case 3
				kcolor = [0 1 0];
			case 4
				kcolor = [0 1 1];
			case 5
				kcolor = [1 0 1];
			case 6
				kcolor = [1 0.5 0];
			case 7
				kcolor = [0 0.5 0.5];
			case 8
				kcolor = [0 0 0];
		  end
         x(1,k,t)=Y(t).data(k,1);
         y(2,k,t)=Y(t).data(k,2);
         z(3,k,t)=Y(t).data(k,3);
        plot3(x(1,k,t),y(2,k,t),z(3,k,t),'x','color',kcolor);
        hold on;
	 	axis equal; 
	 	hold on;
	 	pause(0.000001);
	 	hold on;
   end
end
grid on;


end

