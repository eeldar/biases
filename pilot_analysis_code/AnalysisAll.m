% Analysis of participants' biases and pupil responses
%
%   USAGE:  AnalysisAll
%   OUTPUT: - Figure showing participants' biases on each task, and across
%             all tasks, as a function of pupil responses tercile
%           - Figure showing pupil response timecourse for each task
%

pathname = fullfile(fileparts(pwd),'pilot_data');
file = dir(fullfile(pathname, ['S*']));

for sub=1:length(file);
    [anchans(sub,:), anchtype(sub,:), anchphas(sub,:), anchokeye(sub,:), coinbeta(sub,:), coinphas(sub,:), coinokeye(sub,:), gambans(sub,:), gambtype(sub,:), gambphas(sub,:), gambokeye(sub,:), beefans(sub,:), beeftype(sub,:), beefphas(sub,:), studans(sub,:), studtype(sub,:), studphas(sub,:), optans(sub,:), opttype(sub,:), optphas(sub,:), urnans(sub,:), urntype(sub,:), urnphas(sub,:), urnokeye(sub,:), corrphasbase(sub,:), meanpuptc(sub,:,:)] = Analysis(sub);
end

% anchoring: normalize and check for outliers
anchans([23 29 31],:) = nan; %artifacts
anchans = anchans-repmat(nanmin(anchans),size(anchans,1),1);
anchans = anchans./repmat(nanmax(anchans),size(anchans,1),1);
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

meananchphas = nanmean(anchphas,2);
meananchphas(sum(anchokeye>0,2)<2)=nan;
meananchphas([23 29 31]) = nan; % artifacts
ind41 = meananchphas<quantile(meananchphas,1/3);
ind42 = meananchphas>=quantile(meananchphas,1/3) & meananchphas<quantile(meananchphas,2/3) ;
ind43 = meananchphas>=quantile(meananchphas,2/3);
ind41b = meananchphas<quantile(meananchphas,1/2);
ind42b = meananchphas>=quantile(meananchphas,1/2);

meanattphas = nanmean([gambphas beefphas studphas],2);
meanattphas(sum(~isnan([gambphas beefphas studphas]),2)<2)=nan;
ind11 = meanattphas<quantile(meanattphas,1/3);
ind12 = meanattphas>=quantile(meanattphas,1/3) & meanattphas<quantile(meanattphas,2/3) ;
ind13 = meanattphas>=quantile(meanattphas,2/3);
ind11b = meanattphas<quantile(meanattphas,1/2);
ind12b = meanattphas>=quantile(meanattphas,1/2);

meanriskphas = nanmean(optphas(:,1:2),2);
meanriskphas(sum(~isnan(optphas(:,1:2)),2)<1)=nan;
ind21 = meanriskphas<quantile(meanriskphas,1/3);
ind22 = meanriskphas>=quantile(meanriskphas,1/3) & meanriskphas<quantile(meanriskphas,2/3) ;
ind23 = meanriskphas>=quantile(meanriskphas,2/3);
ind21b = meanriskphas<quantile(meanriskphas,1/2);
ind22b = meanriskphas>=quantile(meanriskphas,1/2);

meangoalphas = nanmean(optphas(:,3:7),2);
meangoalphas(sum(~isnan(optphas(:,3:7)),2)<2)=nan;
ind31 = meangoalphas<quantile(meangoalphas,1/3);
ind32 = meangoalphas>=quantile(meangoalphas,1/3) & meangoalphas<quantile(meangoalphas,2/3) ;
ind33 = meangoalphas>=quantile(meangoalphas,2/3);
ind31b = meangoalphas<quantile(meangoalphas,1/2);
ind32b = meangoalphas>=quantile(meangoalphas,1/2);

urnans([13 21 26 31],:)=nan;
meanurnphas = urnphas;
meanurnphas(urnokeye<2)=nan;
meanurnphas([13 21 26 31])=nan;
ind51 = meanurnphas<quantile(meanurnphas,1/3);
ind52 = meanurnphas>=quantile(meanurnphas,1/3) & meanurnphas<quantile(meanurnphas,2/3) ;
ind53 = meanurnphas>=quantile(meanurnphas,2/3);
ind51b = meanurnphas<quantile(meanurnphas,1/2);
ind52b = meanurnphas>=quantile(meanurnphas,1/2);

coinbeta([2 3 5 11 13 21 37],:)=nan;
meancoinphas = coinphas;
meancoinphas(coinokeye<2)=nan;
meancoinphas([2 3 5 11 13 21 37],:)=nan;
ind61 = meancoinphas<quantile(meancoinphas,1/3);
ind62 = meancoinphas>=quantile(meancoinphas,1/3) & meancoinphas<quantile(meancoinphas,2/3) ;
ind63 = meancoinphas>=quantile(meancoinphas,2/3);
ind61b = meancoinphas<quantile(meancoinphas,1/2);
ind62b = meancoinphas>=quantile(meancoinphas,1/2);



