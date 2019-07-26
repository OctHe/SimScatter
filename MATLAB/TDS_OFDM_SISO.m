%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Trace driven simulation
%   TODO: BER problem, the SNR-BER relationship
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clear; close all;

%% Global params
global LONG_PREAMBLE_LEN N_CP N_SC TAIL_LEN
global DEBUG
GlobalVariables;

tic;

%% Params
MOD_ORDER               = 16;           % Modulation order (2/4/16/64 = BSPK/QPSK/16-QAM/64-QAM)
DATA_NUM                = 48 * 6000;       % the minimum data number is 48 * 6 to compatible with the rate 2/3 and 3/4
Code_Rate               = 2;            % 2(1/2); 3(2/3); 4(3/4)
TxSignalPower           = 1;            % signal power, (mW); 1mW = 0dBm
FrequencyOffset         = 0;            % unit is Hz
Ts                      = 0.05e-6;      % Ts = 1 / fs; sample rate = 20MHz

DEBUG = false;

MOD_ORDER_Map = [2, 2, 4, 4, 16, 16, 64, 64];
Code_Rate_Map = [2, 4, 2, 4, 2, 4, 3, 4];

%% Read CSI traces

% [Responses_linear, ~, SNRs_mW, TracesNums] = ReadTraces('Traces_mW.h5');
[SNRs_dB, ~, TracesNums, Timestamps] = ReadTracesFromMat('../CSITraces_low_velocity.mat');

BERs_Mat = zeros(8, TracesNums);
for trace_index = 1: 10
for mod_index = 6: -1: 6
    
    %% Trace driven simulation parameters
    % Delete them when debug
    MOD_ORDER = MOD_ORDER_Map(mod_index);
    Code_Rate = Code_Rate_Map(mod_index);
    
    %% Transmitter pipeline
    RawData = randi([0, MOD_ORDER - 1], DATA_NUM, 1); % randam raw datas
    RawDataBin = Dec2BinVector(RawData, log2(MOD_ORDER));

    [OFDM_TX_Air, AirFrameLen] = OFDM_TX_Pipeline(RawDataBin, MOD_ORDER, Code_Rate, TxSignalPower);

    AirTxPower = sum(abs(OFDM_TX_Air).^2)/length(OFDM_TX_Air);

    %% channel model
    OFDM_RX_Air = OFDM_TX_Air;
    
    % % Add frequency offset
    % OFDM_RX_Air = OFDM_RX_Air .* exp(1j * (- 2 * pi * Ts * FrequencyOffset) * ((0: (AirFrameLen -1)).'));

    % % Add the channel response
    % OFDM_RX_reshape = reshape(OFDM_RX_Air, N_CP + N_SC, []);
    % for FrameIndex = 1: size(OFDM_RX_reshape, 2)
    %     temp = [OFDM_RX_reshape(:, FrameIndex); OFDM_RX_reshape(:, FrameIndex)];
    %     temp = conv(temp, Response);
    %     temp = temp(N_CP + N_SC + 1: 2 * (N_CP + N_SC));
    %     OFDM_RX_reshape(:, FrameIndex) = temp;
    % end
    % OFDM_RX_Air = reshape(OFDM_RX_reshape, [], 1);

    % Add the awgn channel
    OFDM_RX_Air = awgn(OFDM_RX_Air, 15, 'measured');

    %% receiver pipeline
    RawDataBin_Rx = OFDM_RX_Pipeline(OFDM_RX_Air, AirFrameLen, MOD_ORDER, Code_Rate);

    %% Transmission Result

    ErrorPosition = xor(RawDataBin_Rx, RawDataBin);
    ErrorPosition = ErrorPosition(1: end - 100); % remove tail bits (to be done)
    BinDataNums = length(ErrorPosition);

    BER = sum(ErrorPosition) / BinDataNums;

    disp(['Mod index: ' num2str(mod_index) '; BER: ' num2str(BER)])
    
    BERs_Mat(mod_index, trace_index) = BER;
    
    % if BER == 0, skip the lower modulation
    if BER == 0
        break;
    end
    
    %% tic toc

    if mod(trace_index, 100) == 0
        toc; % display transmission time
    end

end % end mod index
end % end trans index

% Save file
save('BERs.mat', 'BERs_Mat');
