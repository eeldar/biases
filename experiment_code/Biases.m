classdef Biases < handle
        
    properties
        
        colors;
        hz;
        w; %window
        snd; %sound
        eyetrack; %eyetracker
        I; %images
        interTrialTime; %ITI function
        width; %screen width
        height; %screen height
        flickerI; %flicker fusion images
        text; % text writer
        quest; %questions
        refkeys = [KbName('1!') KbName('2@') KbName('3#') KbName('4$') KbName('5%') KbName('6^') KbName('7&') KbName('8*') KbName('9(')];
        col = [100 100 100];
        type;
                
    end
    
    methods
        
        function pcomp(obj, pct)
%             rect = [0 0 obj.width*pct/100 20];
%             Screen('FillRect', obj.w, [15 102 182], rect);
            obj.text.drawWrappedText([num2str(pct) '% completed'], 3, round(obj.text.lineh(1)*2/3));
        end
                    
        function Ans = runnfc(obj)
            obj.instnfc;
            obj.eyetrack.inc(15);
            obj.quest.nfc.run(2);
            Ans.nfc = obj.quest.nfc.NFCanalyze;
            Ans.name = 'Need for Cognition';
        end
    
        function Ans = runsat(obj)
            
            width  = obj.width;
            height = obj.height;
            text = obj.text;
            obj.eyetrack.inc(16);
            
            basey = round(height/4);
            [~, y] = text.drawWrappedText('SAT scores', [], basey, 3);
            [~, y] = text.drawWrappedText('As part of the study, we are examining how different styles of decision making correlate with SAT scores. For this purpose, we ask that you type your most recent SAT scores (out of 800) below. As with all of your answers, the scores will stay completely confidential.',[],y + text.lineh(1)*2,1); 
            [x, y] = text.drawWrappedText('Math: ',[],y + text.lineh(1)*2,2); 
            freeans = nan;
            while isnan(freeans)
                Screen('FillRect', obj.w, obj.col, [x y - text.lineh(1) width y + .5*text.lineh(1)]);
                [freeans x2]= text.input(x, y, [],[]);
                freeans = str2double(freeans);
                if freeans>800 || freeans<0 || mod(freeans,1)>0
                    freeans = nan;
                end
            end
            Screen('FillRect', obj.w, obj.col, [x2-text.textWidth('| ',1)-text.space y - text.lineh(1) width y + .5*text.lineh(1)]);
            
            Ans.math = freeans;
            [x, y] = text.drawWrappedText('Reading: ',[],y + text.lineh(1)*2,2); 
            freeans = nan;
            while isnan(freeans)
                Screen('FillRect', obj.w, obj.col, [x y - text.lineh(1) width y + .5*text.lineh(1)]);
                [freeans x2]= text.input(x, y, [],[]);
                freeans = str2double(freeans);
                if freeans>800 || freeans<0 || mod(freeans,1)>0
                    freeans = nan;
                end
            end
            Screen('FillRect', obj.w, obj.col, [x2-text.textWidth('| ',1)-text.space y - text.lineh(1) width y + .5*text.lineh(1)]);
            Ans.reading = freeans;
            [x, y] = text.drawWrappedText('Writing: ',[],y + text.lineh(1)*2,2); 
            freeans = nan;
            while isnan(freeans)
                Screen('FillRect', obj.w, obj.col, [x y - text.lineh(1) width y + .5*text.lineh(1)]);
                [freeans x2]= text.input(x, y, [],[]);
                freeans = str2double(freeans);
                if freeans>800 || freeans<0 || mod(freeans,1)>0
                    freeans = nan;
                end
            end
            Screen('FillRect', obj.w, obj.col, [x2-text.textWidth('| ',1)-text.space y - text.lineh(1) width y + .5*text.lineh(1)]);
            Ans.writing = freeans;
            Ans.sat = Ans.math + Ans.reading + Ans.writing;
            Ans.name = 'SAT';
            Screen('Flip',obj.w);
        end
    
        function instnfc(obj)

            text = obj.text;
            height = obj.height;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/4);
            endflag = 0;
            last = 2;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(71);
                
                switch count
                    case 1
                        [x, y] = text.drawWrappedText('Next, we ask that you fill out the ');
                        [~, y] = text.drawWrappedText('IPIP questionnaire',x,y,2); 
                        text.drawWrappedText('From this point onwards we are not tracking your eyes, so you do not have to keep your chin on the chinrest anymore',[],y + text.lineh(1)*2,1); 
                    case 2
                        [~, y] = text.drawWrappedText('The IPIP Questionnaire', [], basey, 4); 
                        [~, y] = text.drawWrappedText('You will be presented with phrases describing people''s behaviors. Please describe how accurately each statement describes you. Describe yourself as you generally are now, not as you wish to be in the future. Describe yourself as you honestly see yourself, in relation to other people you know of the same sex as you are, and roughly your same age. So that you can describe yourself in an honest manner, your responses will be kept in absolute confidence. Please read each statement carefully, and choose the most appropriate answer.', [], y+text.lineh(1)+40, 1);
                        text.drawWrappedText('Press space to start the IPIP questionnaire', [], y + text.lineh(1)*2, 2, 'center');
                end
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end        

        function thankyou(obj)

            text = obj.text;
            height = obj.height;

            basey = round(height/4);
            [~, y] = text.drawWrappedText('The End', [], basey, 4, 'center');
            [~, y] = text.drawWrappedText('Thank you for participating in the experiment!', [], y + text.lineh(3) + 40, 1, 'center');
            [~, y] = text.drawWrappedText('Please call the experimenter now', [], y + text.lineh(1) + 20, 1 , 'center');    
            text.drawWrappedText('Good bye!', [], y + text.lineh(1) + 20, 1 , 'center');            
            Screen('Flip', obj.w);
            Utilities.waitForInput(KbName('space'), GetSecs+30);
        end        

        function [Ans Tm] = rundsq(obj)
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            obj.instdsq;
            w = obj.w;
            I = obj.I;
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            T = length(obj.quest.dsq.txt);
            Tm.fix = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Ans.name = 'Defense Style Questionnaire';
            Ans.opt = zeros(T,1);
            obj.eyetrack.inc(17);
            for t = 1:T
                %fixation point\
