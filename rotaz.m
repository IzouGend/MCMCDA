function [ R ] = rotaz( a,b,c )
%ROTAZ Summary of this function goes here
%   Detailed explanation goes here
    rx=[1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
    ry=[cos(b) 0 sin(b); 0 1 0; -sin(b) 0 cos(b)];
    rz=[cos(c) -sin(c) 0; sin(c) cos(c) 0; 0 0 1];

    R=rz*ry*rx;
end

