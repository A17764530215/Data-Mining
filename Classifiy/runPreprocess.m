% ʵ�������ݼ�
DataSets = UCI;

Data = cell(17, 1);
for i = 1 : 17
    Data{i} = Preprocess(DataSets(i));
end