%% Permutation test
N=10000;
ord=[];
res1 = nan(N,3);
res2 = nan(N,3);
res3 = nan(N,3);
res4 = nan(N,3);
res5 = nan(N,3);
res6 = nan(N,3);
ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
ind1pb = false(length(ind11),N);
ind2pb = false(length(ind11),N);
for i=1:N
    ord(i,:) = randperm(length(ind11));

    ind1p(ord(i,ind11),i)=true; ind2p(ord(i,ind12),i)=true; ind3p(ord(i,ind13),i)=true;
    ind1pb(ord(i,ind11b),i)=true; ind2pb(ord(i,ind12b),i)=true;
end

for i=1:N
    X1 = [mean(mean(gambans(ind1p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind1p(:,i) & gambtype==2,:))) mean(mean(gambans(ind2p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind2p(:,i) & gambtype==2,:))) mean(mean(gambans(ind3p(:,i) & gambtype==1,:)))-mean(mean(gambans(ind3p(:,i) & gambtype==2,:)))];
    X1 = [X1;mean(mean(beefans(ind1p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind1p(:,i) & beeftype==2,:))) mean(mean(beefans(ind2p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind2p(:,i) & beeftype==2,:))) mean(mean(beefans(ind3p(:,i) & beeftype==1,:)))-mean(mean(beefans(ind3p(:,i) & beeftype==2,:)))];
    X1 = [X1;mean(mean(studans(ind1p(:,i) & studtype==1,:)))-mean(mean(studans(ind1p(:,i) & studtype==2,:))) mean(mean(studans(ind2p(:,i) & studtype==1,:)))-mean(mean(studans(ind2p(:,i) & studtype==2,:))) mean(mean(studans(ind3p(:,i) & studtype==1,:)))-mean(mean(studans(ind3p(:,i) & studtype==2,:)))];
    res1(i,:)=mean(X1);
end
X1 = [mean(mean(gambans(ind11 & gambtype==1,:),2))-mean(mean(gambans(ind11 & gambtype==2,:))) mean(mean(gambans(ind12 & gambtype==1,:)))-mean(mean(gambans(ind12 & gambtype==2,:))) mean(mean(gambans(ind13 & gambtype==1,:)))-mean(mean(gambans(ind13 & gambtype==2,:)))];
X1 = [X1;mean(mean(beefans(ind11 & beeftype==1,:)))-mean(mean(beefans(ind11 & beeftype==2,:))) mean(mean(beefans(ind12 & beeftype==1,:)))-mean(mean(beefans(ind12 & beeftype==2,:))) mean(mean(beefans(ind13 & beeftype==1,:)))-mean(mean(beefans(ind13 & beeftype==2,:)))];
X1 = [X1;mean(mean(studans(ind11 & studtype==1,:)))-mean(mean(studans(ind11 & studtype==2,:))) mean(mean(studans(ind12 & studtype==1,:)))-mean(mean(studans(ind12 & studtype==2,:))) mean(mean(studans(ind13 & studtype==1,:)))-mean(mean(studans(ind13 & studtype==2,:)))];
X1 = mean(X1);
X1 = (X1-min(min(res1)))./(max(max(res1))-min(min(res1)))   

clear Y1
Y1(ind11,1)=mean(gambans(ind11,:),2)-mean(mean(gambans(ind11,:),2));
Y1(ind12,1)=mean(gambans(ind12,:),2)-mean(mean(gambans(ind12,:),2));
Y1(ind13,1)=mean(gambans(ind13,:),2)-mean(mean(gambans(ind13,:),2));
Y1(ind11,2)=mean(beefans(ind11,:),2)-mean(mean(beefans(ind11,:),2));
Y1(ind12,2)=mean(beefans(ind12,:),2)-mean(mean(beefans(ind12,:),2));
Y1(ind13,2)=mean(beefans(ind13,:),2)-mean(mean(beefans(ind13,:),2));
Y1(ind11,3)=mean(studans(ind11,:),2)-mean(mean(studans(ind11,:),2));
Y1(ind12,3)=mean(studans(ind12,:),2)-mean(mean(studans(ind12,:),2));
Y1(ind13,3)=mean(studans(ind13,:),2)-mean(mean(studans(ind13,:),2));
Ytype = [gambtype beeftype studtype];
for i=1:length(gambphas)
    Y1(i,:) = mean([Y1(i,Ytype(i,:)==1) -Y1(i,Ytype(i,:)==2)]);
