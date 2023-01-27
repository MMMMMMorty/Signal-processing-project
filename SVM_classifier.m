clc%����ն�
close all%ɾ������δ���ص�����ͼ��
%%
%%��ȡ���ݼ�
%��ȡѵ����Ƶ�ļ�����������ȡ�ļ�
PathToDatabase1='D:\Matlab\toolbox\libsvm-3.24\windows\database\noise';
PathToDatabase2='D:\Matlab\toolbox\libsvm-3.24\windows\database\music';
PathToDatabase3='D:\Matlab\toolbox\libsvm-3.24\windows\database\speech';
cd(PathToDatabase1);%����ѵ�����ݼ��ļ���noise
filedir1=dir('*.wav');%�г����ļ����е�wav�ļ�
cd (PathToDatabase2);%����ѵ�����ݼ��ļ���music
filedir2=dir('*.wav');%�г����ļ����е�wav�ļ�
cd (PathToDatabase3);%����ѵ�����ݼ��ļ���speech
filedir3=dir('*.wav');%�г����ļ����е�wav�ļ�
disp(filedir1(1).name);
length_filedir=length(filedir1)+length(filedir2)+length(filedir3);
%Y���洢.wav�������ݺ�FSĿ¼��������Ƶ�ļ��Ĳ����ʡ�
Y=cell(length_filedir,1);
%Y�ĸ�ʽΪ1*length_filedir
Fs=Y;%Ԥ����Fs
label=cell(length_filedir,1);
for i = 1:length_filedir
    label{i,1}=zeros(1,1);
end
%[0 0 0]��ʾnoise music speech�ı�ǩ��
%��ĳ�ֱ�ǩ���������ӦԪ��Ϊ1
%��label����Ϊһ�����飨one_hot���͵ģ�
%{
label_1='noise';
label_2='music';
label_3='speech';
%}
for i= 1:length(filedir1)
    %��ȡ.wav�ļ��������Ǵ洢��cell������
    [Y{i,1}, Fs{i,1}] = audioread(filedir1(i).name); 
    %���ļ�����Ϊ��ǩ
    label{i,1}(1,1)=1;    
    disp(Y{i,1});
end
length_12=length(filedir1)+length(filedir2);
for i= length(filedir1)+1 : length_12
    %��ȡ.wav�ļ��������Ǵ洢��cell������
    [Y{i,1}, Fs{i,1}] = audioread(filedir2(i-length(filedir1)).name); 
    %���ļ�����Ϊ��ǩ
    label{i,1}(1,1)=2;    
end
for i= length_12+1 : length_filedir
    %��ȡ.wav�ļ��������Ǵ洢��cell������
    [Y{i,1}, Fs{i,1}] = audioread(filedir3(i-length_12).name); 
    %���ļ�����Ϊ��ǩ
    label{i,1}(1,1)=3;    
end

%%
%%��ȡ����
%{
MFCC-CON��MFCC-CMS, MFCC-AUD, 
MFCC-PRE, MFCC-FFT, SPEC-FFT
һ��������������Ҫ���ַ�������
�������ȡ��������ȡ���е�һ����Ϊѵ�����ݼ���
����һ����Ϊ�������ݼ�
%}
%%
%��ȡmfcc_con_feature
mfcc_con_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %�������Ĺ̶����Ϊ��13��n�У���ȷ����
    mfcc_con_feature{i,1} = mfcc_con(Y{i,1},Fs{i,1},100);%���������뵽���鵱��
    %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
    mfcc_con_feature{i,1}=mean(cov(transpose(mfcc_con_feature{i,1})),1);
end
%��labelԪ����mfcc_con_featureԪ��ϲ�
%label{i��[1��3��]*1��}
%mfcc_con_feature{i��[1��13��]*1��}
mfcc_con_Feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_con_Feature_total{i,1}=zeros(14);%�ϲ�ϵ��
    mfcc_con_Feature_total{i,1}=[mfcc_con_feature{i,1} label{i,1}];
end
%��Ԫ������lת��Ϊ��������[length_filedir*14]
mfcc_con_Feature_total=cell2mat(mfcc_con_Feature_total);
mfcc_con_Feature_total=mfcc_con_Feature_total(randperm(size(mfcc_con_Feature_total,1)),:);
%��������

