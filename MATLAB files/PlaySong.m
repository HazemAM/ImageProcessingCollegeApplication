function [] = PlaySong(song, durations)
    %% Inits.
    %Converting:
    song = cell2mat(song);
    durations = cell2mat(durations);
    
    %Getting size:
    [~, notes] = size(song);
    [~, durts] = size(durations);
    
    %Size checking:
    if notes ~= durts
       error('Length differs.');
    end
    
    %% Play
    secondsPerNote = 1;
    noteSeparator = 0.1;
    for i=1:notes
        if song(i) ~= '|'   %If '|' (bar), just pause, don't play anything.
            PlayNote(song(i), durations(i));
        end
        pause( (1/durations(i)) * secondsPerNote + noteSeparator );
    end

end