end
Y1=Y1(:,1)./100;
E1 = [std(Y1(ind11))/sqrt(sum(ind11)) std(Y1(ind12))/sqrt(sum(ind12)) std(Y1(ind13))/sqrt(sum(ind13))];
Y1 = [ mean(Y1(ind11)) mean(Y1(ind12)) mean(Y1(ind13))]

res1 = (res1 - min(min(res1)))./(max(max(res1))-min(min(res1)));

sum(res1(:)<(X1(1)))/N/3   
sum(res1(:)<(X1(2)))/N/3    
sum(res1(:)<(X1(3)))/N/3

ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
for i=1:N
    ind1p(ord(i,ind21),i)=true; ind2p(ord(i,ind22),i)=true; ind3p(ord(i,ind23),i)=true;
end

for j=1:N
    X2=[];
    for i=1:2
        X2 = [X2; -mean(optans(opttype(:,i)==1 & ind1p(:,j),i))+mean(optans(opttype(:,i)==2 & ind1p(:,j),i)) -mean(optans(opttype(:,i)==1 & ind2p(:,j),i))+mean(optans(opttype(:,i)==2 & ind2p(:,j),i)) -mean(optans(opttype(:,i)==1 & ind3p(:,j),i))+mean(optans(opttype(:,i)==2 & ind3p(:,j),i))];
    end
    res2(j,:)=mean(X2);
end
X2=[];
for i=1:2
    X2 = [X2; -mean(optans(opttype(:,i)==1 & ind21,i))+mean(optans(opttype(:,i)==2 & ind21,i)) -mean(optans(opttype(:,i)==1 & ind22,i))+mean(optans(opttype(:,i)==2 & ind22,i)) -mean(optans(opttype(:,i)==1 & ind23,i))+mean(optans(opttype(:,i)==2 & ind23,i))];
end
X2 = mean(X2);
X2 = (X2-min(min(res2)))./(max(max(res2))-min(min(res2)))   
res2 = (res2 - min(min(res2)))./(max(max(res2))-min(min(res2)));

clear Y2
Y2(ind21,:)=(optans(ind21,1:2))-repmat(mean(optans(ind21,1:2)),sum(ind21),1);
Y2(ind22,:)=(optans(ind22,1:2))-repmat(mean(optans(ind22,1:2)),sum(ind22),1);
Y2(ind23,:)=(optans(ind23,1:2))-repmat(mean(optans(ind23,1:2)),sum(ind23),1);
Ytype = opttype(:,1:2);
for i=1:size(Y2,1)
    if Ytype(i,:)==1
        Y2(i,:) = -mean(Y2(i,:));
    else
        Y2(i,:) = mean(Y2(i,:));
    end
end
Y2=Y2(:,1)./100; 
E2 = [std(Y2(ind21))/sqrt(sum(ind21)) std(Y2(ind22))/sqrt(sum(ind22)) std(Y2(ind23))/sqrt(sum(ind23))];
Y2 = [ mean(Y2(ind21)) mean(Y2(ind22)) mean(Y2(ind23))]

sum(res2(:)<(X2(1)))/N/3   
sum(res2(:)<(X2(2)))/N/3    
sum(res2(:)<(X2(3)))/N/3

ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
for i=1:N
    ind1p(ord(i,ind31),i)=true; ind2p(ord(i,ind32),i)=true; ind3p(ord(i,ind33),i)=true;
end

for j=1:N
    X3=[];
    for i=3:7
        X3 = [X3; (mean(optans(opttype(:,i)==1 & ind1p(:,j),i))+mean(optans(opttype(:,i)==2 & ind1p(:,j),i)))/2 (mean(optans(opttype(:,i)==1 & ind2p(:,j),i))+mean(optans(opttype(:,i)==2 & ind2p(:,j),i)))/2 (mean(optans(opttype(:,i)==1 & ind3p(:,j),i))+mean(optans(opttype(:,i)==2 & ind3p(:,j),i)))/2];
    end
    res3(j,:)=mean(X3);
end
X3=[];
for i=3:7
    X3 = [X3; (mean(optans(opttype(:,i)==1 & ind31,i))+mean(optans(opttype(:,i)==2 & ind31,i)))/2 (mean(optans(opttype(:,i)==1 & ind32,i))+mean(optans(opttype(:,i)==2 & ind32,i)))/2 (mean(optans(opttype(:,i)==1 & ind33,i))+mean(optans(opttype(:,i)==2 & ind33,i)))/2];
