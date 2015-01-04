function [segments, NumObjects] = Segment(img,xStart,xEnd,yStart,yEnd,staffStarts,staffSections)
    %h = fspecial('average', [1,4]);
    %filtered=imfilter(img,h);
    %imshow(filtered);
    %%gram = sum(img,1);
    
    
    %% Pre-processing:
    img = imcomplement(img);

    
    %% Segmenting each block alone:
    img = img(:, xStart:xEnd);
    
    point = [yStart];
    staffLinesNum = size(staffStarts,1);
    staffCount = 1;
    
    while(staffCount <= staffLinesNum/staffSections/5)
        newIndex = 5*staffSections*staffCount;
        searchEnd = newIndex+1;
        if searchEnd > staffLinesNum
            searchEnd = yEnd+10;    %The last block.
        else
            searchEnd = staffStarts(searchEnd);
        end
        
        for i=staffStarts(newIndex):searchEnd
            if sum(img(i,:)) < 5    %Threshold.
                staffCount = staffCount + 1;
                point(staffCount) = i;
                break;
            end
        end
    end
    
    
    %Testing one output:
    %imshow( img(point(1):point(2), :) );
    
    
    %% Separating notes in each block:
    
    %%Blocks:
    [~,NumBlocks] = size(point);
    NumBlocks = NumBlocks-1;
    
    for blockIndex = 1:NumBlocks
        
        block = zeros(size(img));

        staffNum = ((blockIndex-1) * staffSections * 5) + 1;    %The position to start getting staff poistions of cuurrent block.
        blockStaffs = staffStarts(staffNum : staffNum+4);       %Staff positions of current block.
        staffHeight = (blockStaffs(2)-blockStaffs(1) + blockStaffs(3)-blockStaffs(2) + blockStaffs(4)-blockStaffs(3) + blockStaffs(5)-blockStaffs(4)) / 4;

        if(staffSections == 2)
            dualSectionStaffNum = 5 * staffSections * blockIndex - 5; %The position between two sections in a dual-section block.
            sectionEnd = (staffStarts(dualSectionStaffNum) + staffStarts(dualSectionStaffNum+1)) / 2; %Calculating The block end by removing the second section.
        else
            sectionEnd = point(blockIndex+1); %If not-dual-section, then just get the block end point.
        end

        block(point(blockIndex):sectionEnd, :) = img(point(blockIndex):sectionEnd, :); %Getting the block as an image.

        
        %Getting segments:
        CC = bwconncomp(block);
        NumObjects = CC.NumObjects;
        segments = regionprops(CC, 'Image', 'PixelList');

        %figure(3), imshow(block);
        
        noteIndex  = 1;
        blockNotes = char.empty;
        blockDurat = double.empty;

        

        %%Notes:
        for i = 1:NumObjects
            position = min(segments(i).PixelList);  %The upper-left coords for this component.
            y = position(2);
            segImg = segments(i).Image;

            %Frequency:
            Epos = (blockStaffs(1) + blockStaffs(2)) / 2;
            Cpos = (blockStaffs(2) + blockStaffs(3)) / 2;
            Gpos = (blockStaffs(1) - staffHeight/2);
            Apos = (blockStaffs(1) - staffHeight);

            sError  = 2;    %Error value for the position of a note from staff lines.
            minSize = 5;    %If smaller than this value (in both width height), considered noise.

            segSize = size(segImg);
            if segSize(1)>minSize || segSize(2)>minSize
                %figure(2), imshow(segImg);
                type = Classify(segImg);

                if type=='1' || type=='2' || type=='4'
                    if(y<=Apos+sError && y>=Apos-sError)
                        blockNotes(noteIndex) = 'A';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('A');
                    elseif(y<=Gpos+sError && y>=Gpos-sError)
                        blockNotes(noteIndex) = 'G';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('G');
                    elseif(y<=blockStaffs(1)+sError && y>=blockStaffs(1)-sError)
                        blockNotes(noteIndex) = 'F';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('F');
                    elseif(y<=Epos+sError && y>=Epos-sError)
                        blockNotes(noteIndex) = 'E';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('E');
                    elseif(y<=blockStaffs(2)+sError && y>=blockStaffs(2)-sError)
                        blockNotes(noteIndex) = 'D';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('D');
                    elseif(y<=Cpos+sError && y>=Cpos-sError)
                        blockNotes(noteIndex) = 'C';
                        blockDurat(noteIndex) = str2num(type);
                        noteIndex = noteIndex+1;
                        %display('C');
                    end
                    
                elseif type=='b'
                    blockNotes(noteIndex) = '|';
                    blockDurat(noteIndex) = 16;
                    noteIndex = noteIndex+1;
                end
            end
        end
        
        %All block notes are ready:
        PlaySong(blockNotes, blockDurat);
        
    end
    
    %for i=1:NumSegments
    %   seg = imcomplement(segments(i).Image);
    %   
    %   imSize = size(seg);
    %  
    %   if imSize(1)>5 || imSize(2)>5
    %       imshow(seg);
    %   end
    %end

end
