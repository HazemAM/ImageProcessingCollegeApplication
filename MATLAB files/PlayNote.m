function [] = PlayNote(note, duration)
%%

    %% Duration:
    if duration==1
        duration = 10000;
    elseif duration==2
        duration = 5000;
    elseif duration==4
        duration = 2500;
    elseif duration==8
        duration = 1250;
    elseif duration==16
        duration = 625;
    else
        error('Duration must be one of 1, 2, 4, 8, and 16.');
    end

    %% Mapping:
    notecreate = @(frq,dur) sin(2*pi* (1:dur)/8192 * (440*2 .^ ((frq-1)/12))); %square or cos/sin
    notenames = {'A' 'A#' 'B' 'C' 'C#' 'D' 'D#' 'E' 'F' 'F#' 'G' 'G#'};

    for k1 = 1:length(note)
        idx = strcmp(note(k1), notenames);
        songidx(k1) = find(idx);
    end    

    %% Playing:
    %dur = 0.3*duration;
    songnote = [];
    for k1 = 1:length(songidx)
        songnote = [songnote; [notecreate(songidx(k1),duration)  zeros(1,75)]'];
    end

    soundsc(songnote, 8192, 24);
end