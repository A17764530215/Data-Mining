function [  ] = FastTemplate( fw, template, variables )
%FASTTEMPLATE �˴���ʾ�йش˺�����ժҪ
% ����ģ������
%   �˴���ʾ��ϸ˵��

    % д���ļ�
    fout = fopen(fw, 'a');
    % ����ģ��
    [~,~,~,d1,e1,~,~] = regexp(template, '\$(\d+)');
    if ~isempty(e1)
        [m, ~] = size(d1);
        for i = 1 : m
            [~, n] = size(e1{i});
            for j = 1 : n
                index = str2double(char(e1{i}{j}));
                old_ = d1{i}{j}; new_ = variables{index};
                template = replace(template, old_, new_);
                fprintf('replace :%s->%s\n', old_, new_);
            end
        end
    end
    [m, ~] = size(template);
    for i = 1 : m
        fprintf(fout, '%s\r\n', template{i});
    end
    fclose(fout);
end