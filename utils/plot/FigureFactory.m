function [ ] = FigureFactory(Type, Summary, d, IDX)
%FIGUREFACTORY 此处显示有关此函数的摘要
%   此处显示详细说明

switch Type
    case 'data'
        [ m, ~, k ] = size(Summary.Data);
        [ Data ] = mat2cell(Summary.Data*100, m, d.Counts, k);
    case 'time'
        [ m, ~, k ] = size(Summary.Time);
        [ Data ] = mat2cell(Summary.Time*1000, m, d.Counts, k);
    case 'state'
        [ Data ] = mat2cell(Summary.State'*100, length(d.Legends), d.Counts);
    otherwise
        throw(MException('FigureFactory', 'unknown type'));
end

    [ d ] = SetLabels(d, Type);
    [ Info ] = Transform(Data, d, 1);
    BatchDraw(Info, IDX);

    function [ d ] = SetLabels(d, type)
        switch type
            case 'data'
                d.yLabels = {'Accuracy(%)', 'Precision(%)', 'Recall(%)', 'F1(%)'};
            case 'time'
                d.yLabels = {'Training time(ms)'};                
            case 'state'
                d.yLabels = {'Rate(%)'};
        end
    end

    function [ Summary ] = Transform(Data, d, k)
        xTickLabels = mat2cell(d.XTicklabel', d.Counts);
        Summary = [ ];
        for i = 1 : length(d.Titles)
            data = Data{i};
            s.Draw = d.Draws{i};
            s.Grid = d.Grids{i};
            s.Title = d.Titles{i};
            s.XLabel = d.xLabels{i};
            s.YLabel = d.yLabels{k};
            s.XTicklabels = xTickLabels{i};
            s.Legends = d.Legends(d.STL);
            s.Arc = d.Arcs(i);
            s.Stat = data(d.STL,:,k);
            Summary = cat(1, Summary, s);
        end
    end

    function [ ] = BatchDraw(Info, IDX)
        i = 1;
        for p = IDX
            subplot(2, 2, i);
            DrawResult(Info(p));
            hold on
            i = i + 1;
        end
    end

    function [ ] = DrawResult(s)
    %DRAWRESULT 此处显示有关此函数的摘要
    % 绘制实验结果
    %   此处显示详细说明
        s.Draw(s.Stat');
        title(s.Title)
        xlabel(s.XLabel);
        ylabel(s.YLabel);
        legend(s.Legends, 'Location', 'northwest');
        grid(s.Grid);
        set(gca, 'XTicklabel', s.XTicklabels, 'XTickLabelRotation', s.Arc);
    end

end

