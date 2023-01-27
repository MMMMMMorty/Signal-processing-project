clc%清空终端
close all%删除其句柄未隐藏的所有图窗
%%
%%读取数据集
%读取训练音频文件——批量读取文件
PathToDatabase1='D:\Matlab\toolbox\libsvm-3.24\windows\database\noise';
PathToDatabase2='D:\Matlab\toolbox\libsvm-3.24\windows\database\music';
PathToDatabase3='D:\Matlab\toolbox\libsvm-3.24\windows\database\speech';
cd(PathToDatabase1);%进入训练数据集文件夹noise
filedir1=dir('*.wav');%列出本文件夹中的wav文件
cd (PathToDatabase2);%进入训练数据集文件夹music
filedir2=dir('*.wav');%列出本文件夹中的wav文件
cd (PathToDatabase3);%进入训练数据集文件夹speech
filedir3=dir('*.wav');%列出本文件夹中的wav文件
disp(filedir1(1).name);
length_filedir=length(filedir1)+length(filedir2)+length(filedir3);
%Y将存储.wav采样数据和FS目录中所有音频文件的采样率。
Y=cell(length_filedir,1);
%Y的格式为1*length_filedir
Fs=Y;%预加载Fs
label=cell(length_filedir,1);
for i = 1:length_filedir
    label{i,1}=zeros(1,1);
end
%[0 0 0]表示noise music speech的标签，
%若某种标签成立，则对应元素为1
%将label定义为一个数组（one_hot类型的）
%{
label_1='noise';
label_2='music';
label_3='speech';
%}
for i= 1:length(filedir1)
    %读取.wav文件并将他们存储再cell数组中
    [Y{i,1}, Fs{i,1}] = audioread(filedir1(i).name); 
    %将文件夹作为标签
    label{i,1}(1,1)=1;    
    disp(Y{i,1});
end
length_12=length(filedir1)+length(filedir2);
for i= length(filedir1)+1 : length_12
    %读取.wav文件并将他们存储再cell数组中
    [Y{i,1}, Fs{i,1}] = audioread(filedir2(i-length(filedir1)).name); 
    %将文件夹作为标签
    label{i,1}(1,1)=2;    
end
for i= length_12+1 : length_filedir
    %读取.wav文件并将他们存储再cell数组中
    [Y{i,1}, Fs{i,1}] = audioread(filedir3(i-length_12).name); 
    %将文件夹作为标签
    label{i,1}(1,1)=3;    
end

%%
%%提取特征
%{
MFCC-CON，MFCC-CMS, MFCC-AUD, 
MFCC-PRE, MFCC-FFT, SPEC-FFT
一共六种特征，需要六种分类器；
再最后提取完特征后，取其中的一半作为训练数据集，
另外一半作为测试数据集
%}
%%
%提取mfcc_con_feature
mfcc_con_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %该特征的固定输出为：13行n列（不确定）
    mfcc_con_feature{i,1} = mfcc_con(Y{i,1},Fs{i,1},100);%将特征存入到数组当中
    %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
    mfcc_con_feature{i,1}=mean(cov(transpose(mfcc_con_feature{i,1})),1);
end
%将label元组与mfcc_con_feature元组合并
%label{i行[1行3列]*1列}
%mfcc_con_feature{i行[1行13列]*1列}
mfcc_con_Feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_con_Feature_total{i,1}=zeros(14);%合并系数
    mfcc_con_Feature_total{i,1}=[mfcc_con_feature{i,1} label{i,1}];
end
%将元胞数组l转换为基础数组[length_filedir*14]
mfcc_con_Feature_total=cell2mat(mfcc_con_Feature_total);
mfcc_con_Feature_total=mfcc_con_Feature_total(randperm(size(mfcc_con_Feature_total,1)),:);
%打乱数组

%制作训练数据集以及测试数据集(3,7比例分)
mfccConTrainingfeature=mfcc_con_Feature_total(1:round(3*(length_filedir/10)),:);
mfccConTestingfeature=mfcc_con_Feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccConTrainingData.mat mfccConTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccConTestingData.mat mfccConTestingfeature;

%%
%提取mfcc_cms_feature
mfcc_cms_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %该特征的固定输出为：13维n列（不确定）
    mfcc_cms_feature{i,1} = mfcc_cms(Y{i,1},Fs{i,1},100);%将特征存入到数组当中
    %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
    mfcc_cms_feature{i,1}=mean(cov(transpose(mfcc_cms_feature{i,1})),1);
end
%将label元组与mfcc_cms_feature元组合并
%label{i行[1行3列]*1列}
%mfcc_cms_feature{i行[1行13列]*1列}
mfcc_cms_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_cms_feature_total{i,1}=zeros(14);%合并系数
    mfcc_cms_feature_total{i,1}=[mfcc_cms_feature{i,1} label{i,1}];
end
%将元胞数组l转换为基础数组[length_filedir*14]
mfcc_cms_feature_total=cell2mat(mfcc_cms_feature_total);
mfcc_cms_feature_total=mfcc_cms_feature_total(randperm(size(mfcc_cms_feature_total,1)),:);
%打乱数组

%制作训练数据集以及测试数据集(3,7比例分)
mfccCmsTrainingfeature=mfcc_cms_feature_total(1:round(3*(length_filedir/10)),:);
mfccCmsTestingfeature=mfcc_cms_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccCmsTrainingData.mat mfccCmsTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccCmsTestingData.mat  mfccCmsTestingfeature;

