function plotW(W,Y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x=zeros(1,1);
y=zeros(1,1);
z=zeros(1,1);
for t=1:W.frame-1
   for k=1:W.tracks
      if tauexist(W,t,k)
      	kcolor = [0.7 0.5 0.2];
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

         x(1,k,t)=Y(t).data(W.track(t).tau(k).y,1);
         y(2,k,t)=Y(t).data(W.track(t).tau(k).y,2);
         z(3,k,t)=Y(t).data(W.track(t).tau(k).y,3);
        plot3(x(1,k,t),y(2,k,t),z(3,k,t),'+','color',kcolor);
        hold on;
	 	axis equal; 
	 	hold on;
% 	 	pause(0.001);
	 	hold on;
      end
   end
end
grid on;


end

