clear;
clc;

%% 创建多维数据集:

% 顶点   a b c d e f g h
p3d =    [ 0 1 1 0 0 1 1 0 ;   % x 
           0 0 0 0 1 1 1 1 ;   % y
           0 0 1 1 1 1 0 0 ];  % z
% p3d = p3d*500;     
       
% 设置所有可见点       
%hidden = zeros(1,8);
connmatrix = [ 'r'  0   0   0   0   0   0   0  ;
               'g' 'k'  0   0   0   0   0   0  ;
                0  'b' 'b'  0   0   0   0   0  ;
               'r'  0  'b' 'g'  0   0   0   0  ;
                0   0   0  'b' 'b'  0   0   0  ;
                0   0  'b'  0  'b' 'b'  0   0  ;
                0  'b'  0   0   0  'b' 'b'  0  ;
               'c'  0   0   0  'b'  0  'b' 'm' ];
kx=1;
ky=1;

K=[ kx  0   0 ;
    0   ky  0 ;
    0   0   1 ];
f=1;


plot3(p3d(1,:),p3d(2,:),p3d(3,:),'+');
axis([-2 3 -2 3 -2 3]);

passoz=0.01;
passox=0.02;
degz=pi*2/100;

points=p3d;

for z=1:100
    
    R = rotaz(0,0,z*degz);
    T = [z*passox, 0, z*passoz]';

    pt_trasl=[R,T;[0,0,0,1]] * [p3d; ones(1,8)];
    
%     pt_trasl=rotaz(0,0,z*degz)*pt_trasl;
%     pt_trasl(3,:)=p3d(3,:)+z*passoz;
%     pt_trasl(1,:)=p3d(1,:)+z*passox;
   
 
    points(:,:,z)=pt_trasl(1:3,:);
    
%     plot3(pt_trasl(1,:),pt_trasl(2,:),pt_trasl(3,:),'+');
%     axis([-2 3 -2 3 -2 3]);   
%     pause(0.03)
end
save('movimento_punti_3D_100frames','points');

% [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 5]', p3d, K, f);

% ccdplot(P2D, hidden, connmatrix) 
% axis([-0.1 0.1 -0.1 0.1]);

% pause;
% for z=0:0.1:3
%     pt_trasl=p3d;
%     pt_trasl(3,:)=p3d(3,:)+z;
%     
%     [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 10]', pt_trasl, eye(3));
%     ccdplot(P2D, hidden, connmatrix) 
%     axis([-0.1 0.1 -0.1 0.1]);
%     pause;
% end
% 
% 
% for z=0:0.1:10
%     pt_trasl=p3d;
%     pt_trasl(3,:)=p3d(3,:)-z;
%     
%     [P2D, hidden] = camera_simulation(eye(3), [-0.5 -0.5 10]', pt_trasl, eye(3));
%     ccdplot(P2D, hidden, connmatrix) 
%     axis([-0.1 0.1 -0.1 0.1]);
%     pause;
% end