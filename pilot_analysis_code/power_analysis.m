% 
% power analysis performed by bootstrapping pilot data
%
%   USAGE:      power_analysis
%   OUTPUTS:    - power_weak:   power for discovering weak criteria given between 45 and 150 subjects
%               - power_strong: power for discovering strong criteria given between 45 and 150 subjects
%
for Nsub = 45:5:150
    randomization_power(Nsub);
end

files = dir('randomization_power_*.mat');
files(end) =[];
files = cat(1,files(12:end), files(1:11));
for f= 1:length(files)
    load(files(f).name);
    pnum = (pboot1<0.05)*1+(pboot2<0.05)*1+(pboot3<0.05)*1+(pboot4<0.05)*1+(pboot5<0.05)*1+(pboot6<0.05)*1;
    pnum_n = (pboot1>0.95)*1+(pboot2>0.95)*1+(pboot3>0.95)*1+(pboot4>0.95)*1+(pboot5>0.95)*1+(pboot6>0.95)*1;
    pall1 = (pboot31<0.05 & pboot32<1.95 & pboot21<1.95);

    power_weak(f) = nanmean(pall1);
    power_strong(f) = nanmean(pall1 & ~pnum_n & pnum>=2);
end

%% power analysis given a particualr sample size
function randomization_power(Nsub)
    %
    % power analysis
    %
    % USAGE: randominzation_power(Nsub)

    load summarized_data
    if nargin<1; Nsub = 44; end
    gambtype_org = gambtype;
    studtype_org = studtype;
    beeftype_org = beeftype;
    gambans_org = gambans;
    studans_org = studans;
    beefans_org = beefans;
    opttype_org = opttype;
    optans_org = optans;
    urntype_org = urntype;
    urnans_org = urnans;
    anchtype_org = anchtype;
    anchans_org = anchans;
    coinbeta_org = coinbeta;
    for rep = 1:1000
        rep
        samp = datasample(1:44,Nsub)';
        meanattphas_new = meanattphas(samp);
        ind11 = meanattphas_new<quantile(meanattphas_new,1/3);
        ind12 = meanattphas_new>=quantile(meanattphas_new,1/3) & meanattphas_new<quantile(meanattphas_new,2/3) ;
        ind13 = meanattphas_new>=quantile(meanattphas_new,2/3);
        ind11b = meanattphas_new<quantile(meanattphas_new,1/2);
        ind12b = meanattphas_new>=quantile(meanattphas_new,1/2);
        gambtype = gambtype_org(samp);
        studtype = studtype_org(samp);
        beeftype = beeftype_org(samp);
        gambans = gambans_org(samp,:);
        studans = studans_org(samp,:);
        beefans = beefans_org(samp,:);

        meanriskphas_new = meanriskphas(samp);
        ind21 = meanriskphas_new<quantile(meanriskphas_new,1/3);
        ind22 = meanriskphas_new>=quantile(meanriskphas_new,1/3) & meanriskphas_new<quantile(meanriskphas_new,2/3) ;
        ind23 = meanriskphas_new>=quantile(meanriskphas_new,2/3);
        ind21b = meanriskphas_new<quantile(meanriskphas_new,1/2);
        ind22b = meanriskphas_new>=quantile(meanriskphas_new,1/2);
        opttype = opttype_org(samp,:);
        optans = optans_org(samp,:);

        meangoalphas_new = meangoalphas(samp);
        ind31 = meangoalphas_new<quantile(meangoalphas_new,1/3);
        ind32 = meangoalphas_new>=quantile(meangoalphas_new,1/3) & meangoalphas_new<quantile(meangoalphas_new,2/3) ;
        ind33 = meangoalphas_new>=quantile(meangoalphas_new,2/3);
        ind31b = meangoalphas_new<quantile(meangoalphas_new,1/2);
        ind32b = meangoalphas_new>=quantile(meangoalphas_new,1/2);

        meananchphas_new = meananchphas(samp);
        ind41 = meananchphas_new<quantile(meananchphas_new,1/3);
        ind42 = meananchphas_new>=quantile(meananchphas_new,1/3) & meananchphas_new<quantile(meananchphas_new,2/3) ;
        ind43 = meananchphas_new>=quantile(meananchphas_new,2/3);
        ind41b = meananchphas_new<quantile(meananchphas_new,1/2);
        ind42b = meananchphas_new>=quantile(meananchphas_new,1/2);
        anchtype = anchtype_org(samp,:);
        anchans = anchans_org(samp,:);

        meanurnphas_new = meanurnphas(samp);
        ind51 = meanurnphas_new<quantile(meanurnphas_new,1/3);
        ind52 = meanurnphas_new>=quantile(meanurnphas_new,1/3) & meanurnphas_new<quantile(meanurnphas_new,2/3) ;
        ind53 = meanurnphas_new>=quantile(meanurnphas_new,2/3);
        ind51b = meanurnphas_new<quantile(meanurnphas_new,1/2);
        ind52b = meanurnphas_new>=quantile(meanurnphas_new,1/2);
        urntype = urntype_org(samp,:);
        urnans = urnans_org(samp,:);

        meancoinphas_new = meancoinphas(samp);
        ind61 = meancoinphas_new<quantile(meancoinphas_new,1/3);
        ind62 = meancoinphas_new>=quantile(meancoinphas_new,1/3) & meancoinphas_new<quantile(meancoinphas_new,2/3) ;
        ind63 = meancoinphas_new>=quantile(meancoinphas_new,2/3);
        ind61b = meancoinphas_new<quantile(meancoinphas_new,1/2);
        ind62b = meancoinphas_new>=quantile(meancoinphas_new,1/2);
        coinbeta = coinbeta_org(samp,:);

        N=1000;
        ord=[];
        res1 = nan(N,3);
        res2 = nan(N,3);
        res3 = nan(N,3);
        res4 = nan(N,3);
        res5 = nan(N,3);
        res6 = nan(N,3);
        res1b = nan(N,2);
        res2b = nan(N,2);
        res3b = nan(N,2);
        res4b = nan(N,2);
        res5b = nan(N,2);
        res6b = nan(N,2);
        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ord(i,:) = randperm(Nsub);

            ind1p(ord(i,ind11),i)=true; ind2p(ord(i,ind12),i)=true; ind3p(ord(i,ind13),i)=true;
            ind1pb(ord(i,ind11b),i)=true; ind2pb(ord(i,ind12b),i)=true;
        end

        for i=1:N
            X1 = [mean(mean(gambans(ind1p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind1p(:,i) & gambtype==2,:))) mean(mean(gambans(ind2p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind2p(:,i) & gambtype==2,:))) mean(mean(gambans(ind3p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind3p(:,i) & gambtype==2,:)))];
            X1 = [X1;mean(mean(beefans(ind1p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind1p(:,i) & beeftype==2,:))) mean(mean(beefans(ind2p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind2p(:,i) & beeftype==2,:))) mean(mean(beefans(ind3p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind3p(:,i) & beeftype==2,:)))];
            X1 = [X1;mean(mean(studans(ind1p(:,i) & studtype==1,:)))-mean(mean(studans(ind1p(:,i) & studtype==2,:))) mean(mean(studans(ind2p(:,i) & studtype==1,:)))-mean(mean(studans(ind2p(:,i) & studtype==2,:))) mean(mean(studans(ind3p(:,i) & studtype==1,:)))-mean(mean(studans(ind3p(:,i) & studtype==2,:)))];
            res1(i,:)=mean(X1);
            X1b = [mean(mean(gambans(ind1pb(:,i) & gambtype==1,:)))-mean(mean(gambans(ind1pb(:,i) & gambtype==2,:))) mean(mean(gambans(ind2pb(:,i) & gambtype==1,:)))-mean(mean(gambans(ind2pb(:,i) & gambtype==2,:)))];
            X1b = [X1b;mean(mean(beefans(ind1pb(:,i) & beeftype==1,:)))-mean(mean(beefans(ind1pb(:,i) & beeftype==2,:))) mean(mean(beefans(ind2pb(:,i) & beeftype==1,:)))-mean(mean(beefans(ind2pb(:,i) & beeftype==2,:)))];
            X1b = [X1b;mean(mean(studans(ind1pb(:,i) & studtype==1,:)))-mean(mean(studans(ind1pb(:,i) & studtype==2,:))) mean(mean(studans(ind2pb(:,i) & studtype==1,:)))-mean(mean(studans(ind2pb(:,i) & studtype==2,:)))];
            res1b(i,:)=mean(X1b);
        end
        X1 = [mean(mean(gambans(ind11 & gambtype==1,:),2))-mean(mean(gambans(ind11 & gambtype==2,:))) mean(mean(gambans(ind12 & gambtype==1,:)))-mean(mean(gambans(ind12 & gambtype==2,:))) mean(mean(gambans(ind13 & gambtype==1,:)))-mean(mean(gambans(ind13 & gambtype==2,:)))];
        X1 = [X1;mean(mean(beefans(ind11 & beeftype==1,:)))-mean(mean(beefans(ind11 & beeftype==2,:))) mean(mean(beefans(ind12 & beeftype==1,:)))-mean(mean(beefans(ind12 & beeftype==2,:))) mean(mean(beefans(ind13 & beeftype==1,:)))-mean(mean(beefans(ind13 & beeftype==2,:)))];
        X1 = [X1;mean(mean(studans(ind11 & studtype==1,:)))-mean(mean(studans(ind11 & studtype==2,:))) mean(mean(studans(ind12 & studtype==1,:)))-mean(mean(studans(ind12 & studtype==2,:))) mean(mean(studans(ind13 & studtype==1,:)))-mean(mean(studans(ind13 & studtype==2,:)))];
        X1 = mean(X1);
        X1 = (X1-min(min(res1)))./(max(max(res1))-min(min(res1)));   
        X1b = [mean(mean(gambans(ind11b & gambtype==1,:),2))-mean(mean(gambans(ind11b & gambtype==2,:))) mean(mean(gambans(ind12b & gambtype==1,:)))-mean(mean(gambans(ind12b & gambtype==2,:)))];
        X1b = [X1b;mean(mean(beefans(ind11b & beeftype==1,:)))-mean(mean(beefans(ind11b & beeftype==2,:))) mean(mean(beefans(ind12b & beeftype==1,:)))-mean(mean(beefans(ind12b & beeftype==2,:))) ];
        X1b = [X1b;mean(mean(studans(ind11b & studtype==1,:)))-mean(mean(studans(ind11b & studtype==2,:))) mean(mean(studans(ind12b & studtype==1,:)))-mean(mean(studans(ind12b & studtype==2,:))) ];
        X1b = mean(X1b);
        X1b = (X1b-min(min(res1b)))./(max(max(res1b))-min(min(res1b)));   


        res1 = (res1 - min(min(res1)))./(max(max(res1))-min(min(res1)));
        res1b = (res1b - min(min(res1b)))./(max(max(res1b))-min(min(res1b)));

        sum(res1(:)<(X1(1)))/N/3;   
        sum(res1(:)<(X1(2)))/N/3;    
        sum(res1(:)<(X1(3)))/N/3;

        sum(res1b(:)<(X1(1)))/N/2; 
        sum(res1b(:)<(X1(2)))/N/2;    

        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ind1p(ord(i,ind21),i)=true; ind2p(ord(i,ind22),i)=true; ind3p(ord(i,ind23),i)=true;
            ind1pb(ord(i,ind21b),i)=true; ind2pb(ord(i,ind22b),i)=true;
        end

        for j=1:N
            X2=[];
            X2b=[];
            for i=1:2
                X2 = [X2; -mean(optans(opttype(:,i)==1 & ind1p(:,j),i))+mean(optans(opttype(:,i)==2 & ind1p(:,j),i)) -mean(optans(opttype(:,i)==1 & ind2p(:,j),i))+mean(optans(opttype(:,i)==2 & ind2p(:,j),i)) -mean(optans(opttype(:,i)==1 & ind3p(:,j),i))+mean(optans(opttype(:,i)==2 & ind3p(:,j),i))];
                X2b = [X2b; -mean(optans(opttype(:,i)==1 & ind1pb(:,j),i))+mean(optans(opttype(:,i)==2 & ind1pb(:,j),i)) -mean(optans(opttype(:,i)==1 & ind2pb(:,j),i))+mean(optans(opttype(:,i)==2 & ind2pb(:,j),i))];
            end
            res2(j,:)=mean(X2);
            res2b(j,:)=mean(X2b);
        end
        X2=[];
        for i=1:2
            X2 = [X2; -mean(optans(opttype(:,i)==1 & ind21,i))+mean(optans(opttype(:,i)==2 & ind21,i)) -mean(optans(opttype(:,i)==1 & ind22,i))+mean(optans(opttype(:,i)==2 & ind22,i)) -mean(optans(opttype(:,i)==1 & ind23,i))+mean(optans(opttype(:,i)==2 & ind23,i))];
        end
        X2 = mean(X2);
        X2 = (X2-min(min(res2)))./(max(max(res2))-min(min(res2)));   
        res2 = (res2 - min(min(res2)))./(max(max(res2))-min(min(res2)));
        X2b=[];
        for i=1:2
            X2b = [X2b; -mean(optans(opttype(:,i)==1 & ind21b,i))+mean(optans(opttype(:,i)==2 & ind21b,i)) -mean(optans(opttype(:,i)==1 & ind22b,i))+mean(optans(opttype(:,i)==2 & ind22b,i)) ];
        end
        X2b = mean(X2b);
        X2b = (X2b-min(min(res2b)))./(max(max(res2b))-min(min(res2b)));   
        res2b = (res2b - min(min(res2b)))./(max(max(res2b))-min(min(res2b)));


        sum(res2(:)<(X2(1)))/N/3;   
        sum(res2(:)<(X2(2)))/N/3;    
        sum(res2(:)<(X2(3)))/N/3;

        sum(res2b(:)<(X2b(1)))/N/2; 
        sum(res2b(:)<(X2b(2)))/N/2;    



        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ind1p(ord(i,ind31),i)=true; ind2p(ord(i,ind32),i)=true; ind3p(ord(i,ind33),i)=true;
            ind1pb(ord(i,ind31b),i)=true; ind2pb(ord(i,ind32b),i)=true;
        end

        for j=1:N
            X3=[];
            X3b=[];
            for i=3:7
                X3 = [X3; (mean(optans(opttype(:,i)==1 & ind1p(:,j),i))+mean(optans(opttype(:,i)==2 & ind1p(:,j),i)))/2 (mean(optans(opttype(:,i)==1 & ind2p(:,j),i))+mean(optans(opttype(:,i)==2 & ind2p(:,j),i)))/2 (mean(optans(opttype(:,i)==1 & ind3p(:,j),i))+mean(optans(opttype(:,i)==2 & ind3p(:,j),i)))/2];
                X3b = [X3b; (mean(optans(opttype(:,i)==1 & ind1pb(:,j),i))+mean(optans(opttype(:,i)==2 & ind1pb(:,j),i)))/2 (mean(optans(opttype(:,i)==1 & ind2pb(:,j),i))+mean(optans(opttype(:,i)==2 & ind2pb(:,j),i)))/2];
            end
            res3(j,:)=mean(X3);
            res3b(j,:)=mean(X3b);
        end
        X3=[];
        for i=3:7
            X3 = [X3; (mean(optans(opttype(:,i)==1 & ind31,i))+mean(optans(opttype(:,i)==2 & ind31,i)))/2 (mean(optans(opttype(:,i)==1 & ind32,i))+mean(optans(opttype(:,i)==2 & ind32,i)))/2 (mean(optans(opttype(:,i)==1 & ind33,i))+mean(optans(opttype(:,i)==2 & ind33,i)))/2];
        end
        X3 = mean(X3);
        X3 = (X3-min(min(res3)))./(max(max(res3))-min(min(res3))); 
        res3 = (res3 - min(min(res3)))./(max(max(res3))-min(min(res3)));
        X3b=[];
        for i=3:7
            X3b = [X3b; (mean(optans(opttype(:,i)==1 & ind31b,i))+mean(optans(opttype(:,i)==2 & ind31b,i)))/2 (mean(optans(opttype(:,i)==1 & ind32b,i))+mean(optans(opttype(:,i)==2 & ind32b,i)))/2];
        end
        X3b = mean(X3b);
        X3b = (X3b-min(min(res3b)))./(max(max(res3b))-min(min(res3b)));   
        res3b = (res3b - min(min(res3b)))./(max(max(res3b))-min(min(res3b)));

        sum(res3(:)<(X3(1)))/N/3;   
        sum(res3(:)<(X3(2)))/N/3 ;   
        sum(res3(:)<(X3(3)))/N/3;

        sum(res3b(:)<(X3b(1)))/N/2; 
        sum(res3b(:)<(X3b(2)))/N/2;    

        % anchoring: normalize and check for outliers
        anchans = anchans-repmat(min(anchans),size(anchans,1),1);
        anchans = anchans./repmat(max(anchans),size(anchans,1),1);
        i=1;
        while i<=size(anchans,2)
            [mv, mi]=nanmax(anchans(:,i));
            if nanmax(anchans(setdiff(1:end,mi),i))<0.1
                anchans(mi,i)=nan;
                anchans(:,i) = anchans(:,i)./nanmax(anchans(:,i));
            else
                [mv, mi]=nanmin(anchans(:,i));
                if nanmin(anchans(setdiff(1:end,mi),i))>0.9
                    anchans(mi,i)=nan;
                    anchans(:,i) = anchans(:,i)-nanmin(anchans(:,i));
                    anchans(:,i) = anchans(:,i)./nanmax(anchans(:,i));
                else
                    i=i+1;
                end
            end
        end

        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ind1p(ord(i,ind41),i)=true; ind2p(ord(i,ind42),i)=true; ind3p(ord(i,ind43),i)=true;
            ind1pb(ord(i,ind41b),i)=true; ind2pb(ord(i,ind42b),i)=true;
        end

        for j=1:N
            X4 = [];
            X4b = [];
            for i = 1:7
                X4 = [X4 ;[nanmean(anchans(anchtype(:,i)==2 & ind1p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind1p(:,j),i))  nanmean(anchans(anchtype(:,i)==2 & ind2p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind2p(:,j),i)) nanmean(anchans(anchtype(:,i)==2 & ind3p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind3p(:,j),i))]];
                X4b = [X4b ;[nanmean(anchans(anchtype(:,i)==2 & ind1pb(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind1pb(:,j),i))  nanmean(anchans(anchtype(:,i)==2 & ind2pb(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind2pb(:,j),i))]];
            end
            res4(j,:)=mean(X4);
            res4b(j,:)=mean(X4b);
        end
        X4 = [];
        for i = 1:7
            X4 = [X4 ;[nanmean(anchans(anchtype(:,i)==2 & ind41,i))-nanmean(anchans(anchtype(:,i)==1 & ind41,i))  nanmean(anchans(anchtype(:,i)==2 & ind42,i))-nanmean(anchans(anchtype(:,i)==1 & ind42,i)) nanmean(anchans(anchtype(:,i)==2 & ind43,i))-nanmean(anchans(anchtype(:,i)==1 & ind43,i))]];
        end
        X4 =(mean(X4));
        X4 = (X4-min(min(res4)))./(max(max(res4))-min(min(res4)));   
        res4 = (res4 - min(min(res4)))./(max(max(res4))-min(min(res4)));
        X4b = [];
        for i = 1:7
            X4b = [X4b ;[nanmean(anchans(anchtype(:,i)==2 & ind41b,i))-nanmean(anchans(anchtype(:,i)==1 & ind41b,i))  nanmean(anchans(anchtype(:,i)==2 & ind42b,i))-nanmean(anchans(anchtype(:,i)==1 & ind42b,i)) ]];
        end
        X4b =(mean(X4b));
        X4b = (X4b-min(min(res4b)))./(max(max(res4b))-min(min(res4b)));   
        res4b = (res4b - min(min(res4b)))./(max(max(res4b))-min(min(res4b)));


        sum(res4(:)<(X4(1)))/N/3;   
        sum(res4(:)<(X4(2)))/N/3;    
        sum(res4(:)<(X4(3)))/N/3;

        sum(res4b(:)<(X4b(1)))/N/2;  
        sum(res4b(:)<(X4b(2)))/N/2;    



        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ind1p(ord(i,ind51),i)=true; ind2p(ord(i,ind52),i)=true; ind3p(ord(i,ind53),i)=true;
            ind1pb(ord(i,ind51b),i)=true; ind2pb(ord(i,ind52b),i)=true;
        end

        for j=1:N
            X5a =[(nanmean(nanmean([urnans(urntype==2 & ind1p(:,j),6:end);-urnans(urntype==1 & ind1p(:,j),6:end)])'))];
            X5a =[X5a (nanmean(nanmean([urnans(urntype==2 & ind2p(:,j),6:end);-urnans(urntype==1 & ind2p(:,j),6:end)])'))];
            X5a =[X5a (nanmean(nanmean([urnans(urntype==2 & ind3p(:,j),6:end);-urnans(urntype==1 & ind3p(:,j),6:end)])'))];
            X5b =[(nanmean(nanmean([urnans(urntype==2 & ind1p(:,j),1:6);-urnans(urntype==1 & ind1p(:,j),1:6)])'))];
            X5b =[X5b (nanmean(nanmean([urnans(urntype==2 & ind2p(:,j),1:6);-urnans(urntype==1 & ind2p(:,j),1:6)])'))];
            X5b =[X5b (nanmean(nanmean([urnans(urntype==2 & ind3p(:,j),1:6);-urnans(urntype==1 & ind3p(:,j),1:6)])'))];
            res5(j,:)=(X5a)./X5b;
            res5(j,:)=(X5a);
            X5ba =[(nanmean(nanmean([urnans(urntype==2 & ind1pb(:,j),6:end);-urnans(urntype==1 & ind1pb(:,j),6:end)])'))];
            X5ba =[X5ba (nanmean(nanmean([urnans(urntype==2 & ind2pb(:,j),6:end);-urnans(urntype==1 & ind2pb(:,j),6:end)])'))];
            X5bb =[(nanmean(nanmean([urnans(urntype==2 & ind1pb(:,j),1:6);-urnans(urntype==1 & ind1pb(:,j),1:6)])'))];
            X5bb =[X5bb (nanmean(nanmean([urnans(urntype==2 & ind2pb(:,j),1:6);-urnans(urntype==1 & ind2pb(:,j),1:6)])'))];
            res5b(j,:)=(X5ba)./X5bb;
        end
        X5a =[(mean(mean([urnans(urntype==2 & ind51,6:end);-urnans(urntype==1 & ind51,6:end)])'))];
        X5a =[X5a (mean(mean([urnans(urntype==2 & ind52,6:end);-urnans(urntype==1 & ind52,6:end)])'))];
        X5a =[X5a (mean(mean([urnans(urntype==2 & ind53,6:end);-urnans(urntype==1 & ind53,6:end)])'))];
        X5b =[(mean(mean([urnans(urntype==2 & ind51,1:6);-urnans(urntype==1 & ind51,1:6)])'))];
        X5b =[X5b (mean(mean([urnans(urntype==2 & ind52,1:6);-urnans(urntype==1 & ind52,1:6)])'))];
        X5b =[X5b (mean(mean([urnans(urntype==2 & ind53,1:6);-urnans(urntype==1 & ind53,1:6)])'))];
        X5=((X5a)./X5b);
        X5=((X5a));
        X5 = (X5-min(min(res5)))./(max(max(res5))-min(min(res5)));   
        res5 = (res5 - min(min(res5)))./(max(max(res5))-min(min(res5)));
        X5ba =[(mean(mean([urnans(urntype==2 & ind51b,6:end);-urnans(urntype==1 & ind51b,6:end)])'))];
        X5ba =[X5ba (mean(mean([urnans(urntype==2 & ind52b,6:end);-urnans(urntype==1 & ind52b,6:end)])'))];
        X5bb =[(mean(mean([urnans(urntype==2 & ind51b,1:6);-urnans(urntype==1 & ind51b,1:6)])'))];
        X5bb =[X5bb (mean(mean([urnans(urntype==2 & ind52b,1:6);-urnans(urntype==1 & ind52b,1:6)])'))];
        X5b=((X5ba)./X5bb);
        X5b = (X5b-min(min(res5b)))./(max(max(res5b))-min(min(res5b)));   
        res5b = (res5b - min(min(res5b)))./(max(max(res5b))-min(min(res5b)));


        sum(res5(:)<(X5(1)))/N/3  ;
        sum(res5(:)<(X5(2)))/N/3  ;
        sum(res5(:)<(X5(3)))/N/3;

        sum(res5b(:)<(X5b(1)))/N/2  ; 
        sum(res5b(:)<(X5b(2)))/N/2;   

        ind1p = false(Nsub,N);
        ind2p = false(Nsub,N);
        ind3p = false(Nsub,N);
        ind1pb = false(Nsub,N);
        ind2pb = false(Nsub,N);
        for i=1:N
            ind1p(ord(i,ind61),i)=true; ind2p(ord(i,ind62),i)=true; ind3p(ord(i,ind63),i)=true;
            ind1pb(ord(i,ind61b),i)=true; ind2pb(ord(i,ind62b),i)=true;
        end

        for j=1:N
            X6 = [nanmean(coinbeta(ind1p(:,j))) nanmean(coinbeta(ind2p(:,j))) nanmean(coinbeta(ind3p(:,j)))];
            X6b = [nanmean(coinbeta(ind1pb(:,j))) nanmean(coinbeta(ind2pb(:,j)))];
            res6(j,:)=X6;
            res6b(j,:)=X6b;
        end
        X6 = [mean(coinbeta(ind61,1)) mean(coinbeta(ind62,1)) mean(coinbeta(ind63,1))];
        X6 = (X6-min(min(res6)))./(max(max(res6))-min(min(res6)));   
        res6 = (res6 - min(min(res6)))./(max(max(res6))-min(min(res6)));
        X6b = [mean(coinbeta(ind61b,1)) mean(coinbeta(ind62b,1))];
        X6b = (X6b-min(min(res6b)))./(max(max(res6b))-min(min(res6b)));   
        res6b = (res6b - min(min(res6b)))./(max(max(res6b))-min(min(res6b)));


        sum(res6(:)>(X6(1)))/N/3; 
        sum(res6(:)>(X6(2)))/N/3;  
        sum(res6(:)>(X6(3)))/N/3;

        sum(res6b(:)>(X6b(1)))/N/2; 
        sum(res6b(:)>(X6b(2)))/N/2;   

        P2 = sum(mean([res1(:,2) res2(:,2) res3(:,2) res4(:,2) res5(:,2) res6(:,2)],2)>mean([X1(2) X2(2) X3(2) X4(2) X5(2) X6(2)]))/N*2;
        P1 = sum(mean([res1(:,1) res2(:,1) res3(:,1) res4(:,1) res5(:,1) res6(:,1)],2)<mean([X1(1) X2(1) X3(1) X4(1) X5(1) X6(1)]))/N*2;
        P3 = sum(mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)>mean([X1(3) X2(3) X3(3) X4(3) X5(3) X6(3)]))/N*2;
        P31= sum(mean([mean([res1(:,3) res2(:,3) res3(:,3)],2) res4(:,3) res5(:,3) res6(:,3)],2)-mean([mean([res1(:,1) res2(:,1) res3(:,1)],2) res4(:,1) res5(:,1) res6(:,1)],2)>mean([mean([X1(3) X2(3) X3(3)]) X4(3) X5(3) X6(3)])-mean([mean([X1(1) X2(1) X3(1)]) X4(1) X5(1) X6(1)]))/N*2;
        P21= sum(mean([mean([res1(:,2) res2(:,2) res3(:,2)],2) res4(:,2) res5(:,2) res6(:,2)],2)-mean([mean([res1(:,1) res2(:,1) res3(:,1)],2) res4(:,1) res5(:,1) res6(:,1)],2)>mean([mean([X1(2) X2(2) X3(2)]) X4(2) X5(2) X6(2)])-mean([mean([X1(1) X2(1) X3(1)]) X4(1) X5(1) X6(1)]))/N*2;
        P32= sum(mean([mean([res1(:,3) res2(:,3) res3(:,3)],2) res4(:,3) res5(:,3) res6(:,3)],2)-mean([mean([res1(:,2) res2(:,2) res3(:,2)],2) res4(:,2) res5(:,2) res6(:,2)],2)>mean([mean([X1(3) X2(3) X3(3)]) X4(3) X5(3) X6(3)])-mean([mean([X1(2) X2(2) X3(2)]) X4(2) X5(2) X6(2)]))/N*2;
        sum(mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)-mean([res1(:,1:2) res2(:,1:2) res3(:,1:2) res4(:,1:2) res5(:,1:2) res6(:,1:2)],2)>mean([X1(3) X2(3) X3(3) X4(3) X5(3) X6(3)])-mean([X1(1:2) X2(1:2) X3(1:2) X4(1:2) X5(1:2) X6(1:2)]))/N;
        SD = mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)-mean([res1(:,1) res2(:,1) res3(:,1) res4(:,1) res5(:,1) res6(:,1)],2);
        SD = sort(SD);
        SD = SD(round(length(SD)*97.5/100));

        P2b = sum(mean([res1b(:,2) res2b(:,2) res3b(:,2) res4b(:,2) res5b(:,2) res6b(:,2)],2)>mean([X1b(2) X2b(2) X3b(2) X4b(2) X5b(2) X6b(2)]))/N*2;
        P1b = sum(mean([res1b(:,1) res2b(:,1) res3b(:,1) res4b(:,1) res5b(:,1) res6b(:,1)],2)<mean([X1b(1) X2b(1) X3b(1) X4b(1) X5b(1) X6b(1)]))/N*2;
        P12b = sum(mean([res1b(:,1) res2b(:,1) res3b(:,1) res4b(:,1) res5b(:,1) res6b(:,1)],2)-mean([res1b(:,2) res2b(:,2) res3b(:,2) res4b(:,2) res5b(:,2) res6b(:,2)],2)<mean([X1b(1) X2b(1) X3b(1) X4b(1) X5b(1) X6b(1)])-mean([X1b(2) X2b(2) X3b(2) X4b(2) X5b(2) X6b(2)]))/N*2;
        SDb = mean([res1b(:,1) res2b(:,1) res3b(:,1) res4b(:,1) res5b(:,1) res6b(:,1)],2)-mean([res1b(:,2) res2b(:,2) res3b(:,2) res4b(:,2) res5b(:,2) res6b(:,2)],2);
        SDb = sort(SDb);
        SDb = SDb(round(length(SDb)*97.5/100));

        pboot1(rep,1) = nanmean(res1(:,3)-res1(:,1)>(X1(3)-X1(1)));
        pboot2(rep,1) = nanmean(res2(:,3)-res2(:,1)>(X2(3)-X2(1)));
        pboot3(rep,1) = nanmean(res3(:,3)-res3(:,1)>(X3(3)-X3(1)));
        pboot4(rep,1) = nanmean(res4(:,3)-res4(:,1)>(X4(3)-X4(1)));
        pboot5(rep,1) = nanmean(res5(:,3)-res5(:,1)>(X5(3)-X5(1)));
        pboot6(rep,1) = nanmean(res6(:,3)-res6(:,1)>(X6(3)-X6(1)));

        pboot1_nom(rep,1) = X1(3)-X1(1)>0;
        pboot2_nom(rep,1) = X2(3)-X2(1)>0;
        pboot3_nom(rep,1) = X3(3)-X3(1)>0;
        pboot4_nom(rep,1) = X4(3)-X4(1)>0;
        pboot5_nom(rep,1) = X5(3)-X5(1)>0;
        pboot6_nom(rep,1) = X6(3)-X6(1)>0;


        pboot31(rep,1) = P31;
        pboot32(rep,1) = P32;
        pboot21(rep,1) = P21;
    end

    pnum = (pboot1<0.05)*1+(pboot2<0.05)*1+(pboot3<0.05)*1+(pboot4<0.05)*1+(pboot5<0.05)*1+(pboot6<0.05)*1;
    pnum_n = (pboot1>0.95)*1+(pboot2>0.95)*1+(pboot3>0.95)*1+(pboot4>0.95)*1+(pboot5>0.95)*1+(pboot6>0.95)*1;
    pnum_nom = pboot1_nom*1+pboot2_nom*1+pboot3_nom*1+pboot4_nom*1+pboot5_nom*1+pboot6_nom*1;
    pall1 = (pboot31<0.05 & pboot32<1.95 & pboot21<1.95);
    pall2 = (pboot31<0.05 & pboot32<1.95) & (pboot21<1) & (pboot32<1);
    pall3 = (pboot31<0.05 & pboot32<1.95) & (pboot21<1) & (pboot32<1) & (pboot21<0.05 | pboot32<0.05);
    pall4 = (pboot31<0.05 & pboot32<1.95) & (pboot21<0.05 | pboot32<0.05);
    save(sprintf('randomization_power_%d',Nsub),'pboot1','pboot2','pboot3','pboot4','pboot5','pboot6','pboot1_nom','pboot2_nom','pboot3_nom','pboot4_nom','pboot5_nom','pboot6_nom','pboot31','pboot32','pboot21','pnum','pall1','pall2','pall3','pall4','pnum_nom');

end