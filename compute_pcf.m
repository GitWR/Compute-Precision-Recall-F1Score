%% Build to compute precision, recall, f1-score, and specificity
%% author: Rui Wang
%% date: 05/12/19
clc
clear all
load dist_predict

% step1 --> build the true label for the test samples of the demo data
sj_label = zeros(1,39); %

l1 = 3; % number of test samples in each category
k1 = l1; 
a1 = linspace(1,13,13); % 13 represents the number of categories
i2 = 1;
while(k1 <= 39) % total number of test samples
    while(i2 <= 13)
        for i = 1:13
            i_test = l1*(i-1)+1;
            sj_label(i_test:k1) = a1(i2);
            k1 = k1+3;
            i2 = i2+1;
        end
    end
end

precision_mi = zeros(1, 10);
precision_ma = zeros(1, 10);
specificity_mi = zeros(1, 10);
specificity_ma = zeros(1, 10);
recall_mi = zeros(1, 10);
recall_ma = zeros(1, 10);
F1_score_mi = zeros(1, 10);
F1_score_ma = zeros(1, 10);

num_TP = zeros(1, length(unique(sj_label)));
num_FP = zeros(1, length(unique(sj_label)));
num_FN = zeros(1, length(unique(sj_label)));
num_TN = zeros(1, length(unique(sj_label)));

idx = [1,2,3,4,5,6,7,8,9,10];
num_idx = length(idx);

% step2--> compute precision for each class
for k = idx
    
    yc_class_i = predict{k}; % get the predict label of each combination
    for i = 1 : length(unique(sj_label))
        temp = yc_class_i;
        idx_yc = find(temp ~= i);
        temp(idx_yc) = 0; % compute the i-th class's value, we should set other classes labels of the predict label to 0
        idx_tp_fp = find(temp == i);
        temp(idx_tp_fp) = 1;
        %sj_label(idx_sj) = 0; % compute the i-th class's value, other classes labels of the actual label also need to be configued to 0
        idx_sj_count = find(sj_label == i); % find the index of the label i of the actual class
        num_TP(i) = sum(temp(idx_sj_count));
        temp(idx_sj_count) = 0; % set the locations of yc label to 0 by using idx_sj_count, for the purpose of computing num_FP
        num_FP(i) = sum(temp);
        num_TN(i) = length(sj_label) - length(idx_sj_count) - num_FP(i);
        num_FN(i) = length(idx_sj_count) - num_TP(i);
    end
    
    %% Micro-based averaging
    precision_mi(k) = sum(num_TP) / (sum(num_TP) + sum(num_FP));
    recall_mi(k) = sum(num_TP) / (sum(num_TP) + sum(num_FN));
    specificity_mi(k) = sum(num_TN) / (sum(num_TN) + sum(num_FP));
    F1_score_mi(k) = 2 * ((precision_mi(k) * recall_mi(k)) / (precision_mi(k) + recall_mi(k)));
    
    %% Macro-based averaging
    for j = 1 : length(unique(sj_label))
        temp = num_TP(j) / (num_TP(j) + num_FP(j));
        if (num_TP(j) + num_FP(j) == 0)
            temp = 0;
        end
        precision_ma(k) = precision_ma(k) + temp;
        recall_ma(k) = recall_ma(k) + num_TP(j) / (num_TP(j) + num_FN(j));
        specificity_ma(k) = specificity_ma(k) + num_TN(j) / (num_TN(j) + num_FP(j));
    end
    precision_ma(k) = precision_ma(k) / j;
    recall_ma(k) = recall_ma(k) / j;
    specificity_ma(k) = specificity_ma(k) / j;
    F1_score_ma(k) = 2 * ( (precision_ma(k) * recall_ma(k)) / (precision_ma(k) + recall_ma(k)));
    
end

precision_mean_mi = sum(precision_mi) / num_idx;
fprintf('precision_mean_mi = %d\n', precision_mean_mi);
precision_mean_ma = sum(precision_ma) / num_idx;
fprintf('precision_mean_ma = %d\n', precision_mean_ma);
recall_mean_mi = sum(recall_mi) / num_idx;
fprintf('recall_mean_mi = %d\n', recall_mean_mi);
recall_mean_ma = sum(recall_ma) / num_idx;
fprintf('recall_mean_ma = %d\n', recall_mean_ma);
F1_mean_mi = sum(F1_score_mi) / num_idx;
fprintf('F1_mean_mi = %d\n', F1_mean_mi);
F1_mean_ma = sum(F1_score_ma) / num_idx;
fprintf('F1_mean_ma = %d\n', F1_mean_ma);
specificity_mi = sum(specificity_mi) / num_idx;
fprintf('specificity_mi = %d\n', specificity_mi);
specificity_ma = sum(specificity_ma) / num_idx;
fprintf('specificity_ma = %d\n', specificity_ma);
