function [ Dst ] = ReCreateMTL( Src, Name )
%RECREATEMTL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    [ Dst ] = CreateMTL( Name, Src.X, Src.Y, Src.Labels, Src.Kfold );
end