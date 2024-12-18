function key = dtmf_decoder(filename)
    % Load the .mat file
    data = load(filename);
    y = data.y;   
    fs = 8000;        
    N = length(y);
    Y = abs(fft(y, N));     
    Y = Y(1:floor(N/2));       
    freqs = (0:N/2-1) * (fs / N); 
    % DTMF frequencies
    row_freqs = [697, 770, 852, 941];
    col_freqs = [1209, 1336, 1477];

    % row & col
    detected_row_freqs = detect_frequency(row_freqs, Y, freqs);
    detected_col_freqs = detect_frequency(col_freqs, Y, freqs);

    % keypas
    keypad = [
        '1', '2', '3';
        '4', '5', '6';
        '7', '8', '9';
        '*', '0', '#'
    ];
    % freq and keys
    if ~isempty(detected_row_freqs) && ~isempty(detected_col_freqs)
        row_num = find(row_freqs == detected_row_freqs);
        col_num = find(col_freqs == detected_col_freqs);
        key = str2double(keypad(row_num, col_num));
    else
        error('DTMF freq not found');
    end
end
function detected_freq = detect_frequency(target_freqs, Y, freqs)
    detected_freq = [];
    % threshol
    threshold = max(Y) * 0.1;  
    %target frequencies and find peaks
    for target_freq = target_freqs
        % target freq
        id = find(abs(freqs - target_freq) < 10); 
        % Check mag
        if max(Y(id)) > threshold
            detected_freq = target_freq;
            break;
        end
    end
end

disp('test files:');
try
    key0 = dtmf_decoder('dial_0.mat');
    disp(['Key detected for dial_0.mat: ', num2str(key0)]);

    key1 = dtmf_decoder('dial_1.mat');
    disp(['Key detected for dial_1.mat: ', num2str(key1)]);

    key2 = dtmf_decoder('dial_2.mat');
    disp(['Key detected for dial_2.mat: ', num2str(key2)]);

    key3 = dtmf_decoder('dial_3.mat');
    disp(['Key detected for dial_3.mat: ', num2str(key3)]);

    key4 = dtmf_decoder('dial_4.mat');
    disp(['Key detected for dial_4.mat: ', num2str(key4)]);

    key5 = dtmf_decoder('dial_5.mat');
    disp(['Key detected for dial_5.mat: ', num2str(key5)]);

    key6 = dtmf_decoder('dial_6.mat');
    disp(['Key detected for dial_6.mat: ', num2str(key6)]);

    key7 = dtmf_decoder('dial_7.mat');
    disp(['Key detected for dial_7.mat: ', num2str(key7)]);

    key8 = dtmf_decoder('dial_8.mat');
    disp(['Key detected for dial_8.mat: ', num2str(key8)]);

    key9 = dtmf_decoder('dial_9.mat');
    disp(['Key detected for dial_9.mat: ', num2str(key9)]);

   
catch ME
    disp(['Error occurred: ', ME.message]);
end