function [  ] = SCATTER( X )
%SCATTER �˴���ʾ�йش˺�����ժҪ
% ����ɢ��ͼ
%   �˴���ʾ��ϸ˵��
    Xn = X(X(:,3)==0,:);
    scatter(Xn(:,1),Xn(:,2),12,'or');
    hold on;
    Xp = X(X(:,3)==1,:);
    scatter(Xp(:,1),Xp(:,2),12,'og');
end

