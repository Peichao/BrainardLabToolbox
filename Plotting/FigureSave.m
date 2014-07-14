function FigureSave(figName,figHandle,figType)
% FigureSave(figName,figHandle,figType)
%
% Encapsulates figure saving.  This way you
% can swap in the method here.
%
% Loops over list in figType if figType is a cell array.
%
% 4/6/14  dhb  Wrote it
% 7/14/14 dhb  savefig -> savefigghost

if iscell(figType)
    for i = 1:length(figType)
        if (exist('exportfig','file'))
            exportfig(figHandle,figName,'FontMode', 'fixed','FontSize', 12,'Width',6,'Height',6, 'color', 'cmyk','Format',figType{i});
        elseif (ismac & exist('savefigghost','file'))
            savefigghost(figName,figHandle,figType{i});
        else
            saveas(figHangle,figName,figType{i});
        end
    end
else
    if (exist('exportfig','file'))
        exportfig(figHandle,figName,'FontMode', 'fixed','FontSize', 12,'Width',6,'Height',6, 'color', 'cmyk','Format',figType);
    elseif (ismac & exist('savefigghost','file'))
        savefigghost(figName,figHandle,figType);
    else
        saveas(figHangle,figName,figType{i});
    end
end