%%
%提取mfcc_aud_feature
mfcc_aud_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %该特征的固定输出为：13维n列（不确定）
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature);
    end
end
%disp(mfcc_aud_feature);
%将label元组与mfcc_aud_feature元组合并
%label{i行[1行3列]*1列}
%mfcc_aud_feature{i行[1行13列]*1列}
mfcc_aud_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_aud_feature_total{i,1}=zeros(14);%合并系数
    mfcc_aud_feature_total{i,1}=[mfcc_aud_feature{i,1} label{i,1}];
end
%将元胞数组l转换为基础数组[length_filedir*14]
mfcc_aud_feature_total=cell2mat(mfcc_aud_feature_total);
%打乱数数据集
mfcc_aud_feature_total=mfcc_aud_feature_total(randperm(size(mfcc_aud_feature_total,1)),:);

%制作训练数据集以及测试数据集(3,7比例分)
mfccAudTrainingfeature=mfcc_aud_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccAudTestingfeature=mfcc_aud_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccAudTrainingData.mat mfccAudTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccAudTestingData.mat mfccAudTestingfeature;
%%
%提取mfcc_fft_feature
mfcc_fft_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %该特征的固定输出为：13维n列（不确定）
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
end
%disp(mfcc_fft_feature);
%将label元组与mfcc_fft_feature元组合并
%label{i行[1行3列]*1列}
%mfcc_fft_feature{i行[1行13列]*1列}
mfcc_fft_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_fft_feature_total{i,1}=zeros(14);%合并系数
    mfcc_fft_feature_total{i,1}=[mfcc_fft_feature{i,1} label{i,1}];
end
%将元胞数组l转换为基础数组[length_filedir*14]
mfcc_fft_feature_total=cell2mat(mfcc_fft_feature_total);
%打乱数数据集
mfcc_fft_feature_total=mfcc_fft_feature_total(randperm(size(mfcc_fft_feature_total,1)),:);

%制作训练数据集以及测试数据集(3,7比例分)
mfccFftTrainingfeature=mfcc_fft_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccFftTestingfeature=mfcc_fft_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccFftTrainingData.mat mfccFftTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccFftTestingData.mat mfccFftTestingfeature;
%%
%提取spec_fft_feature
mfcc_fft_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %该特征的固定输出为：13维n列（不确定）
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%将特征存入到数组当中
        %将特征向量改为协方差向量并求每列均值转换为1*13的数据特征
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
end
%disp(mfcc_fft_feature);
%将label元组与mfcc_fft_feature元组合并
%label{i行[1行3列]*1列}
%mfcc_fft_feature{i行[1行13列]*1列}
mfcc_fft_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_fft_feature_total{i,1}=zeros(14);%合并系数
    mfcc_fft_feature_total{i,1}=[mfcc_fft_feature{i,1} label{i,1}];
end
%将元胞数组l转换为基础数组[length_filedir*14]
mfcc_fft_feature_total=cell2mat(mfcc_fft_feature_total);
%打乱数数据集
mfcc_fft_feature_total=mfcc_fft_feature_total(randperm(size(mfcc_fft_feature_total,1)),:);

%制作训练数据集以及测试数据集(3,7比例分)
mfccFftTrainingfeature=mfcc_fft_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccFftTestingfeature=mfcc_fft_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccFftTrainingData.mat mfccFftTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccFftTestingData.mat mfccFftTestingfeature;


%%
%%训练以及分类
    %1.导入训练数据
    %2.训练
    %3.将训练模型保存到mat文件当中
clc
close all
%%
%训练mfcc_con_feature
%导入训练数据
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccConTrainingData.mat','mfccConTrainingfeature');
%训练
disp(size(mfccConTrainingfeature));
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccCon_model_classifier=libsvmtrain(mfccConTrainingfeature(:,14),mfccConTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2代表设置了核函数为RBF
%保存训练模型到mat文件中
%disp(mfccCon_model_classifier);
svm_savemodel(mfccCon_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccon_model.model');
%%
%训练mfcc_cms_feature
%导入训练数据
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccCmsTrainingData.mat','mfccCmsTrainingfeature');
%训练
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccCms_model_classifier=libsvmtrain(mfccCmsTrainingfeature(:,14),mfccCmsTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2代表设置了核函数为RBF
%保存训练模型到mat文件中
svm_savemodel(mfccCms_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccms_model.model');
%%
%训练mfcc_aud_feature
%导入训练数据
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccAudTrainingData.mat','mfccAudTrainingfeature');
%训练
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccAud_model_classifier=libsvmtrain(mfccAudTrainingfeature(:,14),mfccAudTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2代表设置了核函数为RBF
%保存训练模型到mat文件中
svm_savemodel(mfccAud_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccaud_model.model');
%%
%训练mfcc_fft_feature
%导入训练数据
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccFftTrainingData.mat','mfccFftTrainingfeature');
%训练
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccFft_model_classifier=libsvmtrain(mfccFftTrainingfeature(:,14),mfccFftTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2代表设置了核函数为RBF
%保存训练模型到mat文件中
svm_savemodel(mfccFft_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccfft_model.model');

    