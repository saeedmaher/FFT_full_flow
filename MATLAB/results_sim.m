clc; clear; close all;

%% Load results
doubleData = load('double_results.mat');
fixedData_16  = load('fixed_16_results.mat');
fixedData_12  = load('fixed_12_results.mat');
fixedData_13  = load('fixed_13_results.mat');

%% Double Precision
fprintf('========== Double Precision ==========\n');
fprintf('Mean Error : %.6e\n', mean(doubleData.error));
fprintf('Max Error  : %.6e\n', max(doubleData.error));
fprintf('Mean SQNR  : %.2f dB\n', mean(doubleData.sqnr));

%% Fixed-Point 16-bit
fprintf('========== Fixed-Point (16-bit) ==========\n');
fprintf('Mean Error : %.6e\n', mean(fixedData_16.error));
fprintf('Max Error  : %.6e\n', max(fixedData_16.error));
fprintf('Mean SQNR  : %.2f dB\n', mean(fixedData_16.sqnr));

%% Fixed-Point 12-bit
fprintf('========== Fixed-Point (12-bit) ==========\n');
fprintf('Mean Error : %.6e\n', mean(fixedData_12.error));
fprintf('Max Error  : %.6e\n', max(fixedData_12.error));
fprintf('Mean SQNR  : %.2f dB\n', mean(fixedData_12.sqnr));

%% Plotting

Nrandom = numel(doubleData.error);
trials  = 1:Nrandom;

%% ---------- Figure 1: Error across trials ----------
figure('Name','Error per Trial');
subplot(3,1,1)
plot(trials, doubleData.error, 'b')
title('Double Precision - Max Error per Trial')
xlabel('Trial'); ylabel('Error'); grid on

subplot(3,1,2)
plot(trials, fixedData_16.error, 'r')
title('Fixed-Point 16-bit - Max Error per Trial')
xlabel('Trial'); ylabel('Error'); grid on

subplot(3,1,3)
plot(trials, fixedData_12.error, 'g')
title('Fixed-Point 12-bit - Max Error per Trial')
xlabel('Trial'); ylabel('Error'); grid on

%% ---------- Figure 2: SQNR across trials ----------
figure('Name','SQNR per Trial');
plot(trials, doubleData.sqnr, 'b', ...
     trials, fixedData_16.sqnr, 'r', ...
     trials, fixedData_12.sqnr, 'g')
legend('Double','Fixed 16-bit','Fixed 12-bit')
xlabel('Trial'); ylabel('SQNR (dB)')
title('SQNR per Trial Across Precisions')
grid on

%% ---------- Figure 3: Histograms of SQNR ----------
figure('Name','SQNR Distribution');
subplot(3,1,1)
histogram(doubleData.sqnr, 30, 'FaceColor','b')
title('Double Precision SQNR Distribution')
xlabel('SQNR (dB)'); ylabel('Count')

subplot(3,1,2)
histogram(fixedData_16.sqnr, 30, 'FaceColor','r')
title('Fixed-Point 16-bit SQNR Distribution')
xlabel('SQNR (dB)'); ylabel('Count')

subplot(3,1,3)
histogram(fixedData_12.sqnr, 30, 'FaceColor','g')
title('Fixed-Point 12-bit SQNR Distribution')
xlabel('SQNR (dB)'); ylabel('Count')

%% ---------- Figure 4: Bar chart comparison (means) ----------
meanError = [mean(doubleData.error), mean(fixedData_16.error), mean(fixedData_12.error)];
meanSQNR  = [mean(doubleData.sqnr),  mean(fixedData_16.sqnr),  mean(fixedData_12.sqnr)];
labels    = {'Double','Fixed 16-bit','Fixed 12-bit'};

figure('Name','Summary Comparison');
subplot(1,2,1)
bar(meanError)
set(gca,'XTickLabel',labels)
ylabel('Mean Error')
title('Mean Error Comparison')
grid on

subplot(1,2,2)
bar(meanSQNR)
set(gca,'XTickLabel',labels)
ylabel('Mean SQNR (dB)')
title('Mean SQNR Comparison')
grid on
