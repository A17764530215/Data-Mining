classdef Log
    %LOG �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        file; % �ļ���
        fd; % �ļ�������
    end
    
    methods
        function [ log ] = Log(file)
            log.file = file;
        end
        
        function [ log ] = Start(log)
            log.fd = fopen(log.file, 'w');
        end
        
        function [ log ] = End(log)
            fclose(log.fd);
        end
        
        function [ ] =  d(log, TAG, Message)
            fprintf(log.fd, 'Debug:%s:%s\n', TAG, Message); 
        end
        
        function [ ] =  e(log, TAG, Message)
            fprintf(log.fd, 'Error:%s:%s\n', TAG, Message); 
        end
        
        function [ ] =  i(log, TAG, Message)
            fprintf(log.fd, 'Info:%s:%s\n', TAG, Message); 
        end
        
        function [ ] =  w(log, TAG, Message)
            fprintf(log.fd, 'Warning:%s:%s\n', TAG, Message); 
        end
    end    
end