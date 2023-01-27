%%�������
dim=16;%ά��Ϊ16
%����ģ��
mfccCon_model=svm_loadmodel('D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccon_model.model',dim);
mfccCms_model=svm_loadmodel('D:\Matlab\toolbox\libsvm-3.24\windows\model\mfcccms_model.model',dim);
mfccAud_model=svm_loadmodel('D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccaud_model.model',dim);
mfccFft_model=svm_loadmodel('D:\Matlab\toolbox\libsvm-3.24\windows\model\mfccfft_model.model',dim);
%���ز������ݼ�
cd('D:\Matlab\toolbox\libsvm-3.24\windows\dataset\testing_dataset');
load('MfccConTestingData.mat','mfccConTestingfeature');
%disp(size(mfccConTestingfeature));
%disp(mfccConTestingfeature);
load('MfccCmsTestingData.mat','mfccCmsTestingfeature');
load('MfccAudTestingData.mat','mfccAudTestingfeature');
load('MfccFftTestingData.mat','mfccFftTestingfeature');
cd('D:\Matlab\toolbox\libsvm-3.24\windows');
%ħ��label����
%1_noise,2_music,3_speech
%mfcc_con_label
%{
[r_num,c_num]=size(mfccConTestingfeature);
mfcc_con_label=zeros(r_num,1);
for i =1 : r_num
    if mfccConTestingfeature(i,14)==1
        mfcc_con_label(i,1)=1;
    end
    if mfccConTestingfeature(i,15)==1
        mfcc_con_label(i,1)=2;
    end
    if mfccConTestingfeature(i,16)==1
        mfcc_con_label(i,1)=3;
    end
end
disp(mfcc_con_label);
disp(size(mfcc_con_label));
%}
[MFCC_CON,mfcccon_accuracy,mfcccon_dec_value] = libsvmpredict(mfccConTestingfeature(:,14),mfccConTestingfeature(:,1:13),mfccCon_model);
%disp(mfccConTestingfeature(:,14));
%[MFCC_CON,mfcccon_accuracy,mfcccon_dec_value] = libsvmpredict(mfcc_con_label,mfccConTestingfeature(:,1:13),mfccCon_model);
[MFCC_CMS,mfcccms_accuracy,mfcccms_dec_value] = libsvmpredict(mfccCmsTestingfeature(:,14),mfccCmsTestingfeature(:,1:13),mfccCms_model);
%disp(mfccCmsTestingfeature(:,14));
[MFCC_AUD,mfccaud_accuracy,mfccaud_dec_value] = libsvmpredict(mfccAudTestingfeature(:,14),mfccAudTestingfeature(:,1:13),mfccAud_model);
[MFCC_FFT,mfccfft_accuracy,mfccfft_dec_value] = libsvmpredict(mfccFftTestingfeature(:,14),mfccFftTestingfeature(:,1:13),mfccFft_model);
plot(MFCC_CON);
plot(MFCC_CMS);
plot(MFCC_AUD);
plot(MFCC_FFT);
%���ͳ��
%{
[num_data,dim]=size(Testinging_feature);
num_error=0;
for i=1:num_data
    tf=isequal(resultPrecict(i,:),mfccConTestingfeature(i,14));
    if tf==0
        num_error=num_error+1;
    end
end
error_rate_MFCC_CON=num_error/num_data;
disp(error_rate_MFCC_CON);
%}
