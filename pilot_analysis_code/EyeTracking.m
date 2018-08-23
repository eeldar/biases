function EyeTracking(sub)
    %
    % process eyetracking data
    %
    %   USAGE:  EyeTracking(sub)
    %   INPUT:  sub - subject number
    %   OUTPUT: 'EyeTracking.m' file at subject's folder
    %
    pathname = fullfile(fileparts(pwd),'pilot_data',['Subject ' sprintf('%02d',sub)]);
    file = dir(fullfile(pathname, ['S' sprintf('%02d',sub) '*.txt']));
    filename = file(1).name;
    eye=eyeTrackTMS.parseTS(fullfile(pathname,filename));
    t = 1;
    while t<=length(eye)
        if length(eye(t).msg)>80000
            eye(t+2:end+1)=eye(t+1:end);
            trial = find(cellfun(@(idx) ~isempty(idx), strfind(eye(t).msg, 'end')));
            trial = trial(1);
            eye(t+1).msg = eye(t).msg(trial+1:end);
            eye(t+1).DMl = eye(t).DMl(trial+1:end);
            eye(t+1).DMlx = eye(t).DMlx(trial+1:end);
            eye(t+1).DMly = eye(t).DMly(trial+1:end);
            eye(t+1).DMr = eye(t).DMr(trial+1:end);
            eye(t+1).DMrx = eye(t).DMrx(trial+1:end);
            eye(t+1).DMry = eye(t).DMry(trial+1:end);
            eye(t+1).T = eye(t).T(trial+1:end);
            eye(t).msg(trial+1:end) = [];
            eye(t).DMl(trial+1:end) = [];
            eye(t).DMlx(trial+1:end) = [];
            eye(t).DMly(trial+1:end) = [];
            eye(t).DMr(trial+1:end) = [];
            eye(t).DMrx(trial+1:end) = [];
            eye(t).DMry(trial+1:end) = [];
            eye(t).T(trial+1:end) = [];
        end
        t = t + 1;
    end
    
    ETexp=eye(2:end);
    ETbase=eye(1);
    clear eye
    
    for i = 1:length(ETexp)
        [ETexp(i).DMlcb, ETexp(i).blinkl]=eyeTrackTMS.clearBlinks(ETexp(i).DMl, ETexp(i).DMlx, ETexp(i).DMly);
        [ETexp(i).DMrcb, ETexp(i).blinkr]=eyeTrackTMS.clearBlinks(ETexp(i).DMr, ETexp(i).DMrx, ETexp(i).DMry);
    end
    [ETbase.DMlcb, ETbase.blinkl]=eyeTrackTMS.clearBlinks(ETbase.DMl, ETbase.DMlx, ETbase.DMly);
    [ETbase.DMrcb, ETbase.blinkr]=eyeTrackTMS.clearBlinks(ETbase.DMr, ETbase.DMrx, ETbase.DMry);

    baseline=nanmean([ETbase.DMlcb(1:min(2700,end)) ETbase.DMrcb(1:min(2700,end))]);
    
    
    
    
    phaslen=360;
    
    
    
    
    try
        for t = 1:length(ETexp)
            trials = find(cellfun(@(idx) ~isempty(idx), strfind(ETexp(t).msg, 'trial')));
            if ~isempty(trials)
                ETexp(t).phastc=nan(size(trials));
                for it=1:length(trials)
                    i = trials(it);
                    if i>60
                        ETexp(t).basetc(it,1:60,1)=ETexp(t).DMlcb(i-60:i-1);
                        ETexp(t).basetc(it,1:60,2)=ETexp(t).DMrcb(i-60:i-1);
                        ETexp(t).baseblink(it,1:60,1)=ETexp(t).blinkl(i-60:i-1);
                        ETexp(t).baseblink(it,1:60,2)=ETexp(t).blinkr(i-60:i-1);
                        ETexp(t).base(it,1)=nanmean(ETexp(t).basetc(it,1:60,1));
                        ETexp(t).base(it,2)=nanmean(ETexp(t).basetc(it,1:60,2));
                        sz = min(phaslen,length(ETexp(t).DMlcb)-i+1);
                        if sz < phaslen
                            display(['Warning: incomplete phasic measurement block ' num2str(t) ' trial ' num2str(it)])
                        end
                        ETexp(t).phastc(it,1:sz,1)=ETexp(t).DMlcb(i:min(i+phaslen-1,end));
                        ETexp(t).phastc(it,1:sz,2)=ETexp(t).DMrcb(i:min(i+phaslen-1,end));
                        ETexp(t).phasblink(it,1:sz,1)=ETexp(t).blinkl(i:min(i+phaslen-1,end));
                        ETexp(t).phasblink(it,1:sz,2)=ETexp(t).blinkr(i:min(i+phaslen-1,end));
                        ETexp(t).phas(it,1)=nanmax(ETexp(t).phastc(it,61:360,1));
                        ETexp(t).phas(it,2)=nanmax(ETexp(t).phastc(it,61:360,2));
                        ETexp(t).okphas(it,:) = sum(~ETexp(t).phasblink(it,:,:))>phaslen/2;
                        ETexp(t).okbase(it,:) = sum(~ETexp(t).baseblink(it,:,:))>30;
                        ETexp(t).okeye(it,:) = ETexp(t).okphas(it,:) & ETexp(t).okbase(it,:);
                    else
                        ETexp(t).basetc(it,1:60,1)=nan;
                        ETexp(t).basetc(it,1:60,2)=nan;
                        ETexp(t).baseblink(it,1:i-1,1)=ETexp(t).blinkl(1:i-1);
                        ETexp(t).baseblink(it,1:i-1,2)=ETexp(t).blinkr(1:i-1);
                        ETexp(t).base(it,1)=nanmean(ETexp(t).DMlcb(1:i-1));
                        ETexp(t).base(it,2)=nanmean(ETexp(t).DMrcb(1:i-1));
                        sz = min(phaslen,length(ETexp(t).DMlcb)-i+1);
                        if sz < phaslen
                            display(['Warning: incomplete phasic measurement block ' num2str(t) ' trial ' num2str(it)])
                        end
                        ETexp(t).phastc(it,1:sz,1)=ETexp(t).DMlcb(i:min(i+phaslen-1,end));
                        ETexp(t).phastc(it,1:sz,2)=ETexp(t).DMrcb(i:min(i+phaslen-1,end));
                        ETexp(t).phasblink(it,1:sz,1)=ETexp(t).blinkl(i:min(i+phaslen-1,end));
                        ETexp(t).phasblink(it,1:sz,2)=ETexp(t).blinkr(i:min(i+phaslen-1,end));
                        ETexp(t).phas(it,1)=nanmax(ETexp(t).phastc(it,61:360,1));
                        ETexp(t).phas(it,2)=nanmax(ETexp(t).phastc(it,61:360,2));
                        ETexp(t).okphas(it,:) = sum(~ETexp(t).phasblink(it,:,:))>phaslen/2;
                        ETexp(t).okbase(it,:) = sum(~ETexp(t).baseblink(it,:,:))>max(20,i/2);
                        ETexp(t).okeye(it,:) = ETexp(t).okphas(it,:) & ETexp(t).okbase(it,:);
                    end

                end
                ETexp(t).phasic=ETexp(t).phas-ETexp(t).base;
                for it=1:length(trials)
                    ETexp(t).phasicm(it) = nanmean(ETexp(t).phasic(it,ETexp(t).okeye(it,:)))/baseline;
                    ETexp(t).basem(it) = nanmean(ETexp(t).base(it,ETexp(t).okbase(it,:)));

                end
                ETexp(t).okeyem = ETexp(t).okeye(:,1) | ETexp(t).okeye(:,2);
                ETexp(t).meanphas = nanmean(ETexp(t).phasicm);
                ETexp(t).meanbase = nanmean(ETexp(t).basem);
            end
        end

        clear i* trial varname phaslen FileName;
        save([pathname '/EyeTracking.mat']);
        clear PathName;
        EyeTrackingCorrect(sub);
    catch er
        save('error.mat');
        rethrow(er);
    end

