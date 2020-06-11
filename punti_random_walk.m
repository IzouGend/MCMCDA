clear all
speed=0.01;
Nt=100;
Np=8;

points(:,:,Nt)=zeros(3,Np);
points=rand(3,Np)/1;

for cont=2:Nt
    %decido se fare un passo posivo, negato o fermo
    passo=randi(3, 3,Np)-2;
    
    %componente che li tira verso il centro
    points(:,:,cont-1)=points(:,:,cont-1)-points(:,:,cont-1)/10;
    
    points(:,:,cont) = points(:,:,cont-1)+passo*speed;
end
disp('end')



save('movimento_punti_random_100frames','points');
