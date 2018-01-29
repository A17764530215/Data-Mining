function [ D ] = DataSets( name, n )
%DATASETS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    switch(name)
        case {'Sine'}
            % �������ݼ�
            D = Sine(n);
        case {'Grid'}
            % �������ݼ�
            D = Grid(n, 2, 2, 1);
        case {'Ring'}
            % ��״���ݼ�
            D = Ring(n, 2, 2);
        otherwise
            % Ĭ�ϻ�״���ݼ�
            D = Ring(n, 2, 2);
    end
end

