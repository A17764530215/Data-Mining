classdef FKernel
    %KERNEL �˴���ʾ�йش����ժҪ
    % �˺���
    %   �˴���ʾ��ϸ˵��
    
    properties
        kernel; % �˺�������
        p1;     % ����1
        p2;     % ����2
        p3;     % ����3
    end
    
    methods
        function [ k ] = FKernel(params)
            k = SetParams(k, params);
        end
        function [ Y ] = K( k, U, V )
        %KERNEL �˴���ʾ�йش˺�����ժҪ
        % �˺���
        %   �˴���ʾ��ϸ˵��
        % ������
        %     name      -�˺�������
        %     U         -����U
        %     V         -����V

            switch k.kernel
                case 'linear'
                    % Linear Kernel
                    % disp('You are using a Linear Kernal')
                    Y = U*V.';
                case 'poly'
                    % Polynomial Kernel
                    % disp('You are using a Polynomial Kernal')
                    Y = (k.p1*U*V'+k.p2).^k.p3;
                case 'rbf'
                    % Gaussian Kernel
                    % disp('You are using a RBF Kernal')
                    D = XYDist(U, V);
                    Y = exp(-D.^2/(2*k.p1.^2));
                case 'sigmoid'
                    % Sigmoid Kernel
                    Y = tanh(k.p1*U*V'+k.p2);
                case 'log'
                    % Log Kernel
                    D = XYDist(U, V);
                    Y = -log(1+D.^k.p1);
                otherwise
                    disp('Please enter a Valid kernel choice ')
                    Y = [ ];
            end
        end
        function [ k ] = SetParams(k, params)
            names = fieldnames(params);
            [m, ~] = size(names);
            for i = 1 : m
                name = names{i};
                switch(name)
                    case {'kernel'}
                        k.kernel = params.kernel;
                    case {'p1'}
                        k.p1 = params.p1;
                    case {'p2'}
                        k.p2 = params.p2;
                    case {'p3'}
                        k.p3 = params.p3;
                end
            end
        end
        function [ Params ] = GetParams(k)
            % �õ���ǰ�˺����Ĳ���
            Params = struct(k);
        end
    end
    
end