%                 Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q(t)=Tm.fix(t)+.3;
                [Ans.opt(t) Tm.end(t)]= obj.dsqtrial(t, Tm.q(t));
            end
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Tm.fix(t+1)=Screen(w,'Flip');
            Tm.endall=Tm.fix(t+1)+obj.interTrialTime();
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Ans.key = [3 38; 5 26; 30 35; 2 25; 32 40; 1 39; 21 24; 7 28; 6 29; 23 36; 11 20; 34 37; 10 13; 14 17; 8 18; 31 33; 9 15; 19 22; 4 16; 12 27];
            Ans.names = {'Sublimation';'Humor';'Anticipation';'Suppression';'Undoing';'Pseudo-altruism';'Idealization';'Reaction formation';'Projection';'Passive aggression';'Acting out';'Isolation';'Devaluation';'Autistic fantasy';'Denial';'Displacement';'Dissociation';'Splitting';'Rationalization';'Somatization'};
            Ans.mech = mean((Ans.opt(Ans.key)+50).*9./100+1,2);
            Ans.fact(1) = mean(Ans.mech(1:4));
            Ans.fact(2) = mean(Ans.mech(5:8));
            Ans.fact(3) = mean(Ans.mech(9:20));
            Screen(w,'Flip', Tm.endall);
            obj.eyetrack.msg('end');
            WaitSecs(2);
        end
        
        function [rating, te]= dsqtrial(obj, iq, t)
            
            txt = obj.quest.dsq.txt{iq};
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            text = obj.text; 
            w = obj.w;
            I = obj.I;
            refy = round(height/5);
            rating = 0;
            
            [~, maxy] = text.drawWrappedText(txt, [], refy + text.lineh(1)*2, 1);
            
            x2 = round((width - I.opbrsz(1))/2);
            x4 = x2 + I.opbrsz(1,1);
            y2 = maxy + text.lineh(1)*2;
            text.drawWrappedText('Strongly disagree', x2 - text.textWidth('Strongly disagree',1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1,[],0,[],0);
            text.drawWrappedText('Strongly agree', x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1,[],0,[],0);

            key = -1;
            while ~sum([key==KbName('return')  (ismac && key==KbName('ENTER'))])
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
                Screen('Flip', w, t, 1);
                if key==-1
                    t = [];
                    obj.eyetrack.msg('trialonset');
                end
                keys = [KbName('LeftArrow') KbName('RightArrow') KbName('return')];
                if ismac 
                    keys = [keys KbName('ENTER')]; 
                end
                key = Utilities.waitForInput(keys,Inf);
                key = key(1);
                WaitSecs(0.14);
                if sum(key==KbName('RightArrow'))
                    rating = min(rating + 12.5, 50);
                elseif sum(key==KbName('LeftArrow'))
                    rating = max(rating - 12.5, -50);
                end
            end
            te = Screen('Flip', w);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            
        end

        function [Ans Tm] = runurn(obj)
            
            obj.insturn;
            w = obj.w;
            I = obj.I;
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            T = length(obj.quest.urn.seq)/5;
            Tm.fix = zeros(T,1);
            Tm.stim = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Ans.opt = zeros(T,1);
            Ans.name = 'The Urns task';  
            obj.eyetrack.inc(14);
            obj.eyetrack.msg('Urn');
            for t = 1:T
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.stim(t)=Tm.fix(t)+obj.interTrialTime();
                if t==1
                    rating =0;
                else
                    rating = Ans.opt(t-1);
                end
                [Ans.opt(t) Tm.q(t) Tm.end(t)]= obj.urntrial(obj.quest.urn.seq(1+(t-1)*5:t*5), rating, Tm.stim(t));
            end
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Tm.fix(t+1)=Screen(w,'Flip');
            obj.eyetrack.msg('fix');
            Tm.endall=Tm.fix(t+1)+obj.interTrialTime();
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall);
            obj.eyetrack.msg('end');
            WaitSecs(2);
        end
        
        function [rating ts te]= urntrial(obj, b, rating, t)
            
            oldVolume = PsychPortAudio('Volume', obj.snd.pahandle);
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{2})');
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            text = obj.text; 
            w = obj.w;
            I = obj.I;
            refy = round(height/5);
            if nargin<4 || isempty(nargin)
                rating = 0;
            end
            
            marg = width/8;
            space = marg;
            x = round((marg + (width-space)/2)/2);
            [~, y] = text.drawWrappedText('Urn A', x, refy, 2, 'center' , marg, [], round((width+space)/2));
            i = 1;
            x = x-round(I.urnsz(i,1)/2);
            Screen('DrawTexture', w, I.urntxtr(i), [], [x y x+I.urnsz(i,1) y+I.urnsz(i,2)]);
            x = round((width-marg + (width+space)/2)/2);
            text.drawWrappedText('Urn B', x, refy, 2, 'center' , round((width+space)/2), [], marg);
            i = 2;
            x = x-round(I.urnsz(i,1)/2);
            Screen('DrawTexture', w, I.urntxtr(i), [], [x y x+I.urnsz(i,1) y+I.urnsz(i,2)]);
            maxy = y+I.urnsz(i,2);
 
            
            x2 = round((width - I.opbrsz(1))/2);
            x4 = x2 + I.opbrsz(1,1);
            y2 = maxy + text.lineh(1)*4;
            text.drawWrappedText('Urn A', x2 - text.textWidth('Urn A',1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
            text.drawWrappedText('Urn B', x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
            x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
            y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
            rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
            Screen('Fillrect',w, [100 100 100], rect);
            rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
            Screen('DrawTexture', w, I.opbrtxtr, [], rect);
            rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
            Screen('DrawTexture', w, I.opnbtxtr(2), [], rect);
            
            for ib =1:5
                x = round((width-I.ballsz(b(ib),1))/2);
                spd = 20;
                y= -I.ballsz(b(ib),2);
                rect = [0 0 1 1]';
                while abs(spd)>0.5 || y+I.ballsz(b(ib),2)<maxy
                   y = y + spd;
                   Screen('FillRect',w, obj.col, rect);
                   rect = [x y x+I.ballsz(b(ib),1) y+I.ballsz(b(ib),2)]';
                   Screen('DrawTexture', w, I.balltxtr(b(ib)), [], rect);
                   Screen('Flip',w,t,1);
                   if ~isempty(t)
                       t = [];
                       obj.eyetrack.msg('trialonset');
                   end
                   if spd>0 && y+I.ballsz(b(ib),2)>maxy
                       PsychPortAudio('Volume', obj.snd.pahandle, spd/50);
                       PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
                       spd = -spd*2/3;
                   else
                       spd = spd + 1;
                   end
                end
                Screen('FillRect',w, obj.col, rect);
                Screen('Flip',w,GetSecs+.3,1);
            end
            
            key = -1;
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            while ~sum([key==KbName('return')  (ismac && key==KbName('ENTER'))])
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
                t = Screen('Flip', w, [], 1);
                if key==-1
                    ts=t;
                    obj.eyetrack.msg('rate');
                else
                    WaitSecs(0.14);
                end
                keys = [KbName('LeftArrow') KbName('RightArrow') KbName('return')];
                if ismac 
                    keys = [keys KbName('ENTER')]; 
                end
                key = Utilities.waitForInput(keys,Inf);
                key = key(1);
                if sum(key==KbName('RightArrow'))
                    rating = min(rating + 5, 50);
                elseif sum(key==KbName('LeftArrow'))
                    rating = max(rating - 5, -50);
                end
            end
            te=t;
            PsychPortAudio('Volume', obj.snd.pahandle, oldVolume);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            Screen('Flip',w);
        end
                
        function obj = Biases(short, eyetracking, type,color_convert)
            
            % set random stream
            s = RandStream.create('mt19937ar','seed',sum(100*clock));
            RandStream.setGlobalStream(s);
            
            % set inter-trial-intervals
            if short 
                obj.interTrialTime=@()1;
            else
                obj.interTrialTime=@()rand*2+7;
            end
            
            % set keyboard and mouse
            KbName('UnifyKeyNames');
            DisableKeysForKbCheck([]);
            HideCursor;
            ListenChar(2);
            
            % set screen
            backcol=[100 100 100];
            obj.w=Screen('OpenWindow',0,backcol,[],[],[],[],[]);
            [obj.width obj.height]=Screen('WindowSize', obj.w);
            Screen(obj.w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
            % set sounds
            InitializePsychSound;
            freq = 44100;
            obj.snd.pahandle = PsychPortAudio('Open',[],[],1,freq,1);
            PsychPortAudio('Volume', obj.snd.pahandle, 0.01);
            files=dir('Sounds/*.wav');
            for i=1:length(files)
                obj.snd.sound{i}=audioread(['Sounds/' files(i).name],'native');
                temp=obj.snd.sound{i};
                if size(temp,2)==2
                    temp=temp(:,1);
                end
                switch i
                    case 1
                        obj.snd.sound{i}=temp./3000;
                    otherwise
                        obj.snd.sound{i}=temp./10000;
                end
            end   
            
            
            undo_convert_images; %unconvert images from previous subjects if applicable
            % text writer
            obj.text = TextWriter;
            obj.text.initialize(obj.w);
            
            if color_convert == 1
                convert_images(); %convert images for flicker text writer
                [obj.colors, obj.hz] = obj.flickerfusion;
                undo_convert_images(); %unconvert images 
                
                convert_images(obj.colors);
                % text writer write over
                obj.text = TextWriter(obj.colors(end,:));
                obj.text.initialize(obj.w);
            end
            
            % load images
            obj.loadImages;
            
            % create questions
            obj.type = type;
            obj.createQuestions;
            
            % set eyetracking 
            obj.eyetrack = eyeTrackTMS(obj.w, obj.text, obj.I, eyetracking);
            if eyetracking; obj.eyetrack.calibraterecord; end
        end
        
        function createQuestions(obj)
            
            % Defense Style Questionnaires
            quest.dsq.txt = importdata('Questions/DSQ.txt');
            quest.nfc = Quest('Questions/NFC.txt', obj.w, obj.text, obj.snd);
                        
            % load anchoring bias questions
            types = [1 2 2 1 1 2 1];
            txt = importdata('Questions/anchoring.txt');  %Matlab 2016a error
            txt = {'Is the Mississippi river';'longer or shorter than ';'{70 2000}';' miles?';'1. Longer';'2. Shorter';'How long is the Mississippi river?';'{ miles}';'';'Is the population of Chicago ';'greater or smaller than ';'{0.2 5.0}';' million?';'1. Greater';'2. Smaller';'What is the population of Chicago?';'{ million}';'';'Is the average number of babies born per day';'in the US greater or smaller than ';'{100 50000}';'?';'1. Greater';'2. Smaller';'What is the average number of babies';'born each day in the US?';'{}';'';'Is mount Everest ';'taller or shorter than ';'{2000 45500}';' feet?';'1. Taller';'2. Shorter';'What is the height of mount Everest?';'{ feet}';'';'Does the average American eat more or less ';'than ';'{50 1000}';' pounds of meat per year?';'1. More';'2. Less';'How much meat does';'the average American eat per year?';'{ pounds}';'';'Was the telephone inveneted ';'before or after ';'{1850 1920}';'?';'1. Before';'2. After';'In what year was the telephone invented?';'{}';'';'Is the maximum speed of a house cat';'faster or slower than ';'{7 30}';' miles per hour?';'1. Faster';'2. Slower';'What is the maximum speed of a house cat?';'{ miles per hour}'};
            
            step = 0;
            i = 1;
            iq = 1;
            quest.anchor(i).quest = {};
            for l = 1:length(txt)
                str = txt{l};
                switch step
                    case 0
                        if str(1)=='{'
                            str = str(2:end-1);
                            quest.anchor(i).anchor = Utilities.splitStr(str);
                            iq = 1;
                            iq2 = 1;
                            ia = 1;
                            step = 1;
                            quest.anchor(i).post1='';
                        else
                            quest.anchor(i).quest1{iq} = str;
                            iq = iq + 1;
                        end
                    case 1
                        if isempty(str)
                            i = i+1;
                            step = 0;                            
                        elseif str(1)>='1' && str(1)<='9'
                            quest.anchor(i).ans{ia} = str;
                            ia = ia +1;
                        elseif str(1)=='{'
                            str = str(2:end-1);
                            quest.anchor(i).post2=str;
                        elseif ia==1
                            quest.anchor(i).post1 = str;
                        else
                            quest.anchor(i).quest2{iq2} = str;
                            iq2 = iq2 + 1;
                        end
                end
                if obj.type==1
                    quest.anchor(i).type = types(i);
                else
                    quest.anchor(i).type = 3-types(i);
                end
            end
            
            
            ord =  [2 1 3];
            % create rating questions
            for i = 1:3
                quest.rate{1}(i).title = '$10 gamble:';
                quest.rate{1}(i).att(1).txt = 'Amount to Be Won: ';
                quest.rate{1}(i).att(2).txt = 'Probability of Wining: ';
                quest.rate{1}(i).att(3).txt = 'Probability of Losing: ';
                quest.rate{1}(i).att(1).pre = '$';
                quest.rate{1}(i).att(2).pre = '';
                quest.rate{1}(i).att(3).pre = '';
                quest.rate{1}(i).att(1).post = '';
                quest.rate{1}(i).att(2).post = '%';
                quest.rate{1}(i).att(3).post = '%';
                quest.rate{1}(i).att(1).val = 100 +(ord(i)==2)*100 -(ord(i)==3)*50;
                quest.rate{1}(i).att(2).val = 10 -(ord(i)==2)*5 +(ord(i)==3)*10;
                quest.rate{1}(i).att(3).val = 100 - quest.rate{1}(i).att(2).val;
                quest.rate{1}(i).bar.high{1} = 'would definitely';
                quest.rate{1}(i).bar.high{2} = 'take the gamble';
                quest.rate{1}(i).bar.low{1} = 'would definitely';
                quest.rate{1}(i).bar.low{2} = 'not take the gamble';
            end
            for i = 1:4
                quest.rate{2}(i).title = 'Ground beef:';
                quest.rate{2}(i).att(1).txt = 'Price per Pound: ';
                quest.rate{2}(i).att(2).txt = 'Percentage Lean: ';
                quest.rate{2}(i).att(3).txt = 'Percentage Fat: ';
                quest.rate{2}(i).att(1).pre = '$';
                quest.rate{2}(i).att(2).pre = '';
                quest.rate{2}(i).att(3).pre = '';
                quest.rate{2}(i).att(1).post = '';
                quest.rate{2}(i).att(2).post = '%';
                quest.rate{2}(i).att(3).post = '%';
                quest.rate{2}(i).att(1).val = 3.9 - 0.6*ceil(i/2);
                quest.rate{2}(i).att(2).val = 80 + mod(i,2)*10;
                quest.rate{2}(i).att(3).val = 20 - mod(i,2)*10;
                quest.rate{2}(i).bar.high{1} = 'very satisfied';
                quest.rate{2}(i).bar.low{1} = 'very dissatisfied';
            end
            for i = 1:2
                quest.rate{3}(i).title = 'Student performance:';
                quest.rate{3}(i).att(1).txt = 'Midterm Exam: ';
                quest.rate{3}(i).att(2).txt = 'Final Exam: ';
                quest.rate{3}(i).att(3).txt = 'Final Exam: ';
                quest.rate{3}(i).att(1).pre = '';
                quest.rate{3}(i).att(2).pre = '';
                quest.rate{3}(i).att(3).pre = '';
                quest.rate{3}(i).att(1).post = '% correct';
                quest.rate{3}(i).att(2).post = '% correct';
                quest.rate{3}(i).att(3).post = '% incorrect';
                quest.rate{3}(i).att(1).val = 50 + 20*(i-1);
                quest.rate{3}(i).att(2).val = 70 - 20*(i-1);
                quest.rate{3}(i).att(3).val = 100 - quest.rate{3}(i).att(2).val;
                quest.rate{3}(i).bar.high{1} = 'very good';
                quest.rate{3}(i).bar.high{2} = 'performance';
                quest.rate{3}(i).bar.low{1} = 'very poor';
                quest.rate{3}(i).bar.low{2} = 'performance';
            end
            heads = [2 3 4 5 6 7 9 10 11 19];
            tails = [1 2 1 4 3 2 8 7 6 14];
            ord =  [6 4 5 2 9 7 3 10 1 8];
            for i = 1:length(ord)
                quest.rate{4}(i).title = 'Biased coin:';
                quest.rate{4}(i).att(1).txt = 'Number of heads: ';
                quest.rate{4}(i).att(2).txt = 'Number of tails: ';
                quest.rate{4}(i).att(1).pre = '';
                quest.rate{4}(i).att(2).pre = '';
                quest.rate{4}(i).att(1).post = '';
                quest.rate{4}(i).att(2).post = '';
                quest.rate{4}(i).att(1).val = heads(ord(i));
                quest.rate{4}(i).att(2).val = tails(ord(i));
                quest.rate{4}(i).bar.high{1} = 'completely certain';
                quest.rate{4}(i).bar.high{2} = 'that coin favors heads';
                quest.rate{4}(i).bar.low{1} = 'completely uncertain';
                quest.rate{4}(i).bar.low{2} = 'that coin favors heads';
            end
                        
            quest.option(1).title{1} = 'which vaccine would you choose?';
            quest.option(1).att(1).label = 'Vaccine A: ';
            quest.option(1).att(2).label = 'Vaccine B: ';
            quest.option(1).att(1).txt{1}{1} = '300 people will be saved';
            quest.option(1).att(1).txt{2}{1} = '300 people will die';
            quest.option(1).att(2).txt{1}{1} = 'a 50% chance that 600 people will be saved and a 50% chance that none of the people will be saved';
            quest.option(1).att(2).txt{2}{1} = 'a 50% chance that 600 people will die and a 50% chance that none of the people will die';
            quest.option(1).bar{1} = 'Vaccine A';
            quest.option(1).bar{2} = 'Vaccine B';
            
            quest.option(2).title{1} = 'which option would you choose?';
            quest.option(2).att(1).label = 'Option A: ';
            quest.option(2).att(2).label = 'Option B: ';
            quest.option(2).att(1).txt{1}{1} = '3000 acres of forest will be saved';
            quest.option(2).att(1).txt{2}{1} = '6000 acres of forest will be lost';
            quest.option(2).att(2).txt{1}{1} = 'a 60% chance that 5000 acres will be saved and a 40% chance that no forest under threat will be saved';
            quest.option(2).att(2).txt{2}{1} = 'a 60% chance that 4000 acres will be lost and a 40% chance that 9000 acres will be lost';
            quest.option(2).bar{1} = 'Option A';
            quest.option(2).bar{2} = 'Option B';
            
            quest.option(3).title{1} = 'To which parent would you award sole custody of the child?';
            quest.option(3).title{2} = 'Which parent would you deny sole custody of the child?';
            quest.option(3).att(1).label = 'Parent A';
            quest.option(3).att(2).label = 'Parent B';
            quest.option(3).att(1).txt{1}{1} = '~ average income';
            quest.option(3).att(1).txt{1}{2} = '~ average health';
            quest.option(3).att(1).txt{1}{3} = '~ average working hours';
            quest.option(3).att(1).txt{1}{4} = '~ reasonable rapport with the child';
            quest.option(3).att(1).txt{1}{5} = '~ relatively stable social life';
            quest.option(3).att(2).txt{1}{1} = '~ above-average income';
            quest.option(3).att(2).txt{1}{2} = '~ very close relationship with the child';
            quest.option(3).att(2).txt{1}{3} = '~ extremely active social life';
            quest.option(3).att(2).txt{1}{4} = '~ lots of work-related travel';
            quest.option(3).att(2).txt{1}{5} = '~ minor health problems';
            quest.option(3).bar{1} = 'Parent A';
            quest.option(3).bar{2} = 'Parent B';
            
            quest.option(4).title{1} = 'Which vacation spot would you prefer?';
            quest.option(4).title{2} = 'Which reservation do you decide to cancel?';
            quest.option(4).att(1).label = 'Spot A';
            quest.option(4).att(2).label = 'Spot B';
            quest.option(4).att(1).txt{1}{1} = '~ average weather';
            quest.option(4).att(1).txt{1}{2} = '~ average beaches';
            quest.option(4).att(1).txt{1}{3} = '~ medium-quality hotel';
            quest.option(4).att(1).txt{1}{4} = '~ medium-temperature water';
            quest.option(4).att(1).txt{1}{5} = '~ average nightlife';
            quest.option(4).att(2).txt{1}{1} = '~ lots of sunshine';
            quest.option(4).att(2).txt{1}{2} = '~ gorgeous beaches and coral reefs';
            quest.option(4).att(2).txt{1}{3} = '~ ultra-modern hotel';
            quest.option(4).att(2).txt{1}{4} = '~ very cold water';
            quest.option(4).att(2).txt{1}{5} = '~ very strong winds';
            quest.option(4).att(2).txt{1}{6} = '~ no nightlife';
            quest.option(4).bar{1} = 'Spot A';
            quest.option(4).bar{2} = 'Spot B';
            
            quest.option(5).title{1} = 'Which one would you prefer?';
            quest.option(5).title{2} = 'Which one would you prefer to give up?';
            quest.option(5).att(1).label = 'Lottery 1: ';
            quest.option(5).att(2).label = 'Lottery 2: ';
            quest.option(5).att(1).txt{1}{1} = 'You have a 50% chance to win $50, otherwise nothing';
            quest.option(5).att(2).txt{1}{1} = 'You have a 80% chance to win $150, and a 20% chance to lose $10';
            quest.option(5).bar{1} = 'Lottery 1';
            quest.option(5).bar{2} = 'Lottery 2';
            
            quest.option(6).title{1} = 'Which one would you prefer?';
            quest.option(6).title{2} = 'Which one would you prefer to give up?';
            quest.option(6).att(1).label = 'Lottery 1: ';
            quest.option(6).att(2).label = 'Lottery 2: ';
            quest.option(6).att(1).txt{1}{1} = 'You have a 20% chance to win $50, otherwise nothing';
            quest.option(6).att(2).txt{1}{1} = 'You have a 60% chance to win $100, and a 40% chance to lose $5';
            quest.option(6).bar{1} = 'Lottery 1';
            quest.option(6).bar{2} = 'Lottery 2';
            
            quest.option(7).title{1} = 'Which do you choose?';
            quest.option(7).title{2} = 'Which one would you prefer to give up?';
            quest.option(7).att(1).label = 'Flavor A ';
            quest.option(7).att(2).label = 'Flavor B ';
            quest.option(7).att(1).txt{1}{1} = '~ good';
            quest.option(7).att(2).txt{1}{1} = '~ excellent, but high in cholesterol';
            quest.option(7).bar{1} = 'Flavor A';
            quest.option(7).bar{2} = 'Flavor B';
            
            seq1 = [2,4,1,1,3,1,3,5,2,5,1,3,3,1,2,4,2,1,5,5,5,3,1,1,1,3,4,2,5,2];
            seq2 = [4,2,3,3,1,3,1,5,4,5,3,1,1,3,4,2,4,3,5,5,5,1,3,3,3,1,2,4,5,4];
            if obj.type==1
                seq = [seq1 seq2 seq2(end:-1:1)];
            else
                seq = [seq2 seq1 seq1(end:-1:1)];
            end                
            quest.urn.seq = seq;
            
            addpath('AuditoryOddball');
            for ii =  1:7
                quest.auditoryoddball(ii) = pseudorandomize_audio();
            end
            
            obj.quest = quest;
        end

        function [Ans, Tm, Type] = runrate(obj, b)
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            w = obj.w;
            width = obj.width;
            I = obj.I;
            height = obj.height;
            T = length(obj.quest.rate{b});
            Tm.fix = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Ans.name = 'Evaluations';            
            Ans.rate = zeros(T,1);
            if b<3
                Type = obj.type;
            else
                Type = 3-obj.type;
            end
            switch b
                case 1
                    obj.instrate1(Type);
                case 2
                    obj.instrate2(Type);
                case 3
                    obj.instrate3(Type);
            end                    
            obj.eyetrack.inc(3+b);
            obj.eyetrack.msg(['Rate' num2str(b)]);
            
            for t = 1:T
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q(t)=Tm.fix(t)+obj.interTrialTime();
                [Ans.rate(t), Tm.end(t)] = obj.ratetrial(b, t, Type, Tm.q(t));
            end
            
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Tm.fix(t+1)=Screen(w,'Flip');
            obj.eyetrack.msg('fix');
            Tm.endall=Tm.fix(t+1)+obj.interTrialTime();
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall);
            obj.eyetrack.msg('end');
            WaitSecs(2);
        end        
        
        function [Ans, Tm] = runcoin(obj)
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            w = obj.w;
            width = obj.width;
            I = obj.I;
            height = obj.height;
            b = 4;
            rate = obj.quest.rate{4};
            T = length(rate);
            Tm.fix = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Ans.name = 'The Biased Coin task';            
            Ans.rate = zeros(T,1);
            obj.instcoin;
            
            obj.eyetrack.inc(3);
            obj.eyetrack.msg('Coin');
            for t = 1:T
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q(t)=Tm.fix(t)+obj.interTrialTime();
                [Ans.rate(t), Tm.end(t)] = obj.ratetrial(b, t, 1, Tm.q(t));
            end
            
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Tm.fix(t+1)=Screen(w,'Flip');
            obj.eyetrack.msg('fix');
            Tm.endall=Tm.fix(t+1)+obj.interTrialTime();
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall);
            obj.eyetrack.msg('end');
            WaitSecs(2);
        end
        
        function [Ans, Tm, Type] = runanchor(obj)
            
            obj.eyetrack.inc(2);
            obj.eyetrack.msg('Anchoring');
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            w = obj.w;
            width = obj.width;
            I = obj.I;
            height = obj.height;
            T = length(obj.quest.anchor);
            Tm.fix = zeros(T,1);
            Tm.q1 = zeros(T,1);
            Tm.q2 = zeros(T,1);
            Tm.end = zeros(T,1);
            Ans.name = 'Anchoring Bias';            
            Ans.bin = zeros(T,1);
            Ans.binok = zeros(T,1);
            Ans.free = zeros(T,1);
            Type = zeros(T,1);
            
            for t = 1:T
                Type(t) = obj.quest.anchor(t).type;
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q1(t)=Tm.fix(t)+obj.interTrialTime();
                [Ans.bin(t), Ans.free(t), Tm.q2(t), Tm.end(t)] = obj.anchortrial(t, Tm.q1(t));
                if t~=6 % question 6 is the only one in which the answers are reversed
                    Ans.binok(t) = Ans.bin(t)==Type(t);
                else
                    Ans.binok(t) = Ans.bin(t)==3-Type(t);
                end
            end
            
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Tm.fix(t+1)=Screen(w,'Flip');
            obj.eyetrack.msg('fix');
            Tm.endall=Tm.fix(t+1)+obj.interTrialTime();
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall);
            obj.eyetrack.msg('end');
            WaitSecs(2);
        end
        
        function [binans, freeans, t2, tend] = anchortrial(obj, iq, t1)
            
            quest = obj.quest.anchor(iq); %#ok<*PROP>
            text = obj.text;
            width = obj.width;
            set = 1;            
            refy = round(2*obj.height/5);
            y = refy;
            
            % binary question
            for i=1:length(quest.quest1)-1
                [~, y] = text.drawWrappedText(quest.quest1{i},[],y + text.lineh(set),set,'center');
            end
            [~, y] = text.drawWrappedText([quest.quest1{i+1} quest.anchor{quest.type} quest.post1],[],y + text.lineh(set),set,'center');
            x = round((width - text.textWidth(quest.ans{1},1))/2);
            y = y + + text.lineh(set);
            for i=1:length(quest.ans)
                [~, y(i+1)] = obj.text.drawWrappedText(quest.ans{i}, x, y(i) + text.lineh(set), set);
            end
            Screen('Flip',obj.w,t1,1);
            obj.eyetrack.msg('trialonset');
            WaitSecs(0.3);
            keys = repmat(obj.refkeys(1:length(quest.ans)),1,2);
            for i = length(keys)/2+1:length(keys)
                key = KbName(keys(i));
                keys(i) = KbName(key(1));
            end
            key = Utilities.waitForInput(keys, inf);
            binans = find(keys==key(1),1);
            if isempty(binans)
                binans = find(keys==key(2),1);
            end
            if binans>length(quest.ans); binans = binans - length(quest.ans); end
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            obj.text.drawWrappedText(quest.ans{binans}, x, y(binans) + text.lineh(set), set+1);
            Screen('Flip',obj.w);
            WaitSecs(1);
            
            % open question
            y = refy;
            for i=1:length(quest.quest2)
                [~, y] = text.drawWrappedText(quest.quest2{i},[],y + text.lineh(set),set,'center');
            end
            text.drawWrappedText('Type answer and then press Enter', [], y + text.lineh(set)*5, set+1, 'center');
            freeans = nan;
            obj.eyetrack.msg('open');
            while isnan(freeans)
                Screen('FillRect', obj.w, obj.col, [0 y + text.lineh(1) width y + 2.5*text.lineh(1)]);
                t2 = GetSecs;
                freeans = str2double(text.input(x, y + text.lineh(1)*2, [],quest.post2));
            end
            tend = Screen('Flip', obj.w);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
        end
        
        function [rating, te] = ratetrial(obj, ib, iq, type, t)
            
            title = obj.quest.rate{ib}(iq).title;
            att = obj.quest.rate{ib}(iq).att;
            bar = obj.quest.rate{ib}(iq).bar;
            att(2) = att(type+1);
            if ib==3 && type==2
                att(1).post = att(2).post;
                att(1).val = 100-att(1).val;
            end
            if ib==2
                val{1} = sprintf('%4.2f' ,att(1).val);
            else
                val{1} = num2str(att(1).val);
            end
            val{2} = num2str(att(2).val);
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            text = obj.text; 
            w = obj.w;
            I = obj.I;
            refx = round(width/5);
            refy = round(height/2) - round(5*text.lineh(1)/2);
            rating = 50;
            
            [~, y] = text.drawWrappedText(title, refx, refy, 2);
            [x y] = text.drawWrappedText(att(1).txt, refx, y + text.lineh(1)*2, 1);
            text.drawWrappedText([att(1).pre val{1} att(1).post], x, y, 4);
            [x y] = text.drawWrappedText(att(2).txt, refx, y + text.lineh(1)*2, 1);
            text.drawWrappedText([att(2).pre val{2} att(2).post], x, y, 4);
            
            x2 = width/2 + I.rtbrsz(1)*2;
            y2 = (height - I.rtbrsz(2))/2;
            for i=1:length(bar.high)
                text.drawWrappedText(bar.high{end+1-i}, x2+round(I.rtbrsz(1,1)/2), y2 - round(text.lineh(1)*(i-.5)), 1, 'center');
            end
            for i=1:length(bar.low)
                text.drawWrappedText(bar.low{i}, x2+round(I.rtbrsz(1,1)/2), y2 + I.rtbrsz(1,2) + round(text.lineh(1)*i), 1, 'center');
            end
            
            key = -1;
            while ~sum([key==KbName('return')  (ismac && key==KbName('ENTER'))])
                y3 = y2+I.rtbrsz(1,2)*(100-rating)/100.0;
                rect = [x2+1 y3 x2+I.rtbrsz(1,1)-2.0 y2+I.rtbrsz(1,2)]';
                Screen('Fillrect',w, [15 102 182], rect);
                rect = [x2+1 y2 x2+I.rtbrsz(1,1)-2.0 y3]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x2+I.rtbrsz(1,1) y2+I.rtbrsz(1,2)]';
                Screen('DrawTexture', w, I.rtbrtxtr, [], rect);
                Screen('Flip', w, t, 1);
                if key == -1
                    obj.eyetrack.msg('trialonset');
                    t = [];
                end
                keys = [KbName('DownArrow') KbName('UpArrow') KbName('return')];
                if ismac 
                    keys = [keys KbName('ENTER')]; 
                end
                key = Utilities.waitForInput(keys,Inf);
                key = key(1);
                WaitSecs(0.14);
                if sum(key==KbName('UpArrow'))
                    rating = min(rating + 5, 100);
                elseif sum(key==KbName('DownArrow'))
                    rating = max(rating - 5, 0);
                end
            end
            te = Screen('Flip', w);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
        end
        
        function [Ans, Tm, Type] = runoption1(obj)
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            w = obj.w;
            width = obj.width;
            I = obj.I;
            height = obj.height;
            T = length(obj.quest.option);
            Tm.fix = zeros(T,1);
            Tm.fix2 = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Tm.endall = zeros(T,1);
            Ans.name = 'Decision Making';            
            Ans.opt = zeros(T,1);
            Type = [1 1 1 1 2 2 1];
            if obj.type==1; Type = 3-Type; end
            
            
            for t = 1:2
                switch t
                    case 1
                        obj.instoption1(Type(t));
                    case 2
                        obj.instoption2(Type(t));
                    case 3
                        obj.instoption3(Type(t));
                    case 4
                        obj.instoption4(Type(t));
                    case 5
                        obj.instoption5(Type(t));
                    case 6
                        obj.instoption6(Type(t));
                    case 7
                        obj.instoption7(Type(t));
                end  
                obj.eyetrack.inc(6+t);
                obj.eyetrack.msg(['Options' num2str(t)]);
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q(t)=Tm.fix(t)+obj.interTrialTime();
                [Ans.opt(t), Tm.end(t)] = obj.optiontrial(t, Type(t), Tm.q(t));
                
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix2(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.endall(t)=Tm.fix2(t)+obj.interTrialTime();
                if t<T; WaitSecs('UntilTime', Tm.endall(t));end
                obj.eyetrack.msg('end');
            end
            
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall(end));
            WaitSecs(2);
        end     
        
        function [Ans, Tm, Type] = runoption2(obj)
            
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{1})');
            w = obj.w;
            width = obj.width;
            I = obj.I;
            height = obj.height;
            T = length(obj.quest.option);
            Tm.fix = zeros(T,1);
            Tm.fix2 = zeros(T,1);
            Tm.q = zeros(T,1);
            Tm.end = zeros(T,1);
            Tm.endall = zeros(T,1);
            Ans.name = 'Decision Making';            
            Ans.opt = zeros(T,1);
            Type = [1 1 1 1 2 2 1];
            if obj.type==1; Type = 3-Type; end
            
            
            for t = 3:7
                switch t
                    case 1
                        obj.instoption1(Type(t));
                    case 2
                        obj.instoption2(Type(t));
                    case 3
                        obj.instoption3(Type(t));
                    case 4
                        obj.instoption4(Type(t));
                    case 5
                        obj.instoption5(Type(t));
                    case 6
                        obj.instoption6(Type(t));
                    case 7
                        obj.instoption7(Type(t));
                end  
                obj.eyetrack.inc(6+t);
                obj.eyetrack.msg(['Options' num2str(t)]);
                %fixation point\
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.q(t)=Tm.fix(t)+obj.interTrialTime();
                [Ans.opt(t), Tm.end(t)] = obj.optiontrial(t, Type(t), Tm.q(t));
                
                Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                Tm.fix2(t)=Screen(w,'Flip');
                obj.eyetrack.msg('fix');
                Tm.endall(t)=Tm.fix2(t)+obj.interTrialTime();
                if t<T; WaitSecs('UntilTime', Tm.endall(t));end
                obj.eyetrack.msg('end');
            end
            
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip', Tm.endall(end));
            WaitSecs(2);
        end     
        
        function [rating, te]= optiontrial(obj, iq, type, t)
            
            title = obj.quest.option(iq).title;
            att = obj.quest.option(iq).att;
            bar = obj.quest.option(iq).bar;
            width = obj.width;
            height = obj.height; %#ok<*PROP>
            text = obj.text; 
            w = obj.w;
            I = obj.I;
            refy = round(height/5);
            rating = 0;
            
            if length(title)>1
                title = title{type};
            else
                title = title{1};
            end
            for i=1:length(att)
                if length(att(i).txt)>1
                    att(i).txt{1} = att(i).txt{type};
                end
            end
            
            text.drawWrappedText(title, [], refy, 2, 'center');
            marg = round(width/16);
            space = marg;
            x = marg;
            [~, y] = text.drawWrappedText(bar{1}, round((marg + (width-space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], round((width+space)/2));
            for i=1:length(att(1).txt{1})
                [~, y] = text.drawWrappedText(att(1).txt{1}{i}, x, y  + text.lineh(1), 1, [] , x, [], round((width+space)/2));
            end
            maxy = y;
            x = round((width+space)/2);
            [~, y] = text.drawWrappedText(bar{2}, round((width-marg + (width+space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], marg);
            for i=1:length(att(2).txt{1})
                [~, y] = text.drawWrappedText(att(2).txt{1}{i}, x, y + text.lineh(1), 1, [] , x, [], marg);
            end
            maxy = max(y, maxy);
            
            x2 = round((width - I.opbrsz(1))/2);
            x4 = x2 + I.opbrsz(1,1);
            y2 = maxy + text.lineh(1)*2;
            text.drawWrappedText(bar{1}, x2 - text.textWidth(bar{1},1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
            text.drawWrappedText(bar{2}, x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);

            key = -1;
            while ~sum([key==KbName('return')  (ismac && key==KbName('ENTER'))])
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
                Screen('Flip', w, t, 1);
                if key==-1
                    t = [];
                    obj.eyetrack.msg('trialonset');
                end
                keys = [KbName('LeftArrow') KbName('RightArrow') KbName('return')];
                if ismac 
                    keys = [keys KbName('ENTER')]; 
                end
                key = Utilities.waitForInput(keys,Inf);
                key = key(1);
                WaitSecs(0.14);
                if sum(key==KbName('RightArrow'))
                    rating = min(rating + 5, 50);
                elseif sum(key==KbName('LeftArrow'))
                    rating = max(rating - 5, -50);
                end
            end
            te = Screen('Flip', w);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            
        end

        function instrate1(obj, type)

            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            rate = obj.quest.rate{1};
            
            I = obj.I;
            w = obj.w;
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 2;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(10);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Gambling', [], basey, 4);
                        [~, y] = text.drawWrappedText('In this task, you will be presented with a series of potential gambles.', [], round(y + text.lineh(1)*1.5),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('For each gamble, imagine that you start out with $10 and that you can either keep the $10 and not play the gamble or pay the $10 to take the gamble.', [], round(y + text.lineh(1)*1.5),[],[],[],[],150); 
                    case 2
                        showbar(50);
                        [~, y] = text.drawWrappedText('Your task is to rate how likely you are to take each gamble.', [], basey, 1, 'left', [], [], width/2);
                        text.drawWrappedText('Press space to start rating the gambles', [], y + text.lineh(1)*2, 2, 'left', [], [], width/2);
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showbar(rating)
                x2 = width/2 + I.rtbrsz(1)*2;
                y2 = (height - I.rtbrsz(2))/2;
                for i=1:length(rate(1).bar.high) %#ok<*FXUP>
                    text.drawWrappedText(rate(1).bar.high{end+1-i}, x2+round(I.rtbrsz(1,1)/2), y2 - round(text.lineh(1)*(i-.5)), 1, 'center');
                end
                for i=1:length(rate(1).bar.low)
                    text.drawWrappedText(rate(1).bar.low{i}, x2+round(I.rtbrsz(1,1)/2), y2 + I.rtbrsz(1,2) + round(text.lineh(1)*i), 1, 'center');
                end
                y3 = y2+I.rtbrsz(1,2)*(100-rating)/100.0;
                rect = [x2+1 y3 x2+I.rtbrsz(1,1)-2.0 y2+I.rtbrsz(1,2)]';
                Screen('Fillrect',w, [15 102 182], rect);
                rect = [x2+1 y2 x2+I.rtbrsz(1,1)-2.0 y3]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x2+I.rtbrsz(1,1) y2+I.rtbrsz(1,2)]';
                Screen('DrawTexture', w, I.rtbrtxtr, [], rect);
            end
        end

        function instrate2(obj, type)

            b = 2;
            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            rate = obj.quest.rate{b};
            I = obj.I;
            w = obj.w;
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(12);

                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Ground Beef', [], basey, 4);
                        [~, y] = text.drawWrappedText('In this task, you will be presented with different ground beef products.', [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('Imagine that you are having a friend over for dinner and you are about to make your favorite lasagna dish with ground beef.', [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('Your job is to rate how satisfied you would be purchasing each of the ground beef products.', [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('Press space to start', [], y + text.lineh(1)*3, 2, 'center'); 
                        text.drawWrappedText('rating the ground beef', [], y + text.lineh(1), 2, 'center');
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showbar(rating)
                x2 = width/2 + I.rtbrsz(1)*2;
                y2 = (height - I.rtbrsz(2))/2;
                for i=1:length(rate(1).bar.high)
                    text.drawWrappedText(rate(1).bar.high{end+1-i}, x2+round(I.rtbrsz(1,1)/2), y2 - round(text.lineh(1)*(i-.5)), 1, 'center');
                end
                for i=1:length(rate(1).bar.low)
                    text.drawWrappedText(rate(1).bar.low{i}, x2+round(I.rtbrsz(1,1)/2), y2 + I.rtbrsz(1,2) + round(text.lineh(1)*i), 1, 'center');
                end
                y3 = y2+I.rtbrsz(1,2)*(100-rating)/100.0;
                rect = [x2+1 y3 x2+I.rtbrsz(1,1)-2.0 y2+I.rtbrsz(1,2)]';
                Screen('Fillrect',w, [15 102 182], rect);
                rect = [x2+1 y2 x2+I.rtbrsz(1,1)-2.0 y3]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x2+I.rtbrsz(1,1) y2+I.rtbrsz(1,2)]';
                Screen('DrawTexture', w, I.rtbrtxtr, [], rect);
            end
        end
       
        function instrate3(obj, type)

            b = 3;
            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            rate = obj.quest.rate{b};
            I = obj.I;
            w = obj.w;
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(14);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Student Performance', [], basey, 4);
                        [~, y] = text.drawWrappedText('In the next part, your task is to evaluate each student on the basis of midterm exam and final exam performance.', [], round(y + text.lineh(1)*1.5),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('Press space to start', [], y + text.lineh(1)*3, 2, 'center'); 
                        text.drawWrappedText('evaluating students'' performance', [], y + text.lineh(1), 2, 'center');
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showbar(rating)
                x2 = width/2 + I.rtbrsz(1)*2;
                y2 = (height - I.rtbrsz(2))/2;
                for i=1:length(rate(1).bar.high)
                    text.drawWrappedText(rate(1).bar.high{end+1-i}, x2+round(I.rtbrsz(1,1)/2), y2 - round(text.lineh(1)*(i-.5)), 1, 'center');
                end
                for i=1:length(rate(1).bar.low)
                    text.drawWrappedText(rate(1).bar.low{i}, x2+round(I.rtbrsz(1,1)/2), y2 + I.rtbrsz(1,2) + round(text.lineh(1)*i), 1, 'center');
                end
                y3 = y2+I.rtbrsz(1,2)*(100-rating)/100.0;
                rect = [x2+1 y3 x2+I.rtbrsz(1,1)-2.0 y2+I.rtbrsz(1,2)]';
                Screen('Fillrect',w, [15 102 182], rect);
                rect = [x2+1 y2 x2+I.rtbrsz(1,1)-2.0 y3]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x2+I.rtbrsz(1,1) y2+I.rtbrsz(1,2)]';
                Screen('DrawTexture', w, I.rtbrtxtr, [], rect);
            end
        end
       
        function instcoin(obj)

            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            rate = obj.quest.rate{4};
            I = obj.I;
            w = obj.w;
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 7;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(5);

                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Biased coins', [], basey, 4);
                        [~, y] = text.drawWrappedText('Imagine that you are spinning a coin, and recording how often the coin lands heads and how often the coin lands tails.', [], y + text.lineh(1)*2); 
                        [~, y] = text.drawWrappedText('Unlike tossing, which (on average) yields an equal number of heads and tails, spinning a coin leads to a bias favoring one side or the other because of slight imperfections on the rim of the coin (and an uneven distribution of mass).', [], y + text.lineh(1)*2); 
                        text.drawWrappedText('Now imagine that you know that this bias is 3/5. It tends to land on one side 3 out of 5 times. But you do not know if this bias is in favor of heads or in favor of tails.', [], y + text.lineh(1)*2);
                    case 2
                        [~, y] = text.drawWrappedText('You will be presented with 10 different sets of results (number of heads and number of tails), in which the heads always outnumber the tails.', [], basey, 1);
                        [~, y] = text.drawWrappedText('How certain would you be, given each set of results, that the coin is biased in favor of heads rather than tails?', [], y + text.lineh(1)*2, 1);
                        text.drawWrappedText('Note, each set of results represents an alternative scenario. Therefore, your assessment for each set of results should reflect that set only, and not any of the other sets.', [], y + text.lineh(1)*2, 1);
                    case 3
                        showbar(50);
                        [x, y] = text.drawWrappedText('If you think that it is ', [], basey, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('much more likely ', x, y, 2, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('that the coin is biased in favor of heads, use the ', x, y, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('up arrow key ', x, y, 2, 'left', [], [], width/2);
                        [~, y] = text.drawWrappedText('to raise the bar.', x, y, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('If you think that it is ', [], y + text.lineh(1)*2, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('a bit more likely ', x, y, 2, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('that the coin is biased in favor of heads, use the ', x, y, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('down arrow key ', x, y, 2, 'left', [], [], width/2);
                        text.drawWrappedText('to lower the bar.', x, y, 1, 'left', [], [], width/2);
                    case 4
                        showbar(100);
                        text.drawWrappedText('If you are completely certain that the coin is biased to favor heads, move the bar all the way up.', [], basey, 1, 'left', [], [], width/2);
                    case 5
                        showbar(0);
                        text.drawWrappedText('If you are completely uncertain as to which way the coin is biased, move the bar all the way down.', [], basey, 1, 'left', [], [], width/2);
                    case 6
                        showbar(40);
                        [~, y] = text.drawWrappedText('Otherwise, set the bar to indicate how certain you are that the coin favors heads.', [], basey, 1, 'left', [], [], width/2);
                        text.drawWrappedText('The more certain you are, the higher the bar should be.', [], y + text.lineh(1)*2, 1, 'left', [], [], width/2);
                    case 7
                        showbar(40);
                        [x, y] = text.drawWrappedText('Once you asjusted the bar according to your assessment, press ', [], basey, 1, 'left', [], [], width/2);
                        [x, y] = text.drawWrappedText('Enter ', x, y, 2, 'left', [], [], width/2);
                        [~, y] = text.drawWrappedText('to submit your assessment and move on to the next set of results.', x, y, 1, 'left', [], [], width/2);
                        [~, y] = text.drawWrappedText('Press space to start the Biased Coin task', [], y + text.lineh(1)*2, 2, 'left', [], [], width/2); 
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showbar(rating)
                x2 = width/2 + I.rtbrsz(1)*2;
                y2 = (height - I.rtbrsz(2))/2;
                for i=1:length(rate(1).bar.high)
                    text.drawWrappedText(rate(1).bar.high{end+1-i}, x2+round(I.rtbrsz(1,1)/2), y2 - round(text.lineh(1)*(i-.5)), 1, 'center');
                end
                for i=1:length(rate(1).bar.low)
                    text.drawWrappedText(rate(1).bar.low{i}, x2+round(I.rtbrsz(1,1)/2), y2 + I.rtbrsz(1,2) + round(text.lineh(1)*i), 1, 'center');
                end
                y3 = y2+I.rtbrsz(1,2)*(100-rating)/100.0;
                rect = [x2+1 y3 x2+I.rtbrsz(1,1)-2.0 y2+I.rtbrsz(1,2)]';
                Screen('Fillrect',w, [15 102 182], rect);
                rect = [x2+1 y2 x2+I.rtbrsz(1,1)-2.0 y3]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x2+I.rtbrsz(1,1) y2+I.rtbrsz(1,2)]';
                Screen('DrawTexture', w, I.rtbrtxtr, [], rect);
            end
        end
       
        function insturn(obj)
            
            text = obj.text;
            height = obj.height;
            width = obj.width;
            I = obj.I;
            w = obj.w;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 9;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(22);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('The Urns Game', [], basey, 4);
                        [~, y] = text.drawWrappedText('~ Each of these two urns has 10 balls in it', [], y + text.lineh(1)*2);
                        text.drawWrappedText('~ Only one these urns will be used in this experiment, but you do not know which one it is', [], y + text.lineh(1)*1);
                        marg = width/8;
                        space = marg;
                        refy = y+text.lineh(1)*4;
                        showUrns;
                        maxy = refy+I.urnsz(1,2);
                    case 2
                        [~, y] = text.drawWrappedText('~ On each trial, a random ball will be taken out of the urn, shown to you, and then put back into the urn', [], basey);
                        text.drawWrappedText('~ Your task is to figure out which urn the balls are from', [], y + text.lineh(1)*2);
                        showUrns;
                    case 3
                        showUrns;
                        showBall(1);
                        text.drawWrappedText('~ For example, if a red ball is shown, that makes Urn A more likely to be the source, since there are more red balls in Urn A than in Urn B', [], basey);
                    case 4
                        showUrns;
                        showBall(3);
                        text.drawWrappedText('~ In contrast, a green ball makes Urn B more likely to be the source', [], basey);
                    case 5
                        showUrns;
                        [~, y] = text.drawWrappedText('~ After each sequence of 5 balls, you will be asked to update your assessment as to which urn the balls are coming from', [], basey);
                        text.drawWrappedText('~ Note, all the balls that you will see come from the same urn. Thus, you should always take into account all the balls that you have seen, not just the last 5', [], y + text.lineh(1)*2);
                    case 6
                        showUrns;
                        [~, y] = text.drawWrappedText('~ Your first assessment should take into account the first 5 balls, your second assesment - the first 10 balls, your third assessment - the first 15 balls, and so on', [], basey);
                    case 7
                        showUrns;
                        [x, y] = text.drawWrappedText('~ Overall, you will be shown a series of 90 draws, all from the same urn', [], basey);
                        [~, y] = text.drawWrappedText('~ However, since balls of all colors exist in both urns, you can never be completely certain about which urn the balls are drawn from', [], y + round(text.lineh(1)*1.5));
                    case 8
                        showUrns;
                        [x, y] = text.drawWrappedText('~ For example, even if you see 2 blue balls one after the other, that would not exclude Urn B (which has only 1 blue ball), since it is possible that the same ball would be drawn from Urn B twice in a row', [], basey);
                    case 9
                        showBar(0);
                        [x, y] = text.drawWrappedText('~ After each series of 5 draws, use the bar to indicate which urn you favor, and how certain you are about your choice', [], basey);
                        [~, y] = text.drawWrappedText('~ The more certain you are about the urn, the closer the bar should be to that urn', [], y + text.lineh(1)*2);
                        text.drawWrappedText('Press space to start the Urn Game', [], y + text.lineh(1)*2, 2, 'center');
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showBar(rating)
                x2 = round((width - I.opbrsz(1))/2);
                x4 = x2 + I.opbrsz(1,1);
                y2 = maxy - text.lineh(1)*3;
                text.drawWrappedText('Urn A', x2 - text.textWidth('Urn A',1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
                text.drawWrappedText('Urn B', x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
            end                
            
            function showBall(b)
                oldVolume = PsychPortAudio('Volume', obj.snd.pahandle);
                PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{2})');                
                x = round((width-I.ballsz(b,1))/2);
                spd = 20;
                y= -I.ballsz(b,2);
                rect = [0 0 1 1]';
                while abs(spd)>0.5 || y+I.ballsz(b,2)<maxy
                   y = y + spd;
                   Screen('FillRect',w, obj.col, rect);
                   rect = [x y x+I.ballsz(b,1) y+I.ballsz(b,2)]';
                   Screen('DrawTexture', w, I.balltxtr(b), [], rect);
                   Screen('Flip',w,[],1);
                   if spd>0 && y+I.ballsz(b,2)>maxy
                       PsychPortAudio('Volume', obj.snd.pahandle, spd/50);
                       PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
                       spd = -spd*2/3;
                   else
                       spd = spd + 1;
                   end
                end
                Screen('FillRect',w, obj.col, rect);
                Screen('Flip',w,GetSecs+.3,1);
                PsychPortAudio('Volume', obj.snd.pahandle, oldVolume);
            end                
            
            function showUrns
                x = round((marg + (width-space)/2)/2);
                text.drawWrappedText('Urn A', x, refy+50, 2, 'center' , marg, [], round((width+space)/2));
                i = 1;
                x = x-round(I.urnsz(i,1)/2);
                Screen('DrawTexture', w, I.urntxtr(i), [], [x refy x+I.urnsz(i,1) refy+I.urnsz(i,2)]);
                x = round((width-marg + (width+space)/2)/2);
                text.drawWrappedText('Urn B', x, refy+50, 2, 'center' , round((width+space)/2), [], marg);
                i = 2;
                x = x-round(I.urnsz(i,1)/2);
                Screen('DrawTexture', w, I.urntxtr(i), [], [x refy x+I.urnsz(i,1) refy+I.urnsz(i,2)]);
            end
        end            
        
        function instdsq(obj)
            
            text = obj.text;
            height = obj.height;
            width = obj.width;
            I = obj.I;
            w = obj.w;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(77);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Defense Style Questionnaire', [], basey, 4);
                        [~, y] = text.drawWrappedText('This questionnaire consists of a number of statements about personal attitides. There are no right or wrong answers.', [], y + text.lineh(1)*2);
                        text.drawWrappedText('Using the bar that is shown below, indicate how much you agree or disagree with each statement.', [], y + text.lineh(1)*2);
                        showBar(0);
                        text.drawWrappedText('press space to start the questionnaire', [], round(height-text.lineh(1)*2),2,'center' ); 
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showBar(rating)
                x2 = round((width - I.opbrsz(1))/2);
                x4 = x2 + I.opbrsz(1,1);
                y2 = round(2*obj.height/3 - text.lineh(1)*0);
                text.drawWrappedText('Strongly disagree', x2 - text.textWidth('Strongly disagree',1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1, [], 0 ,[] ,0);
                text.drawWrappedText('Strongly agree', x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1, [], 0 ,[] ,0);
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
            end                
            
        end            
        
        function instoption1(obj, type)
            
            w = obj.w;
            I = obj.I;
            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 7;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(15);
                
                switch count
                    case 1
                        showBar(0);
                        [~, y] = text.drawWrappedText('Making Decisions', [], basey,4);
                        [~, y] = text.drawWrappedText('~ In the next part of the experiment, we will ask you to make decisions in different kinds of scenarios', [], y+text.lineh(1)*2, 1);
                        text.drawWrappedText('~ In each scenario, you will be asked to decide between two specified options', [], y+text.lineh(1)*2, 1);
                    case 2
                        showBar(-50);
                        [x, y, shift] = text.drawWrappedText('~ If you are completely certain that you prefer Option A, use the ', [], basey);
                        [x, y] = text.drawWrappedText('left arrow key ', x, y, 2, [], [], shift);
                        text.drawWrappedText('to move the bar all the way to the left', x, y, 1, [], [], shift);
                    case 3
                        showBar(50);
                        [x, y, shift] = text.drawWrappedText('~ If you are completely certain that you prefer Option A, use the ', [], basey);
                        [x, y] = text.drawWrappedText('left arrow key ', x, y, 2, [], [], shift);
                        [~, y] = text.drawWrappedText('to move the bar all the way to the left', x, y, 1, [], [], shift);
                        [x, y, shift] = text.drawWrappedText('~ If you are completely certain that you prefer option B, use the ', [], y + text.lineh(1)*2);
                        [x, y] = text.drawWrappedText('right arrow key ', x, y, 2, [], [], shift);
                        text.drawWrappedText('to move the bar all the way to the right', x, y, 1, [], [], shift);
                    case 4
                        showBar(30);
                        [~, y] = text.drawWrappedText('~ If you prefer one of the options but you are not certain, move the bar towards that option to indicate to what extent you favor it', [], basey);
                        text.drawWrappedText('~ The more certain you are about the option, the closer the bar should be to that option', [], y + text.lineh(1)*2);
                    case 5
                        showBar(0);
                        [~, y] = text.drawWrappedText('~ If you don''t favor either one of the options, position the bar in the middle', [], basey);
                        [x, y, shift] = text.drawWrappedText('~ Press ', [], y + text.lineh(1)*2);
                        [x, y] = text.drawWrappedText('Enter ', x, y, 2, [], [],shift);
                        text.drawWrappedText('to submit your preference and move on to the next scenario', x, y, 1, [], [],shift);
                    case 6
                        [~, y] = text.drawWrappedText('Medical scenario', [], basey, 4);
                        [~, y] = text.drawWrappedText('Suppose there is an outbreak of a deadly disease at an island with 600 inhabitants. All inhabitants have been infected.', [], y + text.lineh(1)*2);
                        text.drawWrappedText('The vaccine which has been used up to now to combat this disease leads to a rather certain prediction. There is also a new vaccine available of which the results are less certain.', [], y + text.lineh(1)*2);
                    case 7
                        [~, y] = text.drawWrappedText('Your job is to decide which of the two vaccines to use. You have a choice between two options with the following consequences:', [], basey);
                        [x, y] = text.drawWrappedText('Vaccine A: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(obj.quest.option(1).att(1).txt{type}{1}, x, y);
                        [x, y] = text.drawWrappedText('Vaccine B: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(obj.quest.option(1).att(2).txt{type}{1}, x, y);
                        [~, y] = text.drawWrappedText('Which vaccine would you choose?', [], y + text.lineh(1)*2, 1);
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        text.drawWrappedText('which vaccine you would choose', [], y + text.lineh(1), 2, 'center');
                end
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            function showBar(rating)
                x2 = round((width - I.opbrsz(1))/2);
                x4 = x2 + I.opbrsz(1,1);
                y2 = round(8*height/10);
                text.drawWrappedText('Option A', x2 - text.textWidth('Option A',1)-10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
                text.drawWrappedText('Option B', x2 + I.opbrsz(1)+10, round(y2 + (I.opbrsz(2)+text.lineh(1)/2)/2), 1);
                x3 = round(x2 + (x4-x2-I.opnbsz(1,1))*((rating+50)/100));
                y3 = y2 + round((I.opbrsz(1,2)-I.opnbsz(1,2))/2);
                rect = [x2 y3 x4 y3+I.opnbsz(1,2)]';
                Screen('Fillrect',w, [100 100 100], rect);
                rect = [x2 y2 x4 y2+I.opbrsz(1,2)]';
                Screen('DrawTexture', w, I.opbrtxtr, [], rect);
                rect = [x3 y3 x3+I.opnbsz(1,1) y3+I.opnbsz(1,2)]';
                Screen('DrawTexture', w, I.opnbtxtr(1), [], rect);
            end                
            
        end
       
        function instoption2(obj, type)

            text = obj.text;
            height = obj.height;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 2;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(16);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Fire scenario', [], basey, 4);
                        [~, y] = text.drawWrappedText('Suppose there is an outbreak of forest fires (9000 acres of forest are under threat).', [], y + text.lineh(1)*2);
                        text.drawWrappedText('The authorities are forced to choose between two options to combat these large scale fires. Option A is the traditionally used method, leading to a rather certain prediction of the results. Option B involves a new fire fighting method. The results of this method seem more dependent on all kinds of circumstances. Therefore, the predicted outcome is less certain.', [], y + text.lineh(1)*2);
                    case 2
                        [~, y] = text.drawWrappedText('The predicted consequences for both methods are:', [], basey, 1);
                        [x, y] = text.drawWrappedText('Option A: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(obj.quest.option(2).att(1).txt{type}{1}, x, y);
                        [x, y] = text.drawWrappedText('Option B: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(obj.quest.option(2).att(2).txt{type}{1}, x, y);
                        [~, y] = text.drawWrappedText('Which option would you choose?', [], y + text.lineh(1)*2, 1);
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        text.drawWrappedText('which option you would choose', [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function instoption3(obj, type)

            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 2;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(17);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Child custody scenario', [], basey, 4);
                        [~, y] = text.drawWrappedText('Imagine that you serve on the jury of an only-child sole-custody case following a relatively messy divorce.', [], y + text.lineh(1)*2);
                        text.drawWrappedText('The facts of the case are complicated by ambiguous economic, social, and emotional considerations, and you decide to base your decision entirely on the following few observations.', [], y + text.lineh(1)*2);
                    case 2
                        if type==1
                            str = 'To which parent would you award sole custody of the child?';
                        else
                            str = 'Which parent would you deny sole custody of the child?';
                        end
                        [~, refy] = text.drawWrappedText(str, [], basey, 1, 'center');
                        marg = round(width/16);
                        space = marg;
                        x = marg;
                        [~, y] = text.drawWrappedText('Parent A', round((marg + (width-space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], round((width+space)/2));
                        att = obj.quest.option(3).att;
                        for i=1:length(att(1).txt{1})
                            [~, y] = text.drawWrappedText(att(1).txt{1}{i}, x, y  + text.lineh(1), 1, [] , x, [], round((width+space)/2));
                        end
                        x = round((width+space)/2);
                        [~, y] = text.drawWrappedText('Parent B', round((width-marg + (width+space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], marg);
                        for i=1:length(att(2).txt{1})
                            [~, y] = text.drawWrappedText(att(2).txt{1}{i}, x, y + text.lineh(1), 1, [] , x, [], marg);
                        end
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        if type == 1
                            str = 'to which parent you would award custody';
                        else
                            str = 'which parent you would deny custody';
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function instoption4(obj, type)

            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 2;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(18);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Vacation scenario', [], basey, 4);
                        [~, y] = text.drawWrappedText('Imagine that you are planning a week vacation in a warm spot over spring break.', [], y + text.lineh(1)*2);
                        str = 'You currently have two options that are reasonably priced';
                        if type == 1
                            str = [str '.']; %#ok<AGROW>
                        else
                            str = [str ', but you can no longer retain you reservation for both.']; %#ok<AGROW>
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1)*2);
                            
                    case 2
                        if type==1
                            str = 'Given the information available, which vacation spot would you prefer?';
                        else
                            str = 'Given the information available, which reservation do you decide to cancel?';
                        end
                        [~, refy] = text.drawWrappedText(str, [], basey, 1, 'center');
                        marg = round(width/16);
                        space = marg;
                        x = marg;
                        [~, y] = text.drawWrappedText('Spot A', round((marg + (width-space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], round((width+space)/2));
                        att = obj.quest.option(4).att;
                        for i=1:length(att(1).txt{1})
                            [~, y] = text.drawWrappedText(att(1).txt{1}{i}, x, y  + text.lineh(1), 1, [] , x, [], round((width+space)/2));
                        end
                        x = round((width+space)/2);
                        [~, y] = text.drawWrappedText('Spot B', round((width-marg + (width+space)/2)/2), refy + text.lineh(1)*2, 2, 'center' , x, [], marg);
                        for i=1:length(att(2).txt{1})
                            [~, y] = text.drawWrappedText(att(2).txt{1}{i}, x, y + text.lineh(1), 1, [] , x, [], marg);
                        end
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        if type == 1
                            str = 'which vacation spot you would prefer';
                        else
                            str = 'which reservation you decide to cancel';
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function instoption5(obj, type)

            text = obj.text;
            height = obj.height;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(19);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Lottery scenario 1', [], basey, 4);
                        if type==1
                            str = 'Imagine that you were invited to play one of the following two lotteries. Which one would you prefer?';
                        else
                            str = 'Imagine that you owned tickets to play the following two lotteries, but had to return one. Which one would you prefer to give up?';
                        end
                        [~, refy] = text.drawWrappedText(str, [], y + text.lineh(1)*2, 1);
                        att = obj.quest.option(5).att;
                        [x, y] = text.drawWrappedText('Lottery 1: ', [], refy + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(att(1).txt{1}{1}, x, y, 1);
                        [x, y] = text.drawWrappedText('Lottery 2: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(att(2).txt{1}{1}, x, y, 1);
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        if type == 1
                            str = 'which lottery you would prefer';
                        else
                            str = 'which lottery you would prefer to give up';
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function instoption6(obj, type)

            text = obj.text;
            height = obj.height;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(20);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Lottery scenario 2', [], basey, 4);
                        if type==1
                            str = 'Imagine that you were invited to play one of the following two lotteries. Which one would you prefer?';
                        else
                            str = 'Imagine that you owned tickets to play the following two lotteries, but had to return one. Which one would you prefer to give up?';
                        end
                        [~, refy] = text.drawWrappedText(str, [], y + text.lineh(1)*2, 1);
                        att = obj.quest.option(6).att;
                        [x, y] = text.drawWrappedText('Lottery 1: ', [], refy + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(att(1).txt{1}{1}, x, y, 1);
                        [x, y] = text.drawWrappedText('Lottery 2: ', [], y + text.lineh(1)*2, 2);
                        [~, y] = text.drawWrappedText(att(2).txt{1}{1}, x, y, 1);
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        if type == 1
                            str = 'which lottery you would prefer';
                        else
                            str = 'which lottery you would prefer to give up';
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function instoption7(obj, type)

            text = obj.text;
            height = obj.height;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 1;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                obj.pcomp(21);
                
                switch count
                    case 1
                        [~, y] = text.drawWrappedText('Ice-cream scenario', [], basey, 4);
                        if type==1
                            str = 'You go to your favorite ice-cream parlor, and have to decide between two flavors:';
                        else
                            str = 'You go to your favorite ice-cream parlor, and select two flavors:';
                        end
                        [~, refy] = text.drawWrappedText(str, [], y + text.lineh(1)*2, 1);
                        [x, y] = text.drawWrappedText('Flavor A ', [], refy + text.lineh(1)*2, 2);
                        [x, y] = text.drawWrappedText('is good. ', x, y, 1);
                        [x, y] = text.drawWrappedText('Flavor B ', x, y, 2);
                        [~, y] = text.drawWrappedText('is excellent, but is high in cholesterol.', x, y, 1);
                        if type==1
                            str = 'Which do you choose?';
                        else
                            str = 'You then realize that you can only afford one. Which do you choose to give up?';
                        end
                        [~, y] = text.drawWrappedText(str, [], y + text.lineh(1)*2, 1);
                        [~, y] = text.drawWrappedText('Press space to report', [], y + text.lineh(1)*2, 2, 'center'); 
                        if type == 1
                            str = 'which flavor you choose';
                        else
                            str = 'which flavor you choose to give up';
                        end
                        text.drawWrappedText(str, [], y + text.lineh(1), 2, 'center');                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function loadImages(obj)
            
            % Urns
            files=dir('Images/Urn*.png');
            for i=1:length(files)
                name=files(i).name;
                [img , ~, alpha] = imread(['Images/' name]); 
                img(:,:,4)=alpha;
                obj.I.urnsz(i,1)=size(img,2); %width
                obj.I.urnsz(i,2)=size(img,1); %height
                obj.I.urntxtr(i)=Screen('MakeTexture', obj.w, img);
            end
            
            % Balls
            files=dir('Images/Ball*.png');
            for i=1:length(files)
                name=files(i).name;
                [img , ~, alpha] = imread(['Images/' name]); 
                img(:,:,4)=alpha;
                obj.I.ballsz(i,1)=size(img,2); %width
                obj.I.ballsz(i,2)=size(img,1); %height
                obj.I.balltxtr(i)=Screen('MakeTexture', obj.w, img);
            end
            
            % fixation cross
            [img , ~, alpha] = imread('Images/Fix.png');
            img(:,:,4) = alpha;
            obj.I.fixsz(1)=size(img,2);
            obj.I.fixsz(2)=size(img,1);
            obj.I.fixtxtr=Screen('MakeTexture', obj.w, img);     

            % rating bar 1
            [img , ~, alpha] = imread('Images/Probability Bar.png');
            img(:,:,4) = alpha;
            obj.I.rtbrsz(1)=size(img,2);
            obj.I.rtbrsz(2)=size(img,1);
            obj.I.rtbrtxtr=Screen('MakeTexture', obj.w, img);     
            
            % rating bar 2
            [img , ~, alpha] = imread('Images/Bar2.png');
            img(:,:,4) = alpha;
            obj.I.opbrsz(1)=size(img,2);
            obj.I.opbrsz(2)=size(img,1);
            obj.I.opbrtxtr=Screen('MakeTexture', obj.w, img);     
            files=dir('Images/Knob*.png');
            for i=1:length(files)
                name=files(i).name;
                [img , ~, alpha] = imread(['Images/' name]); 
                img(:,:,4)=alpha;
                obj.I.opnbsz(i,1)=size(img,2); %width
                obj.I.opnbsz(i,2)=size(img,1); %height
                obj.I.opnbtxtr(i)=Screen('MakeTexture', obj.w, img);
            end
            
            
        end
                
        function start(obj)

            text = obj.text;
            height = obj.height;
            width = obj.width;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];
            
            %opening screen
            w = obj.I.ballsz(1,1);
            h = obj.I.ballsz(1,2);
            
            for ix=-0.1:50/width:1.2
                for iy=-0.9:50/height:1.2
                    txtr = obj.I.balltxtr(randi(5));
                    x=ix*(width-w);
                    y=iy*(height-h);
                    Screen('DrawTexture',obj.w, txtr, [], [x y x+w y+h], [],[], .2);
                end
            end
            text.drawWrappedText('Judgments and Estimations',[],[],3, 'center');
            text.drawWrappedText('Press space to start',[],round(3*height/4),1, 'center');
            Screen('Flip', obj.w);
            Utilities.waitForInput(KbName('space'), inf);
            
            count = 1;
            basey = round(height/5);
            endflag = 0;
            last = 4;
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                obj.pcomp(1);
                
                switch count
                    case 1
                        text.drawText('Welcome to the experiment and thanks for participating!', [], round(height/3));
                        text.drawText('Please read the instructions carefully', [], round(height/3)+150);
                        text.drawText('Use the right and left arrow keys to browse', [], round(height/3)+300, 2);
                        text.drawText('forward and backward through the instructions', [], round(height/3)+300+text.lineh(2), 2);
                    case 2
                        text.drawText('In this experiment, you will perform various tasks which include:', [], basey, [], 'left');
                        x = text.drawText('~ ', [], basey+80, 1, 'left');
                        text.drawText('General knowledge questions', x, basey+80, 2);
                        x = text.drawText('~ ', [], basey+80 + text.lineh(2), 1, 'left');
                        text.drawText('The Biased Coin task', x, basey+80 + text.lineh(2), 2);
                        x = text.drawText('~ ', [], basey+80 + text.lineh(2)*2, 1, 'left');
                        text.drawText('Evaluating and rating various items', x, basey+80 + text.lineh(2)*2, 2);
                        x = text.drawText('~ ', [], basey+80 + text.lineh(2)*3, 1, 'left');
                        text.drawText('Making decisions in different scenarios', x, basey+80 + text.lineh(2)*3, 2);
                        x = text.drawText('~ ', [], basey+80 + text.lineh(2)*4, 1, 'left');
                        text.drawText('The Urns task', x, basey+80 + text.lineh(2)*4, 2);
                        [x, y]= text.drawWrappedText('In addition, you will be asked to answer a ', [], basey+160 + 5*text.lineh(2)); 
                        [x, y] = text.drawWrappedText('questionnaire ', x, y, 2); 
                        text.drawWrappedText('about your tendencies and preferences', x, y); 
                    case 3
                        [~, y] = text.drawWrappedText('General Knowledge', [], basey, 4);
                        [~, y] = text.drawWrappedText('In this part of the experiment, you will be asked to estimate various quantities (for example, the height of the Eiffel tower) that you may not know precisely.', [], y + text.lineh(1)*2); 
                        [x, y] = text.drawWrappedText('First, you will be asked whether the quantity is greater or smaller than some value. Press either the ', [], y + text.lineh(1)*2); 
                        [x, y] = text.drawWrappedText('1 ', x, y, 2); 
                        [x, y] = text.drawWrappedText('(smaller) or ', x, y, 1); 
                        [x, y] = text.drawWrappedText('2 ', x, y, 2); 
                        [~, y] = text.drawWrappedText('(greater) key to indicate your answer.', x, y, 1); 
                        text.drawWrappedText('Then, you will be asked to type your best guess for the precise quantity. Please do your best even if you really don''t know the answer. Note that the precise quantity does not have be close to the value that you were asked about in the greater/smaller question.', [], y + text.lineh(1)*2);
                    case 4
                        [~, y] = text.drawWrappedText('Press space to start', [], height/2, 2, 'center'); 
                        text.drawWrappedText('the General Knowledge section', [], y + text.lineh(1), 2, 'center');
                        
                end
                %Utilities.pressSpace(w, forecol2, 1);
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);

                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
        end

        function [x y] = location(obj, loc)
            
            width = obj.width;
            height = obj.height;
            
            if ~isempty(obj.I)
                iw = obj.I.machsz(1,1) + 30;
                ih = obj.I.machsz(1,2);
            end
            
            switch(loc)
                case 'left'
                    x = round((2*width/3.0 - iw)/2);
                    y = round((height - ih)/2);
                case 'right'
                    x = round((2*width/3.0 - iw)/2.0 + width/3);
                    y = round((height - ih)/2);
                case 'center'
                    x = round((width - iw)/2);
                    y = round((height - ih)/2);
            end
        end
        
        function close(obj, number)
            Screen('CloseAll');
            PsychPortAudio('Close');
            ListenChar(0);
            ShowCursor;
            obj.eyetrack.close;
            obj.eyetrack.save(number);
        end
        
        function [final_colors, hz] = flickerfusion(obj)
            width  = obj.width;
            height = obj.height;
            text = obj.text;
            flicker_text = TextWriter;
            flicker_text.initialize(obj.w);
            refy = round(2*obj.height/5);
            y = refy;
            set = 1;
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space') KbName('a')];
            
            identity = eye(3,3);
            gray= [100 100 100];
            colors = [158,63,63;
                61,88,139;
                61,128,83;
                139,61,100;
                139,86,61;
                61,100,139;
                79,94,121;
                155, 79, 76]; %pre-defined starting 
            
            %channel we will change for each color using the arrows
            col_idx_vec = [1 3 2 1 1 3 3 2];

            final_colors = zeros(size(colors));
            hz=Screen('NominalFrameRate', obj.w);
            rect = [0,0,width, height];
            center = [rect(3)/2-200, rect(4)/2-200,rect(3)/2+200,rect(4)/2+200];
            
            
            instr_string1 = sprintf('In this task, you will adjust the colors for the rest of the experiment. You will be presented with eight colors.');
            instr_string2 = sprintf('Look at the center of the circle on the screen. If the color appears to flicker, please press the left and right arrow keys until you see no (or only slight) flickering.  Once done with a color please press the spacebar.');
            instr_string3 = sprintf('The initial colors were chosen such that they may already have little to no flickering. You can press "a" to restart the color you are on. Please tell us if you can''t seem to remove the flicker.');
            instr_string4 = sprintf('Press the spacebar to begin.');
            [x,y] = text.drawWrappedText(instr_string1,[],y + text.lineh(set)*(-2),set,'center');
            [x,y] = text.drawWrappedText(instr_string2,[],y+100,set,'center');
            [x,y] = text.drawWrappedText(instr_string3,[],y+100,set,'center');
            [x,y] = text.drawWrappedText(instr_string4,[],y+100,set,'center');
            
            Screen('Flip',obj.w);
            key = Utilities.waitForInput([KbName('space')], inf);
            WaitSecs(0.2);
            color = 1;
            while color < size(final_colors,1)+1
                color2 = colors(color,:);
                col_idx = col_idx_vec(color);

            
                tstring = sprintf('Color %d', color);
                tstring1 = 'Please press the spacebar to start.';

                text.drawWrappedText(tstring,[],refy,set,'center');
                text.drawWrappedText(tstring1,[],refy + text.lineh(set),set,'center');
                    
                Screen('Flip',obj.w);
                WaitSecs(0.2);
                
                key = Utilities.waitForInput([KbName('space')], inf);
                WaitSecs(0.3);


                
                userIsInColor = 1;
                while userIsInColor
                    Screen('FillRect', obj.w, gray);
%                     Screen('FillOval',obj.w,gray,center) ;
                    Screen('Flip',obj.w);
            

                    Screen('FillOval',obj.w,color2,center) ;
                    Screen('Flip',obj.w);
                    
                                    %check keys
                [ keyIsDown, seconds, keyCode ] = KbCheck;

                %change colors or escape based on keys
                if keyIsDown
                    if keyCode(keys(1))
                        %if not at 255 for color we interested in
                        if color2(col_idx) < 255
                           color2 = color2 + identity(col_idx, :);
                        end
                    elseif keyCode(keys(2))
                        %if not at 0 for color we interested in
                        if color2(col_idx) > 0
                            color2 = color2 - identity(col_idx, :);
                        end
                    elseif keyCode(keys(3))
                        final_colors(color,:) = color2;
                        userIsInColor = 0;
                    elseif keyCode(keys(4))
                        color2 = colors(color,:);
                    end
                end
                end
                %adjust text writer
                flicker_text = TextWriter(color2);
                flicker_text.initialize(obj.w);
                
                mid_string1 = sprintf('Can you read this text?');
                mid_string2 = sprintf('Press the right arrow to move on if so.');
                mid_string3 = sprintf('Press the left arrow if you cannot read the text above. You will have another chance to adjust the colors.');
                mid_string4 = sprintf('Remember, you can press "a" to restart when adjusting a color. If you are having problems with one color in particular, please tell the experimenter.');
                
                [x,y] = flicker_text.drawWrappedText(mid_string1,[],refy + flicker_text.lineh(set)*(-2),set+1,'center');
                [x,y] = flicker_text.drawWrappedText(mid_string2,[],y+100,set+1,'center');
                [x,y] = text.drawWrappedText(mid_string3,[],y+100,set,'center');
                [x,y] = text.drawWrappedText(mid_string4,[],y+100,set,'center');

                
                
                Screen('Flip',obj.w);
                WaitSecs(0.5);
                done = 0
                while ~done
                    [ keyIsDown, seconds, keyCode ] = KbCheck;
                    if keyIsDown
                        if keyCode(keys(1))
                            color = color + 1;
                            done=1;
                        elseif keyCode(keys(2))
                            done = 1;
                        end
                    end
                end
                
                if color == size(final_colors,1)+1
                
                    %load balls for flicker fusion check
                    files=dir('Images/Ball0*.png');
                    for i=1:length(files)
                        name=files(i).name;
                        [img , ~, alpha] = imread(['Images/' name]); 
                        img(:,:,4)=alpha;
                        obj.flickerI.ballsz(i,1)=size(img,2); %width
                        obj.flickerI.ballsz(i,2)=size(img,1); %height
                        obj.flickerI.balltxtr(i)=Screen('MakeTexture', obj.w, img);
                    end
                    
                    mid_string1 = sprintf('How many colors do you see below?');
                    mid_string2 = sprintf('Press the right arrow if you can see five colors.');
                    mid_string3 = sprintf('Press the left arrow if you see less than five colors. You will adjust all of the colors again. If you have already readjusted the colors please tell the experimenter.');

                    [x,y] = flicker_text.drawWrappedText(mid_string1,[],refy + flicker_text.lineh(set)*(-4),set+1,'center');
                    [x,y] = flicker_text.drawWrappedText(mid_string2,[],y+100,set+1,'center');
                    [x,y] = flicker_text.drawWrappedText(mid_string3,[],y+100,set,'center');
                    
                    y=y+100; 
                    for i=1:length(files)
                        x = round(obj.width/2)+(i-3)*(obj.flickerI.ballsz(1,1)+50);
                        Screen('DrawTexture', obj.w, obj.flickerI.balltxtr(i), [], [x y x+obj.flickerI.ballsz(i,1) y+obj.flickerI.ballsz(i,2)]);
                    end
                    Screen('Flip',obj.w);
                    WaitSecs(0.5);
                    done = 0
                    while ~done
                        [ keyIsDown, seconds, keyCode ] = KbCheck;
                        if keyIsDown
                            if keyCode(keys(1))
                                done=1;
                            elseif keyCode(keys(2))
                                color = 1;
                                done = 1;
                            end
                        end
                    end

                end
                
            end
        end
        
        function [Ans, Tm] = runauditoryoddball(obj, num_oddball, standalone)
            %num_oddball is number of trial starting at 1: 1, 2, 3... etc.
            
            %send messages to eyetracker
            obj.eyetrack.inc(18+num_oddball); 
            obj.eyetrack.msg(['Auditory Oddball ', num2str(num_oddball)]);
            
            %get game info
            stim_type_list = obj.quest.auditoryoddball(num_oddball).randomized_list; 
            stim_timing_list = obj.quest.auditoryoddball(num_oddball).spacing; 
            stim_timing_list = [stim_timing_list ; 4.0];
            
            %get object properties we need
            w = obj.w; %window
            width = obj.width;
            I = obj.I; %images (for fixation)
            height = obj.height;
            
            %get number of choices for initialization
            T = size(stim_type_list,1);
            
            %initialize timing variables
            Tm.actualStartTime= zeros(T,1);
            Tm.estStopTime= zeros(T,1);
  
            %initialize response variables
            Ans.name = ['Auditory Oddball ', num2str(num_oddball)];            
            Ans.resp= zeros(T,1);
            Ans.rxn = zeros(T,1);
            
            %run instructions
            obj.instauditoryoddball(num_oddball, standalone);
            
            %fixation
            Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
            Screen('Flip', obj.w);
            
            obj.eyetrack.msg('start_trials');
            WaitSecs(stim_timing_list(1));
            for t = 1:T
                [Ans.resp(t), Ans.rxn(t), Tm.actualStartTime(t), Tm.estStopTime(t)] = obj.auditoryoddball(stim_type_list(t), stim_timing_list(t+1)) ; 
            end
            obj.eyetrack.msg('end_trials');
            %end mesage
            obj.text.drawWrappedText('Good job!',[],[],4,'center');
            Screen(w,'Flip');
            obj.eyetrack.msg('end');
            
            WaitSecs(2);
        end
        
        function [key, end_time, actualStartTime, estStopTime] = auditoryoddball(obj, stim_type, stim_time)         
            %play sound at time
            PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{3+stim_type})');
            obj.eyetrack.msg(['audio_', num2str(stim_type)]);
            PsychPortAudio('Start',obj.snd.pahandle,1,[],0);  
           
            %timing
            [actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', obj.snd.pahandle, 1, 1);
            
            %wait for response in allotted spacing
            keys = [KbName('Space')];
            
            start_time = GetSecs;
            [key, when] = Utilities.waitForInput(keys, start_time + stim_time);
            end_time = when - start_time;
            
            if when == -1
                WaitSecs(stim_time);
            else
                WaitSecs(stim_time-end_time);
            end          
        end
        
        function instauditoryoddball(obj, num_oddball, standalone)
            
            %get object properties
            w = obj.w; %window
            width = obj.width;
            text = obj.text;
            height = obj.height;
            I = obj.I; %images (for fixation)
            
            %set keys
            keys = [KbName('RightArrow') KbName('LeftArrow') KbName('space')];

            count = 1;
            basey = round(height/5);
            endflag = 0;
            
            %strings for instructions
            if num_oddball == 1
                %practice game instructions
                s1='In this game, two different tones will be played many times. One tone is high pitched, the other is low pitched.';
                s2='Your job is to press the space bar whenever the high pitched tone is played. Do not press any buttons when the low pitched tone is played.';
                s3 = 'In the next three pages, you will see examples of tones: two low tones followed by a high tone.'
                last = 5;
            else
                if standalone == 1
                    %take a break, reminder of how to play
                     s1='Take a break! When you are ready you will play another round of the sound game.';
                     s2='As a reminder, try to press the space bar whenever the high pitched tone is played. Do not press any buttons when the low pitched tone is played.';
                     s3 = '';
                     last = 1;
                else 
                    %more info on how to play since they've been doing
                    %other games in the interim
                    s1='Time for another round of the sound game!';
                    s2='As a reminder, your job is to press the space bar whenever the high pitched tone is played. Do not press any buttons when the low pitched tone is played.';
                    s3 = 'In the next three pages, you will see examples of trials: two low tones followed by a high tone.'
                    last = 5;
                end
            end
            
            s4 = 'As a reminder, please look at the cross in the middle of the screen and press the space bar as quickly as you can. You can go back to review the tones now if needed.';
            
            while ~endflag

                text.drawText(['Page ' num2str(count) ' of ' num2str(last)], [], 100, 2, 'right', 50);
                text.drawWrappedText('press left/right arrows to browse', [], round(height-text.lineh(1)),2,'center' ); 
                
                %pages of instructions
                switch count
                    case 1
                        %instructions
                        [~, y] = text.drawWrappedText('Sound Game', [], basey, 4);
                        [~, y] = text.drawWrappedText(s1, [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        [~, y] = text.drawWrappedText(s2, [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        
                        if length(s3) == 0
                            [~, y] = text.drawWrappedText('Press space to start!', [], round(y + text.lineh(1)*2), 2, 'center'); 
                        else
                            [~, y] = text.drawWrappedText(s3, [], round(y + text.lineh(1)*2),[],[],[],[],150); 
                        end
                

                    case 2
                        %standard example
                        Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                        
                        %play sound
                        PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{3})');
                        PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            
                    case 3
                        %standard example
                        Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                        
                        %play sound
                        PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{3})');
                        PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
            
                    case 4
                        %target example
                        Screen('DrawTexture',w, I.fixtxtr, [], [(width-I.fixsz(1))/2 (height-I.fixsz(2))/2 (width+I.fixsz(1))/2 (height+I.fixsz(2))/2]);
                        
                        %play sound
                        PsychPortAudio('FillBuffer',obj.snd.pahandle,double(obj.snd.sound{4})');
                        PsychPortAudio('Start',obj.snd.pahandle,1,[],0);
   
                    case 5
                        %last chance before they start the game to go back
                        [~, y] = text.drawWrappedText(s4, [], basey,[],[],[],[],150); 
                        [~, y] = text.drawWrappedText('Press space to start!', [], round(y + text.lineh(1)*2), 2, 'center'); 
                end
                
                %page switching
                Screen('Flip', obj.w);
                WaitSecs(0.2);
                key = Utilities.waitForInput(keys, inf);
                
                
                switch key(1)
                    case keys(1)
                        count = count + 1;
                        count = min(count, last);
                    case keys(2)
                        count = count - 1;
                        if count < 1
                            count = 1;
                        end
                    case keys(3)
                        if count==last
                            endflag=1;
                        end
                end
            end
            
            
        end
    end
    
end

                    
                
            
            