end

function EyeTrackingCorrect(sub)
    
    pathname = fullfile(fileparts(pwd),'pilot_data',['Subject ' sprintf('%02d',sub)]);
    file = dir(fullfile(pathname, 'Eye*.mat'));
    filename = file(1).name;
    load(fullfile(pathname,filename));
    
    B = [7 10 3 4 2 1 1 1 1 1 1 1 18 0 0 40];
    
    b=1;
    while b<length(B) && b<=length(ETexp)
        if size(ETexp(b).okeye,1)>B(b) && (b~=13 || size(ETexp(b).okeye,1)~=90)
            ETexp(b+2:end+1) = ETexp(b+1:end);
            ETexp(b+1).phastc = ETexp(b).phastc(B(b)+1:end,:,:);
            ETexp(b+1).basetc = ETexp(b).basetc(B(b)+1:end,:,:);
            ETexp(b+1).baseblink = ETexp(b).baseblink(B(b)+1:end,:,:);
            ETexp(b+1).phasblink = ETexp(b).phasblink(B(b)+1:end,:,:);
            ETexp(b+1).base = ETexp(b).base(B(b)+1:end,:);
            ETexp(b+1).phas = ETexp(b).phas(B(b)+1:end,:);
            ETexp(b+1).okphas = ETexp(b).okphas(B(b)+1:end,:);
            ETexp(b+1).okbase = ETexp(b).okbase(B(b)+1:end,:);
            ETexp(b+1).okeye = ETexp(b).okeye(B(b)+1:end,:);
            ETexp(b+1).phasic = ETexp(b).phasic(B(b)+1:end,:);
            ETexp(b+1).phasicm = ETexp(b).phasicm(B(b)+1:end);
            ETexp(b+1).basem = ETexp(b).basem(B(b)+1:end);
            ETexp(b+1).okeyem = ETexp(b).okeyem(B(b)+1:end);
            ETexp(b).phastc(B(b)+1:end,:,:) = [];
            ETexp(b).basetc(B(b)+1:end,:,:) = [];
            ETexp(b).baseblink(B(b)+1:end,:,:) = [];
            ETexp(b).phasblink(B(b)+1:end,:,:) = [];
            ETexp(b).base(B(b)+1:end,:) = [];
            ETexp(b).phas(B(b)+1:end,:) = [];
            ETexp(b).okphas(B(b)+1:end,:) = [];
            ETexp(b).okbase(B(b)+1:end,:) = [];
            ETexp(b).okeye(B(b)+1:end,:) = [];
            ETexp(b).phasic(B(b)+1:end,:) = [];
            ETexp(b).phasicm(B(b)+1:end) = [];
            ETexp(b).basem(B(b)+1:end) = [];
            ETexp(b).okeyem(B(b)+1:end) = [];
            ETexp(b).meanphas = nanmean(ETexp(b).phasicm);
            ETexp(b).meanbase = nanmean(ETexp(b).basem);
            ETexp(b+1).meanphas = nanmean(ETexp(b+1).phasicm);
            ETexp(b+1).meanbase = nanmean(ETexp(b+1).basem);
        end
        [b size(ETexp(b).okeye,1)]
        b = b + 1;
    end
    
    clear b B filename;
    pathname = fullfile(fileparts(pwd),'pilot_data',['Subject ' sprintf('%02d',sub)]);
    save([pathname '/EyeTracking.mat']);
    clear pathname;

end