end
X3 = mean(X3);
X3 = (X3-min(min(res3)))./(max(max(res3))-min(min(res3))) 
res3 = (res3 - min(min(res3)))./(max(max(res3))-min(min(res3)));

sum(res3(:)<(X3(1)))/N/3   
sum(res3(:)<(X3(2)))/N/3    
sum(res3(:)<(X3(3)))/N/3

clear Y3
Y3(ind31,:)=(optans(ind31,3:7));
Y3(ind32,:)=(optans(ind32,3:7));
Y3(ind33,:)=(optans(ind33,3:7));
Ytype = opttype(:,3:7);
for i=1:size(Y3,1)
    Y3(i,:) = mean(Y3(i,:));
end
Y3=Y3(:,1)./50;
E3 = [std(Y3(ind31))/sqrt(sum(ind31)) std(Y3(ind32))/sqrt(sum(ind32)) std(Y3(ind33))/sqrt(sum(ind33))];
Y3 = [ mean(Y3(ind31)) mean(Y3(ind32)) mean(Y3(ind33))]

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

ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
for i=1:N
    ind1p(ord(i,ind41),i)=true; ind2p(ord(i,ind42),i)=true; ind3p(ord(i,ind43),i)=true;
end

for j=1:N
    X4 = [];
    for i = 1:7
        X4 = [X4 ;[nanmean(anchans(anchtype(:,i)==2 & ind1p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind1p(:,j),i))  nanmean(anchans(anchtype(:,i)==2 & ind2p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind2p(:,j),i)) nanmean(anchans(anchtype(:,i)==2 & ind3p(:,j),i))-nanmean(anchans(anchtype(:,i)==1 & ind3p(:,j),i))]];
    end
    res4(j,:)=mean(X4);
end
X4 = [];
for i = 1:7
    X4 = [X4 ;[nanmean(anchans(anchtype(:,i)==2 & ind41,i))-nanmean(anchans(anchtype(:,i)==1 & ind41,i))  nanmean(anchans(anchtype(:,i)==2 & ind42,i))-nanmean(anchans(anchtype(:,i)==1 & ind42,i)) nanmean(anchans(anchtype(:,i)==2 & ind43,i))-nanmean(anchans(anchtype(:,i)==1 & ind43,i))]];
end
X4 =(mean(X4));
X4 = (X4-min(min(res4)))./(max(max(res4))-min(min(res4)))   
res4 = (res4 - min(min(res4)))./(max(max(res4))-min(min(res4)));

clear Y4
Y4(ind41,:)=(anchans(ind41,:))-repmat(nanmean(anchans(ind41,:)),sum(ind41),1);
Y4(ind42,:)=(anchans(ind42,:))-repmat(nanmean(anchans(ind42,:)),sum(ind42),1);
Y4(ind43,:)=(anchans(ind43,:))-repmat(nanmean(anchans(ind43,:)),sum(ind43),1);
Ytype = anchtype;
for i=1:size(Y4,1)
    Y4(i,:) = nanmean([Y4(i,Ytype(i,:)==2) -Y4(i,Ytype(i,:)==1)]);
end
Y4=Y4(:,1);
E4 = [std(Y4(ind41))/sqrt(sum(ind41)) std(Y4(ind42))/sqrt(sum(ind42)) std(Y4(ind43))/sqrt(sum(ind43))];
Y4 = [ mean(Y4(ind41)) mean(Y4(ind42)) mean(Y4(ind43))]

