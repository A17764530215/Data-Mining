fw = './templates/figures.txt';

old = '';
subsection = 0;
list = dir('./eps/');
m = length(list);
for i = 1 : m
    item = list(i);
    if item.isdir == 0
        name = item.name;
        idx = regexp(name, '.eps');
        if idx > 0
            % fig
            var1 = name;
            % ��ȡ���ݼ����ƺ�ָ����
            name = replace(name, '.eps', '');
            names = split(name, '-');
            name1 = names{1};
            % caption
            name2 = replace(names{2}, '_', '/');
            var2 = [name2, ' of ' name1];
            % label
            name2 = names{2};
            var3 = [name2, '_', name1];
            % �µ��½�
            if strcmp(old, name1) == 0
                % ��ҳ
                if subsection > 1
                    FastTemplate( fw, pagebreak, {} );
                end
                % ����
                subsection = subsection + 1;
                FastTemplate( fw, paragraph, {name1} );
            end
            % ͼ��
            FastTemplate( fw, figure, {var1, var2, var3} );
            old = name1;
        end
    end
end