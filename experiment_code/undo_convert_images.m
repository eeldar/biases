function [] = undo_convert_images()
   directory_cell = {'Images', 'Text'};

    for folder_name_idx = 1:length(directory_cell)
        %% save old versions of directories
        folder_name = directory_cell{folder_name_idx};
        old_folder = strcat(folder_name, '_old');
        if exist(old_folder, 'dir') == 7 %7 if directory, 0 if doesn't exist
            rmdir(folder_name,'s')
            movefile(old_folder, folder_name)
        end
    end
end