%����ѵ�����ݼ��Լ��������ݼ�(3,7������)
mfccConTrainingfeature=mfcc_con_Feature_total(1:round(3*(length_filedir/10)),:);
mfccConTestingfeature=mfcc_con_Feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccConTrainingData.mat mfccConTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccConTestingData.mat mfccConTestingfeature;

%%
%��ȡmfcc_cms_feature
mfcc_cms_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %�������Ĺ̶����Ϊ��13άn�У���ȷ����
    mfcc_cms_feature{i,1} = mfcc_cms(Y{i,1},Fs{i,1},100);%���������뵽���鵱��
    %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
    mfcc_cms_feature{i,1}=mean(cov(transpose(mfcc_cms_feature{i,1})),1);
end
%��labelԪ����mfcc_cms_featureԪ��ϲ�
%label{i��[1��3��]*1��}
%mfcc_cms_feature{i��[1��13��]*1��}
mfcc_cms_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_cms_feature_total{i,1}=zeros(14);%�ϲ�ϵ��
    mfcc_cms_feature_total{i,1}=[mfcc_cms_feature{i,1} label{i,1}];
end
%��Ԫ������lת��Ϊ��������[length_filedir*14]
mfcc_cms_feature_total=cell2mat(mfcc_cms_feature_total);
mfcc_cms_feature_total=mfcc_cms_feature_total(randperm(size(mfcc_cms_feature_total,1)),:);
%��������

%����ѵ�����ݼ��Լ��������ݼ�(3,7������)
mfccCmsTrainingfeature=mfcc_cms_feature_total(1:round(3*(length_filedir/10)),:);
mfccCmsTestingfeature=mfcc_cms_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccCmsTrainingData.mat mfccCmsTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccCmsTestingData.mat  mfccCmsTestingfeature;

