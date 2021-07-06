function jumptoline(file,line,varargin)


if strcmp(varargin(1),'concise')
    
    hotlinkcode = ...
        sprintf('Go to <a href="matlab: matlab.desktop.editor.openAndGoToLine(which(''%s''), %d) ">line %d</a>', file, line, line);
    
    
else
    
    hotlinkcode = ...
        sprintf('Go to <a href="matlab: matlab.desktop.editor.openAndGoToLine(which(''%s''), %d) ">%s line %d</a>', file, line, file, line);
    
    
end

disp(hotlinkcode)
end

