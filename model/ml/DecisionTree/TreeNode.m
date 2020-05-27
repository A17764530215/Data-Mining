classdef tree_node
    %TREE_NODE �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        split_index % �ָ���
        split_value % �ָ�ֵ
        child_left  % ���ӽڵ�
        child_right % ���ӽڵ�
    end
    
    properties (Constant)
        epsilon = 10e-6;
    end
    
    methods
        function obj = tree_node( idx, val, left, right )
            obj.split_index = idx;
            obj.split_value = val;
            obj.child_left = left;
            obj.child_right = right;
        end        
    end
    
    methods(Access = 'private') % Access by class members only
    end
    
end

