# Compute-Precision-Recall-F1Score

This is a matlab implementation of computing the following validation metrics for a visual classification problem:

    (1) precision (2) recall (3) f1-score (4) specificity
    
Here, we want to mention that for each validation metric, we respectively compute its micro-based value and macro-based value. 

For the dist_predict.mat file, "predict" is formed by the predicted label information of all the test samples.
Besides, the storage type of "predict" is cell with the size of $1\times 10$. The reason is that we construct the galley and probes for a given dataset by exploiting the mode of "randomly selecting". In our experiments, we repeat this way ten times, such that ten different pairs of gallery and probes can be obtained, and we report the mean value for each metric. 

I hope this code is useful for you. If you have any queries, please do not hesitate to contact me at: cs_wr@jiangnan.edu.cn