%%
%��ȡmfcc_aud_feature
mfcc_aud_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %�������Ĺ̶����Ϊ��13άn�У���ȷ����
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_aud_feature{i,1} = mfcc_aud(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_aud_feature{i,1}=mean(cov(transpose(mfcc_aud_feature{i,1})),1);
        %disp(mfcc_aud_feature);
    end
end
%disp(mfcc_aud_feature);
%��labelԪ����mfcc_aud_featureԪ��ϲ�
%label{i��[1��3��]*1��}
%mfcc_aud_feature{i��[1��13��]*1��}
mfcc_aud_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_aud_feature_total{i,1}=zeros(14);%�ϲ�ϵ��
    mfcc_aud_feature_total{i,1}=[mfcc_aud_feature{i,1} label{i,1}];
end
%��Ԫ������lת��Ϊ��������[length_filedir*14]
mfcc_aud_feature_total=cell2mat(mfcc_aud_feature_total);
%���������ݼ�
mfcc_aud_feature_total=mfcc_aud_feature_total(randperm(size(mfcc_aud_feature_total,1)),:);

%����ѵ�����ݼ��Լ��������ݼ�(3,7������)
mfccAudTrainingfeature=mfcc_aud_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccAudTestingfeature=mfcc_aud_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccAudTrainingData.mat mfccAudTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccAudTestingData.mat mfccAudTestingfeature;
%%
%��ȡmfcc_fft_feature
mfcc_fft_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %�������Ĺ̶����Ϊ��13άn�У���ȷ����
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
end
%disp(mfcc_fft_feature);
%��labelԪ����mfcc_fft_featureԪ��ϲ�
%label{i��[1��3��]*1��}
%mfcc_fft_feature{i��[1��13��]*1��}
mfcc_fft_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_fft_feature_total{i,1}=zeros(14);%�ϲ�ϵ��
    mfcc_fft_feature_total{i,1}=[mfcc_fft_feature{i,1} label{i,1}];
end
%��Ԫ������lת��Ϊ��������[length_filedir*14]
mfcc_fft_feature_total=cell2mat(mfcc_fft_feature_total);
%���������ݼ�
mfcc_fft_feature_total=mfcc_fft_feature_total(randperm(size(mfcc_fft_feature_total,1)),:);

%����ѵ�����ݼ��Լ��������ݼ�(3,7������)
mfccFftTrainingfeature=mfcc_fft_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccFftTestingfeature=mfcc_fft_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccFftTrainingData.mat mfccFftTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccFftTestingData.mat mfccFftTestingfeature;
%%
%��ȡspec_fft_feature
mfcc_fft_feature=cell(length_filedir,1);
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
for i =1 : length_filedir
    %�������Ĺ̶����Ϊ��13άn�У���ȷ����
    if i>=1 && i<=length(filedir1)
        path=fullfile(PathToDatabase1,filedir1(i).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature{1,1});
    end
    if i>length(filedir1) && i<=length_12
        path=fullfile(PathToDatabase1,filedir2(i-length(filedir1)).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
    if i>length_12 && i<=length_filedir
        path=fullfile(PathToDatabase1,filedir3(i-length_12).name);
        mfcc_fft_feature{i,1} = mfcc_fft(path);%���������뵽���鵱��
        %������������ΪЭ������������ÿ�о�ֵת��Ϊ1*13����������
        mfcc_fft_feature{i,1}=mean(cov(transpose(mfcc_fft_feature{i,1})),1);
        %disp(mfcc_fft_feature);
    end
end
%disp(mfcc_fft_feature);
%��labelԪ����mfcc_fft_featureԪ��ϲ�
%label{i��[1��3��]*1��}
%mfcc_fft_feature{i��[1��13��]*1��}
mfcc_fft_feature_total=cell(length_filedir,1);
for i = 1 : length_filedir
    mfcc_fft_feature_total{i,1}=zeros(14);%�ϲ�ϵ��
    mfcc_fft_feature_total{i,1}=[mfcc_fft_feature{i,1} label{i,1}];
end
%��Ԫ������lת��Ϊ��������[length_filedir*14]
mfcc_fft_feature_total=cell2mat(mfcc_fft_feature_total);
%���������ݼ�
mfcc_fft_feature_total=mfcc_fft_feature_total(randperm(size(mfcc_fft_feature_total,1)),:);

%����ѵ�����ݼ��Լ��������ݼ�(3,7������)
mfccFftTrainingfeature=mfcc_fft_feature_total(1:round(3*(length_filedir/10)),:);
%disp(size(mfccAudTrainingfeature));
mfccFftTestingfeature=mfcc_fft_feature_total(round(3*(length_filedir/10))+1:length_filedir,:);
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
save MfccFftTrainingData.mat mfccFftTrainingfeature;
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
save MfccFftTestingData.mat mfccFftTestingfeature;


%%
%%ѵ���Լ�����
    %1.����ѵ������
    %2.ѵ��
    %3.��ѵ��ģ�ͱ��浽mat�ļ�����
clc
close all
%%
%ѵ��mfcc_con_feature
%����ѵ������
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccConTrainingData.mat','mfccConTrainingfeature');
%ѵ��
disp(size(mfccConTrainingfeature));
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccCon_model_classifier=libsvmtrain(mfccConTrainingfeature(:,14),mfccConTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2���������˺˺���ΪRBF
%����ѵ��ģ�͵�mat�ļ���
%disp(mfccCon_model_classifier);
svm_savemodel(mfccCon_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccon_model.model');
%%
%ѵ��mfcc_cms_feature
%����ѵ������
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccCmsTrainingData.mat','mfccCmsTrainingfeature');
%ѵ��
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccCms_model_classifier=libsvmtrain(mfccCmsTrainingfeature(:,14),mfccCmsTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2���������˺˺���ΪRBF
%����ѵ��ģ�͵�mat�ļ���
svm_savemodel(mfccCms_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccms_model.model');
%%
%ѵ��mfcc_aud_feature
%����ѵ������
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccAudTrainingData.mat','mfccAudTrainingfeature');
%ѵ��
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccAud_model_classifier=libsvmtrain(mfccAudTrainingfeature(:,14),mfccAudTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2���������˺˺���ΪRBF
%����ѵ��ģ�͵�mat�ļ���
svm_savemodel(mfccAud_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccaud_model.model');
%%
%ѵ��mfcc_fft_feature
%����ѵ������
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\training_dataset');
load('MfccFftTrainingData.mat','mfccFftTrainingfeature');
%ѵ��
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
mfccFft_model_classifier=libsvmtrain(mfccFftTrainingfeature(:,14),mfccFftTrainingfeature(:,1:13),'-c 2 -g 0.07');
%2���������˺˺���ΪRBF
%����ѵ��ģ�͵�mat�ļ���
svm_savemodel(mfccFft_model_classifier,'D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccfft_model.model');

    