function [ Dst ] = ReCreateMTL( Src, Name )
%RECREATEMTL 此处显示有关此函数的摘要
%   此处显示详细说明
    [ Dst ] = CreateMTL( Name, Src.X, Src.Y, Src.Labels, Src.Kfold );
end