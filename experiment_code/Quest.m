classdef Quest < handle
        
    properties
        
        w;
        text;
        quest;
        height;
        width;
        snd;
        top;
        c;
        
    end
    
    methods
        
        function obj = Quest(file, w, text, snd)
            obj.w = w;
            obj.text =text;
            obj.quest=importdata(file);
            obj.top = obj.quest{1};
            if strcmp(obj.top(1:5),'top: ')
                obj.top = char(obj.top(6:end));
                obj.quest = obj.quest(2:end);
            else
                obj.top = [];
            end
            obj.snd = snd;
            [obj.width obj.height] = Screen('WindowSize',w);
        end
        
        function run(obj, set)
            
            Screen('Flip',obj.w);
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            nq=0;
            for i=1:length(obj.quest)
                qc=char(obj.quest(i));
                if qc(1)>57 || qc(1)<48
                    nq=nq+1;
                end
            end
            c=zeros(1,nq);
            iq=1;
            il=1;
            refkeys = [KbName('1!') KbName('2@') KbName('3#') KbName('4$') KbName('5%') KbName('6^') KbName('7&') KbName('LeftArrow')];
            
            while il<=length(obj.quest)
                
                q=char(obj.quest(il));
                il=il+1;
                na=0;
                ac=char(obj.quest(il));
                a={};
                while il<=length(obj.quest) && ac(1)<58 && ac(1)>47
                    na=na+1;
                    a(na,1)=obj.quest(il); %#ok<AGROW>
                    il=il+1;
                    if il<=length(obj.quest)
                        ac=char(obj.quest(il));
                    end
                end
                
                y = zeros(1,length(a)+2) + round(4*obj.height/16);
                if ~isempty(obj.top)
                    [~, y(1)] = obj.text.drawWrappedText(obj.top, [], y(1), 1, 'left');
                    y(1) = y(1) + 40 + obj.text.lineh(set);
                end
                [~, y(2)] = obj.text.drawWrappedText(q, [], y(1), set, 'left');
                y(2) = y(2) + 30 + obj.text.lineh(1);
                for ia=1:length(a)
                    [~, y(ia+2)] = obj.text.drawWrappedText(char(a(ia)), [], y(ia+1), 1, 'left');
                    y(ia+2) = y(ia+2) + 15 + obj.text.lineh(1);
                end
                obj.text.drawWrappedText('To return to previous question, press left arrow key ', [], obj.height-obj.text.lineh(2)*2, 2, 'center');
                obj.text.drawWrappedText(['question ' num2str(iq) ' out of ' num2str(nq)], [], obj.text.lineh(2)*2,1, 'right', 50);
                Screen('Flip',obj.w,[],1);
                WaitSecs(0.4);
                
                % keys
                keys = zeros(1, length(a)*2+1);
                for k = 1:length(a)
                    keys(1 + (k-1)*2) = refkeys(k);
                    temp = KbName(refkeys(k));
                    keys(2 + (k-1)*2) = KbName(temp(1));
                end
                keys(end) = refkeys(end);
                
                % get choice
                key=Utilities.waitForInput(keys, inf);
                if key==keys(end)
                    il=il-length(a)-2;
                    iq=iq-1;
                    if iq<1
                        il=1;
                        iq=1;
                    else
                        Screen('Flip',obj.w);
                        qc=char(obj.quest(il));
                        while qc(1)>47 && qc(1)<58
                            il=il-1;
                            qc=char(obj.quest(il));
                        end
                    end
                else
                    for ia=1:length(a)
                        if key==keys(1 + (ia-1)*2) || key==keys(2 + (ia-1)*2)
                            Screen('FillRect', obj.w, [100 100 100], [0 y(ia+1)-obj.text.lineh(1) obj.width y(ia+2)-obj.text.lineh(1)]);
                            obj.text.drawWrappedText(char(a(ia)), [], y(ia+1), 2, 'left');
                        end
                    end
                    c(iq)=ceil(find(keys == key)/2);
                    iq=iq+1;
                    PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
                    Screen('Flip',obj.w);
                    WaitSecs(0.2);
                    
                end
                
            end
            
            obj.text.drawWrappedText('Thank you!', [], (obj.height+obj.text.lineh(3))/2, 3, 'center');
            Screen('Flip',obj.w);
            WaitSecs(2);
            
            obj.c=c;
        end
        
        function [neg pos]=PANAXanalyze(obj)
            neg = [1 3 6 7 10 12 14 16 17 20];
            pos = setdiff(1:20, neg);
            neg = mean(obj.c(neg));
            pos = mean(obj.c(pos));
        end
        
        function [basd basf basr bis]=BISBASanalyze(obj)
            basd = [3 9 12 21];
            basf = [5 10 15 20];
            basr = [4 7 14 18 23];
            bis = [2 8 13 16 19 22 24];
            c = obj.c;
            c([1 3:21 23:24]) = 5 - c([1 3:21 23:24]); %#ok<*PROP>
            basd = mean(c(basd));
            basf = mean(c(basf));
            basr = mean(c(basr));
            bis = mean(c(bis));
        end
        
        function [hps ext neu opn agr con]=IPIPanalyze(obj)
            extpos = [1 13 26 38 51];
            extneg = [7 19 32 45 57];
            neupos = [2 8 27 33 58];
            neuneg = [14 21 39 46 52];
            opnpos = [3 15 28 41 53];
            opnneg = [9 22 34 47 59];
            agrpos = [4 10 29 35 60];
            agrneg = [16 23 42 48 54];
            hpspos = [5 17 24 30 40 43 49 55];
            hpsneg = [11 20 36 61];
            conpos = [6 12 31 37 62];
            conneg = [18 25 44 50 56];
            c = obj.c;
            ext = mean([c(extpos) 6-c(extneg)]);
            neu = mean([c(neupos) 6-c(neuneg)]);
            opn = mean([c(opnpos) 6-c(opnneg)]);
            agr = mean([c(agrpos) 6-c(agrneg)]);
            hps = mean([c(hpspos) 6-c(hpsneg)]);
            con = mean([c(conpos) 6-c(conneg)]);
        end
        
        function nfc=NFCanalyze(obj)
            nfcpos = [1 3 4 6 9 10];
            nfcneg = [2 5 7 8];
            c = obj.c;
            nfc = mean([c(nfcpos) 6-c(nfcneg)]);
        end
        
    end
end

                