sum(res4(:)<(X4(1)))/N/3   
sum(res4(:)<(X4(2)))/N/3    
sum(res4(:)<(X4(3)))/N/3

ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
for i=1:N
    ind1p(ord(i,ind51),i)=true; ind2p(ord(i,ind52),i)=true; ind3p(ord(i,ind53),i)=true;
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
end
X5a =[(mean(mean([urnans(urntype==2 & ind51,6:end);-urnans(urntype==1 & ind51,6:end)])'))];
X5a =[X5a (mean(mean([urnans(urntype==2 & ind52,6:end);-urnans(urntype==1 & ind52,6:end)])'))];
X5a =[X5a (mean(mean([urnans(urntype==2 & ind53,6:end);-urnans(urntype==1 & ind53,6:end)])'))];
X5b =[(mean(mean([urnans(urntype==2 & ind51,1:6);-urnans(urntype==1 & ind51,1:6)])'))];
X5b =[X5b (mean(mean([urnans(urntype==2 & ind52,1:6);-urnans(urntype==1 & ind52,1:6)])'))];
X5b =[X5b (mean(mean([urnans(urntype==2 & ind53,1:6);-urnans(urntype==1 & ind53,1:6)])'))];
X5=((X5a)./X5b);
X5=((X5a));
X5 = (X5-min(min(res5)))./(max(max(res5))-min(min(res5)))   
res5 = (res5 - min(min(res5)))./(max(max(res5))-min(min(res5)));

clear Y5
Y5(ind51,:)=mean(urnans(ind51,6:end),2);%./[(mean(mean([urnans(urntype==2 & ind51,1:6);-urnans(urntype==1 & ind51,1:6)])'))];
Y5(ind52,:)=mean(urnans(ind52,6:end),2);%./[(mean(mean([urnans(urntype==2 & ind52,1:6);-urnans(urntype==1 & ind52,1:6)])'))];
Y5(ind53,:)=mean(urnans(ind53,6:end),2);%./[(mean(mean([urnans(urntype==2 & ind53,1:6);-urnans(urntype==1 & ind53,1:6)])'))];
Ytype = urntype;
Y5(Ytype==1)=-Y5(Ytype==1);
Y5 = Y5/50; 
E5 = [std(Y5(ind51))/sqrt(sum(ind51)) std(Y5(ind52))/sqrt(sum(ind52)) std(Y5(ind53))/sqrt(sum(ind53))];
Y5 = [ mean(Y5(ind51)) mean(Y5(ind52)) mean(Y5(ind53))]

sum(res5(:)<(X5(1)))/N/3  
sum(res5(:)<(X5(2)))/N/3  
sum(res5(:)<(X5(3)))/N/3

ind1p = false(length(ind11),N);
ind2p = false(length(ind11),N);
ind3p = false(length(ind11),N);
for i=1:N
    ind1p(ord(i,ind61),i)=true; ind2p(ord(i,ind62),i)=true; ind3p(ord(i,ind63),i)=true;
end

for j=1:N
    X6 = [nanmean(coinbeta(ind1p(:,j))) nanmean(coinbeta(ind2p(:,j))) nanmean(coinbeta(ind3p(:,j)))];
    res6(j,:)=X6;
end
X6 = [mean(coinbeta(ind61,1)) mean(coinbeta(ind62,1)) mean(coinbeta(ind63,1))];
X6 = (X6-min(min(res6)))./(max(max(res6))-min(min(res6)))   
res6 = (res6 - min(min(res6)))./(max(max(res6))-min(min(res6)));

clear Y6
Y6(ind61) = coinbeta(ind61,1); 
Y6(ind62) = coinbeta(ind62,1); 
Y6(ind63) = coinbeta(ind63,1); 
E6 = [nanstd(Y6(ind61))/sqrt(sum(ind61)) nanstd(Y6(ind62))/sqrt(sum(ind62)) nanstd(Y6(ind63))/sqrt(sum(ind63))];
Y6 = [ mean(Y6(ind61)) mean(Y6(ind62)) mean(Y6(ind63))]

sum(res6(:)>(X6(1)))/N/3 
sum(res6(:)>(X6(2)))/N/3  
sum(res6(:)>(X6(3)))/N/3

P2 = sum(mean([res1(:,2) res2(:,2) res3(:,2) res4(:,2) res5(:,2) res6(:,2)],2)>mean([X1(2) X2(2) X3(2) X4(2) X5(2) X6(2)]))/N*2
P1 = sum(mean([res1(:,1) res2(:,1) res3(:,1) res4(:,1) res5(:,1) res6(:,1)],2)<mean([X1(1) X2(1) X3(1) X4(1) X5(1) X6(1)]))/N*2
P3 = sum(mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)>mean([X1(3) X2(3) X3(3) X4(3) X5(3) X6(3)]))/N*2
P31= sum(mean([mean([res1(:,3) res2(:,3) res3(:,3)],2) res4(:,3) res5(:,3) res6(:,3)],2)-mean([mean([res1(:,1) res2(:,1) res3(:,1)],2) res4(:,1) res5(:,1) res6(:,1)],2)>mean([mean([X1(3) X2(3) X3(3)]) X4(3) X5(3) X6(3)])-mean([mean([X1(1) X2(1) X3(1)]) X4(1) X5(1) X6(1)]))/N*2
P21= sum(mean([mean([res1(:,2) res2(:,2) res3(:,2)],2) res4(:,2) res5(:,2) res6(:,2)],2)-mean([mean([res1(:,1) res2(:,1) res3(:,1)],2) res4(:,1) res5(:,1) res6(:,1)],2)>mean([mean([X1(2) X2(2) X3(2)]) X4(2) X5(2) X6(2)])-mean([mean([X1(1) X2(1) X3(1)]) X4(1) X5(1) X6(1)]))/N*2
P32= sum(mean([mean([res1(:,3) res2(:,3) res3(:,3)],2) res4(:,3) res5(:,3) res6(:,3)],2)-mean([mean([res1(:,2) res2(:,2) res3(:,2)],2) res4(:,2) res5(:,2) res6(:,2)],2)>mean([mean([X1(3) X2(3) X3(3)]) X4(3) X5(3) X6(3)])-mean([mean([X1(2) X2(2) X3(2)]) X4(2) X5(2) X6(2)]))/N*2
sum(mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)-mean([res1(:,1:2) res2(:,1:2) res3(:,1:2) res4(:,1:2) res5(:,1:2) res6(:,1:2)],2)>mean([X1(3) X2(3) X3(3) X4(3) X5(3) X6(3)])-mean([X1(1:2) X2(1:2) X3(1:2) X4(1:2) X5(1:2) X6(1:2)]))/N
SD = mean([res1(:,3) res2(:,3) res3(:,3) res4(:,3) res5(:,3) res6(:,3)],2)-mean([res1(:,1) res2(:,1) res3(:,1) res4(:,1) res5(:,1) res6(:,1)],2);
SD = sort(SD);
SD = SD(round(length(SD)*97.5/100));

TM1 = mean([mean([X1(1) X2(1) X3(1)]) X4(1) X5(1) X6(1)]);

TM2 = mean([mean([X1(2) X2(2) X3(2)]) X4(2) X5(2) X6(2)]);

TM3 = mean([mean([X1(3) X2(3) X3(3)]) X4(3) X5(3) X6(3)]);

%% plot biases
figure(1);
subplot(2,4,1);
cla;hold all;
bar(Y1);
title('Attribute Framing');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y1,E1);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,2);
cla;hold all;
bar(Y2);
title('Risky choice Framing');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y2,E2);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,3);
cla;hold all;
bar(Y3);
title('Task Framing');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y3,E3);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,5);
cla;hold all;
bar(Y4);
title('Anchoring');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y4,E4);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,6);
cla;hold all;
bar(Y5);
title('Persistence of belief');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y5,E5);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,7);
cla;hold all;
bar(Y6);
title('Sample-size neglect');
ylabel('Effect size');
xlabel('Pupil dilation');
h=errorbar(Y6,E6);
set(h,'color','black')
set(h,'LineStyle','none')

subplot(2,4,8);
cla;hold all;
bar([TM1 TM2 TM3]);
title('Total mean');
ylabel('Effect size');
xlabel('Pupil dilation');
set(h,'color','black')
set(h,'LineStyle','none')
text(1.5,TM2+0.01,['p = ',num2str(P21)],...
     'horiz','center','vert','bottom','Color','blue')
line([1 2],[TM2+0.01 TM2+0.01]);
text(2,TM3+0.05,['p = ',num2str(P31)],...
     'horiz','center','vert','bottom','Color','blue')
line([1 3],[TM3+0.05 TM3+0.05]);
line([0.6 0.6],[TM3 TM3-SD],'LineWidth',2,'Color','black');
line([0.58 0.62],[TM3 TM3],'LineWidth',2,'Color','black');
line([0.58 0.62],[TM3-SD TM3-SD],'LineWidth',2,'Color','black');
text(0.61, TM3-SD/2,'95% CI'); 

figure(2);
clf; lineplot(permute(cell2mat(cellfun(@(x)nanmean(x,1),meanpuptc(:,:,1:6),'UniformOutput',false)),[3 2 1]));


%% Analyze one participant's data
function [anchans, anchtype, anchphas, anchokeye, coinbeta, coinphas, coinokeye, gambans, gambtype, gambphas, gambokeye, beefans, beeftype, beefphas, studans, studtype, studphas, optans, opttype, optphas, urnans, urntype, urnphas, urnokeye, corrphasbase, meanpuptc] = Analysis(sub)

    pathname = fullfile(fileparts(pwd),'pilot_data',['Subject ' sprintf('%02d',sub)]);
    file3 = dir(fullfile(pathname, ['*.mat']));
    for f=1:length(file3)
        file3(f).name
        pathname = fullfile(fileparts(pwd),'pilot_data',['Subject ' sprintf('%02d',sub)]);
        load(fullfile(pathname,file3(f).name));
        %file = dir(fullfile(pathname, ['*.mat']));
    end

    meanpuptc = [];
    blocks = {1,2,3:5,6:7, 8:12,13};
    for j = 1:length(blocks)
        meanpuptc{j} = [];
        for i = blocks{j} 
            for k = 1:size(ETexp(i).basetc,1)
                meanpuptc{j} = cat(1,meanpuptc{j},(nanmean([ETexp(i).basetc(k,:,ETexp(i).okeye(k,:)) ETexp(i).phastc(k,:,ETexp(i).okeye(k,:))],3) - nanmean(ETexp(i).base(k,ETexp(i).okeye(k,:)),2))/baseline);
            end
        end
        if isempty(meanpuptc{j}); meanpuptc{j} = nan(1,660); end
    end

    anchans = Ans{1}.free';
    anchtype = Type{1}';
    anchphas = ETexp(1).phasicm;
    if size(ETexp(1).okeye,2)>1
        anchokeye = sum(ETexp(1).okeye,2);
    else
        anchokeye = ETexp(1).okeye;
    end

    heads = [2 3 4 5 6 7 9 10 11 19];
    tails = [1 2 1 4 3 2 8 7 6 14];
    ord =  [6 4 5 2 9 7 3 10 1 8];
    val = nan(length(ord),2);
    for i=1:size(val,1)
        val(i,1) = heads(ord(i));
        val(i,2) = tails(ord(i));
    end
    coinans = Ans{2}.rate'./100;

    ratio = zscore((val(:,1)-val(:,2))./sum(val,2));
    sz = zscore(sum(val,2));
    coinbeta = regress(zscore(coinans'),[zscore(exp(val(:,1)*log(0.6/0.4)-val(:,2)*log(0.6/0.4))) zscore(exp(ratio*log(0.6/0.4))) ones(length(sz),1)])';
    coinbeta = 1-coinbeta(1)+coinbeta(2);
    coinphas = ETexp(2).meanphas;
    coinokeye = sum(ETexp(2).okeyem);

    gambans = Ans{3}.rate';
    gambphas = ETexp(3).meanphas;
    if size(ETexp(3).okeye,2)>1
        gambokeye = sum(sub,2);
    else
        gambokeye = ETexp(3).okeye;
    end
    gambtype = Type{3};

    beefans = Ans{4}.rate';
    beefphas = ETexp(4).meanphas;
    beeftype = Type{4};

    studans = Ans{5}.rate';
    studphas = ETexp(5).meanphas;
    studtype = Type{5};

    optans = Ans{6}.opt';
    opttype = Type{6};
    optphas = [ETexp(6).meanphas ETexp(7).meanphas ETexp(8).meanphas ETexp(9).meanphas ETexp(10).meanphas ETexp(11).meanphas ETexp(12).meanphas];

    if sub<4
        urnans = nan(1,18); % first 3 subjects did not perform same type of urn task
        urnphas = nan;
        urntype = nan;
        urnokeye = nan;
    else
        urnans = Ans{7}.opt';
        urntype = mod(number,2)+1;
        urnphas = ETexp(13).meanphas;
        urnokeye = sum(ETexp(13).okeyem);
    end
    phasic = [ETexp(2).phasicm ETexp(3).phasicm ETexp(4).phasicm ETexp(5).phasicm ETexp(6).phasicm];
    base = [ETexp(2).basem ETexp(3).basem ETexp(4).basem ETexp(5).basem ETexp(6).basem];
    if sub>=4
        phasic = [phasic ETexp(7).phasicm];
        base = [base ETexp(7).basem];
    end
    corrphasbase = corr(base',phasic','rows','complete');
end

%% plotting functions
function h = lineplot(sig,cols,x)
    hold all;
    N = size(sig,1);
    for i = 1:N
        sigi = nanmean(sig(i,:,:),3);
        n = (length(sigi)-1)/2;
        semi = nanstd(sig(i,:,:),[],3)./sqrt(size(sig,3));
        if nargin<2 || isempty(cols); col = (i-0.9)/N; else col = cols(i); end
        if nargin<3; x = (0:n*2)/100; end;
        x = x(1:length(sigi));
        ciplot(sigi-semi, sigi+semi,x,hsv2rgb([col, .5 .9]));
    end            
    for i = 1:N
        sigi = nanmean(sig(i,:,:),3);
        n = (length(sigi)-1)/2;
        if nargin<2 || isempty(cols); col = (i-0.9)/N; else col = cols(i); end
        h(i) = plot(x, sigi, 'Color', hsv2rgb([col, 0.9 1]), 'LineWidth', 2);
    end
end

function [rout,g,b] = hsv2rgb(hin,s,v)
    %HSV2RGB Convert hue-saturation-value colors to red-green-blue.
    %   M = HSV2RGB(H) converts an HSV color map to an RGB color map.
    %   Each map is a matrix with any number of rows, exactly three columns,
    %   and elements in the interval 0 to 1.  The columns of the input matrix,
    %   H, represent hue, saturation and value, respectively.  The columns of
    %   the resulting output matrix, M, represent intensity of red, blue and
    %   green, respectively.
    %
    %   RGB = HSV2RGB(HSV) converts the HSV image HSV (3-D array) to the
    %   equivalent RGB image RGB (3-D array).
    %
    %   As the hue varies from 0 to 1, the resulting color varies from
    %   red, through yellow, green, cyan, blue and magenta, back to red.
    %   When the saturation is 0, the colors are unsaturated; they are
    %   simply shades of gray.  When the saturation is 1, the colors are
    %   fully saturated; they contain no white component.  As the value
    %   varies from 0 to 1, the brightness increases.
    %
    %   The colormap HSV is hsv2rgb([h s v]) where h is a linear ramp
    %   from 0 to 1 and both s and v are all 1's.
    %
    %   See also RGB2HSV, COLORMAP, RGBPLOT.

    %   Undocumented syntaxes:
    %   [R,G,B] = HSV2RGB(H,S,V) converts the HSV image H,S,V to the
    %   equivalent RGB image R,G,B.
    %
    %   RGB = HSV2RGB(H,S,V) converts the HSV image H,S,V to the 
    %   equivalent RGB image stored in the 3-D array (RGB).
    %
    %   [R,G,B] = HSV2RGB(HSV) converts the HSV image HSV (3-D array) to
    %   the equivalent RGB image R,G,B.

    %   See Alvy Ray Smith, Color Gamut Transform Pairs, SIGGRAPH '78.
    %   Copyright 1984-2011 The MathWorks, Inc. 

    if nargin == 1 % HSV colormap
        threeD = ndims(hin)==3; % Determine if input includes a 3-D array
        if threeD,
            h = hin(:,:,1); s = hin(:,:,2); v = hin(:,:,3);
        else
            h = hin(:,1); s = hin(:,2); v = hin(:,3);
        end
    elseif nargin == 3
        if ~isequal(size(hin),size(s),size(v)),
            error(message('MATLAB:hsv2rgb:InputSizeMismatch'));
        end
        h = hin;
    else
        error(message('MATLAB:hsv2rgb:WrongInputNum'));
    end    

    h = 6.*h;
    k = floor(h);
    p = h-k;
    t = 1-s;
    n = 1-s.*p;
    p = 1-(s.*(1-p));

    % Processing each value of k separately to avoid simultaneously storing
    % many temporary matrices the same size as k in memory
    kc = (k==0 | k==6);
    r = kc;
    g = kc.*p;
    b = kc.*t;

    kc = (k==1);
    r = r + kc.*n;
    g = g + kc;
    b = b + kc.*t;

    kc = (k==2);
    r = r + kc.*t;
    g = g + kc;
    b = b + kc.*p;

    kc = (k==3);
    r = r + kc.*t;
    g = g + kc.*n;
    b = b + kc;

    kc = (k==4);
    r = r + kc.*p;
    g = g + kc.*t;
    b = b + kc;

    kc = (k==5);
    r = r + kc;
    g = g + kc.*t;
    b = b + kc.*n;

    if nargout <= 1
        if nargin == 3 || threeD 
            rout = cat(3,r,g,b);
        else
            rout = [r g b];
        end
        rout = bsxfun(@times, v./max(rout(:)), rout);
    else
        f = v./max([max(r(:)); max(g(:)); max(b(:))]);
        rout = f.*r;
        g = f.*g;
        b = f.*b;
    end
end
        
function ciplot(lower,upper,x,colour)

    % ciplot(lower,upper)       
    % ciplot(lower,upper,x)
    % ciplot(lower,upper,x,colour)
    %
    % Plots a shaded region on a graph between specified lower and upper confidence intervals (L and U).
    % l and u must be vectors of the same length.
    % Uses the 'fill' function, not 'area'. Therefore multiple shaded plots
    % can be overlayed without a problem. Make them transparent for total visibility.
    % x data can be specified, otherwise plots against index values.
    % colour can be specified (eg 'k'). Defaults to blue.

    % Raymond Reynolds 24/11/06

    if length(lower)~=length(upper)
        error('lower and upper vectors must be same length')
    end

    if nargin<4
        colour='b';
    end

    if nargin<3 || isempty(x)
        x=1:length(lower);
    end

    % convert to row vectors so fliplr can work
    if find(size(x)==(max(size(x))))<2
    x=x'; end
    if find(size(lower)==(max(size(lower))))<2
    lower=lower'; end
    if find(size(upper)==(max(size(upper))))<2
    upper=upper'; end

    fill([x fliplr(x)],[upper fliplr(lower)],colour, 'FaceAlpha', 0.4, 'EdgeColor',colour)


end

