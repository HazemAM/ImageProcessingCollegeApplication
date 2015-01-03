function [] = PlaySong(song, durations)
    %% Inits.
    %Converting:
    song = cell2mat(song);
    durations = cell2mat(durations);
    
    %Getting size:
    [~, notes] = size(song);
    [~, durts] = size(durations);
    
    %Size checking:
    if(notes~=durts)
       error('Length differs.');
    end
    
    %% Play
    secondsPerNote = 1;
    noteSeparator = 0.1;
    for i=1:notes
        PlayNote(song(i), durations(i));
        pause( (1/durations(i)) * secondsPerNote + noteSeparator );
    end

end