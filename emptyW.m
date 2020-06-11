function [ flag ] = emptyW( W, cont, i ,H)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    if (isempty(W.track(cont).((strcat('tau',num2str(i)))))) ...
                    || (~isfield(W_init.track(H-t1),strcat('tau',num2str(k))))
                flag = 1;
    else
        flag=0;
    end
end

