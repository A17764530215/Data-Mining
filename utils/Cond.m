function [ A ] = Cond( H )
%COND �˴���ʾ�йش˺�����ժҪ
% �����˾���
%   �˴���ʾ��ϸ˵��
% ������
%     H     -�˾���
%     A     -���������

    A = H + 1e-5*speye(size(H));
end