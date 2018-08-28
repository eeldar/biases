function [] = convert_images(inp_colors)
    %% input
    % example flicker fusion result
    if nargin == 0
        inp_colors = [158,63,63;
        61,88,139;
        61,128,83;
        139,61,100;
        139,86,61;
        61,100,139;
        79,94,121;
        155, 79, 76];
    end

    %add gray
    inp_colors = inp_colors(1:7,:);
    inp_colors = [100,100,100;inp_colors];

    %for later color mapping
    valueSet = [8,2,3,4,5,6,8,7,7, 8];
    keySet = {'Probability Bar.PNG';'Ball01 red.png';'Ball02 blue.png';'Ball03 green.png';'Ball04 magenta.png';'Ball05 brown.png';'Bar2.png';'Fix.png';'Knob01.png';'Knob02Grey.png'};
    imageMap = containers.Map(keySet,valueSet);

    directory_cell = {'Images', 'Text'};

    for folder_name_idx = 1:length(directory_cell)
        %% save old versions of directories
        folder_name = directory_cell{folder_name_idx};
        old_folder = strcat(folder_name, '_old');
        if exist(old_folder, 'dir') == 0 %7 if directory, 0 if doesn't exist
            if exist(folder_name, 'dir') > 0
                mkdir(old_folder)
                copyfile(folder_name,old_folder)
            else
               warning(strcat(folder_name,' folder does not exist'));
            end
        end
        %% text folder change colors
        cd(folder_name);
        pngs = [dir('*.PNG');dir('*.png')];
        for png_idx = 1:length(pngs)
            file_name = pngs(png_idx).name;
            [~, map, alpha] = imread(file_name);


            out_color = [0 0 0];
            if ~isempty(strfind(folder_name,'Text'))
                out_color = inp_colors(7,:);
            elseif isempty(strfind(file_name,'Urn'))
                out_color = inp_colors(imageMap(file_name),:);
            end
            tr = 100; %threshold set rather abitrarily
            alpha(alpha<tr) = 0; 
            alpha(alpha>=tr) = 255;
   
            if isempty(strfind(file_name,'Urn')) % skip urn a urn b 
                converted = convertImage(alpha,map, out_color);
                imwrite(converted, strcat(file_name), 'Alpha', alpha);
            else
                if ~isempty(strfind(file_name,'UrnA'))
                    which = 1;
                    urn = convertUrn(alpha, inp_colors, which);
                    imwrite(urn, strcat(file_name), 'Alpha', alpha);
                elseif ~isempty(strfind(file_name,'UrnB'))
                    which = 0;
                    urn = convertUrn(alpha, inp_colors, which);
                    imwrite(urn, strcat(file_name), 'Alpha', alpha);
                end
            end

        end
        cd('..')

    end
end
function out_color = extract_primary_rgb(im_array)
    %convert to double to avoid overflow
    im_array=double(im_array);
    
    %pack rgb values into one number
    y=1000000*im_array(:,:,1)+1000*im_array(:,:,2)+im_array(:,:,3);
    
    %sort rows by how often they occur
    hist_out = sortrows([unique(y(:)) histc(y(:),unique(y(:)))],2);

    %if most frequent color is 0 it doesn't count
    if length(hist_out) == 1
        colr = hist_out(1,1)
    elseif hist_out(end,1) == 0 || hist_out(end,1) == 255255255
        colr = hist_out(end-1,1);
    else
        colr = hist_out(end,1);
    end
    
    %unpack rgb values and add to output
    colrstr = sprintf('%09d', colr);
    r= str2num(colrstr(1:3));
    g= str2num(colrstr(4:6));
    b= str2num(colrstr(7:9));
    out_color = [r, g, b];

end
function rgb = convertImage(im_array, map, color)
    bw = im2bw(im_array,map, graythresh(im_array));
    rgb = repmat(double(bw),[1,1,3]);
    for color_channel = 1:3
        rgb(:,:,color_channel) = rgb(:,:,color_channel)*color(color_channel);
    end
    rgb = uint8(rgb);
end

function urn = convertUrn(alpha, inp_colors, which)
    %read in blank alpha
    if (nargin < 2)
        inp_colors = [158,63,63;
        61,88,139;
        61,128,83;
        139,61,100;
        139,86,61;
        61,100,139;
        79,94,121;
        155, 79, 76];
        inp_colors = inp_colors(1:7,:);
        inp_colors = [100,100,100;inp_colors];
    end
    if (nargin < 3)
        which = 1;
    end
    %labeled components
    labeled = labelmatrix(bwconncomp(alpha));

    %convert brown and boundary
    brown_out = convertMask(labeled, 10, inp_colors(6,:)) + convertMask(labeled, 8, inp_colors(6,:)); %brown 
    
    boundary_out = convertMask(labeled, 1, inp_colors(8,:));
    %convert red, green, blue, pink for A for each
    if which == 1
        green_out = convertMask(labeled, 4, inp_colors(4,:)) + convertMask(labeled, 5, inp_colors(4,:));
        red_out = convertMask(labeled, 2, inp_colors(2,:))+ convertMask(labeled, 3, inp_colors(2,:)); 
        blue_out = convertMask(labeled, 7, inp_colors(3,:)) + convertMask(labeled, 9, inp_colors(3,:)); 
        pink_out = convertMask(labeled, 6, inp_colors(5,:)); 
    else
        green_out = convertMask(labeled, 4, inp_colors(2,:)) + convertMask(labeled, 5, inp_colors(2,:));
        red_out = convertMask(labeled, 2, inp_colors(4,:))+ convertMask(labeled, 3, inp_colors(4,:)); 
        blue_out = convertMask(labeled, 7, inp_colors(5,:)) + convertMask(labeled, 9, inp_colors(5,:)); 
        pink_out = convertMask(labeled, 6, inp_colors(3,:)); 
    end
        
    urn =green_out +red_out + blue_out + pink_out + boundary_out + brown_out;

end

function out = convertMask(mask, mask_val, color)
    bw = (mask == mask_val);
    rgb = (repmat(double(bw),[1,1,3]));
    for color_channel = 1:3
        unique(rgb(:,:,color_channel));
        rgb(:,:,color_channel) = rgb(:,:,color_channel)*color(color_channel);
        unique(rgb(:,:,color_channel));
    end
    out = uint8(rgb);
end
