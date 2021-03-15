function [] = phil_custom_imagesc(input_image,title_str, varargin)

    
    size(varargin, 2)
        
    icav = 0; 
    
    cl_flag = false;
    
    while icav < size(varargin, 2)
        
        icav = icav + 1;
    
        switch lower(varargin{icav})
            
            case {'colorlim','colorlimit','cl'}
            
                icav = icav + 1;
                
                cl_flag = true; 
                
                try
                    cl_values = varargin{icav};
                catch
                    error('No color values provided')
                end
                
            otherwise
                error('phil_custom_imagesc: Unknown keyword')
    
        end
    
    end
        
    figure;
    if cl_flag
        imagesc(input_image,cl_values);
    else
        imagesc(input_image);
    end
    
    
    title(title_str);
    axis xy equal tight; 
    colorbar; 
    set(gca,'Fontsize',16); 
    drawnow

end