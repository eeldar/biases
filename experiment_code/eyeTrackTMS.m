classdef eyeTrackTMS < handle
        
    properties
        w;
        text;
        net;
        width;
        height;
        fixtxtr;
        fixsz;
        
    end
    
    methods


        function obj = eyeTrackTMS(w, text, I, eyetracking)

            obj.w = w;
            obj.text = text;
            [obj.width obj.height] = Screen('WindowSize', w);
            obj.fixtxtr = I.fixtxtr;
            obj.fixsz = I.fixsz;

            % 1) Establish a connection with the eye tracker
            % 2) Present the calibration image (and then by hand, do a calibration on the eye tracker
            % 3) Send a message to the eye tracker at the start and end of the run,
            %    so that the eye tracker can markup the data file.

            % Open connection to eye tracker
            if eyetracking
                pnet('closeall'); % Force all current pnet connections/sockets (in the present matlab session) to close
                ivx = iViewXInitDefaults; % creates the necessary ivx data structure
                ivx.host = '169.254.191.78'; % eye tracker IP
                ivx.port = 4444; % eye tracker port
                ivx.localport = 5555; % port on stim PC
                [result, ivx]=iViewX('openconnection', ivx);
                if result < 0
                    error('Could not establish connection to eye tracker');
                end
                'good'
            else
                ivx = [];
            end

            % set the expected calibration points on the eyetracker (i.e., based on
            % the calibration image presented next
            % [result ivx] = iViewX('setpoint', ivx, [1 640 360]);
            % [result ivx] = iViewX('setpoint', ivx, [2 370 215]);
            % [result ivx] = iViewX('setpoint', ivx, [3 910 215]);
            % [result ivx] = iViewX('setpoint', ivx, [4 370 495]);
            % [result ivx] = iViewX('setpoint', ivx, [5 910 495]);
            
            obj.net = ivx;
            
        end
            
        function calibraterecord(obj)

            w = obj.w;
            height = obj.height;
            text = obj.text;
            width = obj.width;
            
            % Present the calibration image
            FlushEvents('keyDown');
            calibration_image = imread(['images/5cal-10left-5up_1600x1200_black.bmp']);
            calibration_texture = Screen('MakeTexture', w, calibration_image);
            Screen('DrawTexture',w,calibration_texture,[],[0 0 width height],[]);
            DrawFormattedText(w,'Press space to continue','center',10);
            Screen('Flip', w);

            % wait for keypress from experimenter: q
            Utilities.waitForInput(KbName('space'), inf);

            
            Utilities.waitForInput(KbName('space'), inf);
           
            [~, y] = text.drawWrappedText('We will now record your baseline pupil diamter:',[], round(height/3));
            [~, y] = text.drawWrappedText('~ All you need to do is to keep your eyes on the cross',[], y + text.lineh(1)+ 30);
            [~, y] = text.drawWrappedText('~ The recording will stop automatically after 45 seconds',[], y + text.lineh(1)+ 30);
            text.drawWrappedText('Press space to begin the recording',[], y + text.lineh(1)+ 60, 2, 'center');
            Screen('Flip',w);
            
            WaitSecs(0.3);
            Utilities.waitForInput(KbName('space'), inf);
            
            WaitSecs(0.3);

            Screen('DrawTexture',w, obj.fixtxtr, [], [(width-obj.fixsz(1))/2 (height-obj.fixsz(2))/2 (width+obj.fixsz(1))/2 (height+obj.fixsz(2))/2]);
            Screen('Flip',w);
            
            [result obj.net] = iViewX('startrecording', obj.net);
            if result < 0
                error('Could not start eyetracker recording');
            end
            [result obj.net] = iViewX('message', obj.net, 'pre-experiment baseline');
            WaitSecs(1.5 + (~isempty(obj.net))*43.5); 
            [result obj.net] = iViewX('message', obj.net, 'end');
            
            %% Begin Experiment=

            FlushEvents('keyDown');

            fprintf('The experiment will start now.\n');
            
        end

        function msg(obj, str)
            if ~isempty(obj.net)
                [~ , obj.net] = iViewX('message', obj.net, str);
            end
        end
        
        function start(obj)
            if ~isempty(obj.net)
                [~ , obj.net] = iViewX('startrecording', obj.net);
            end
        end
        
        function inc(obj, num)
            if ~isempty(obj.net)
                [~ , obj.net] = iViewX('incrementsetnumber', obj.net, num);
            end
        end
        
        function stop(obj)
            if ~isempty(obj.net)
                [~, obj.net] = iViewX('stoprecording', obj.net);
            end
        end
        
        function close(obj)
            if ~isempty(obj.net)
                [~ , obj.net] = iViewX('stoprecording', obj.net);
                
            end
        end
        
        function save(obj, number)
            if ~isempty(obj.net)
                [~ , obj.net] = iViewX('datafile', obj.net, ['"C:\Users\iView X\Documents\Eran\CognitiveBiases\' sprintf('S%02d_%d%02d%02d_%d%d%d.idf',number,fix(clock)) '"']);
            end
        end
        
        
    end

    methods(Static)
        
        function eye=parseTS(filename) %returns all segments
            fid=fopen(filename);
            line = fgets(fid);
            while length(line)>1 && strcmp(line(1:2),'##')
                line = fgets(fid);
            end
            line = Utilities.splitStr(line,sprintf('\t'));
            idm = find(cellfun(@(IDX) ~isempty(IDX), strfind(line, 'Diameter')));
            itr = find(cellfun(@(IDX) ~isempty(IDX), strfind(line, 'Trial')));

            oldseg=0;
            i=0;
            while (~feof(fid))
                line = fgets(fid);
                line = Utilities.splitStr(line,sprintf('\t'));
                
                if length(line)>=itr
                    seg=str2double(line{itr});
                    if seg~=oldseg
                        if oldseg>0
                            i
                            eye(oldseg).msg(i+1:end)=[];
                            eye(oldseg).DMl(i+1:end)=[];
                            eye(oldseg).DMr(i+1:end)=[];
                            eye(oldseg).DMlx(i+1:end)=[];
                            eye(oldseg).DMly(i+1:end)=[];
                            eye(oldseg).DMrx(i+1:end)=[];
                            eye(oldseg).DMry(i+1:end)=[];
                            eye(oldseg).T(i+1:end)=[];            
                        end
                        i=1;
                        oldseg=seg
                        eye(seg).msg=cell(1,1000000);
                        eye(seg).DMl=zeros(1,1000000);
                        eye(seg).DMlx=zeros(1,1000000);
                        eye(seg).DMly=zeros(1,1000000);
                        eye(seg).DMr=zeros(1,1000000);
                        eye(seg).T=zeros(1,1000000);
                    else
                        i=i+1;
                    end
                    
                    if strcmp(line(2),'SMP')
                        eye(seg).T(i)=str2num(cell2mat(line(1)));
                        eye(seg).DMl(i)=str2num(cell2mat(line(idm(1))));
                        eye(seg).DMlx(i)=str2num(cell2mat(line(idm(1)-2)));
                        eye(seg).DMly(i)=str2num(cell2mat(line(idm(1)-1)));
                        eye(seg).DMr(i)=str2num(cell2mat(line(idm(2))));
                        eye(seg).DMrx(i)=str2num(cell2mat(line(idm(2)-2)));
                        eye(seg).DMry(i)=str2num(cell2mat(line(idm(2)-1)));
                        if ~isstr(eye(seg).msg{i})
                            eye(seg).msg{i}='';
                        end
                    elseif strcmp(line(2),'MSG')
                        eye(seg).msg(i)=cellstr(line{4}(12:end));
                        i=i-1;
                    end
                end
            end
            eye(oldseg).msg(i+1:end)=[];
            eye(oldseg).DMl(i+1:end)=[];
            eye(oldseg).DMlx(i+1:end)=[];
            eye(oldseg).DMly(i+1:end)=[];
            eye(oldseg).DMrx(i+1:end)=[];
            eye(oldseg).DMry(i+1:end)=[];
            eye(oldseg).DMr(i+1:end)=[];
            eye(oldseg).T(i+1:end)=[];            
            
        end
        
        function [newdiam, blink]=clearBlinks(diam, rawx, rawy)
            
            % blink detection
            blinkx=false(size(diam));
            blinky=false(size(diam));
            baselinex=median(rawx(rawx>0));
            baseliney=median(rawy(rawy>0));
            ratio = median(diam(rawx>0 & rawy>0))/mean([baselinex baseliney]);
            
            for i=1:size(diam,2)
                % change thresholds
                if i>1
                    threshold1x=(rawx(i)+rawx(i-1))/2*0.1;
                    threshold1y=(rawy(i)+rawy(i-1))/2*0.1;
                end
                if i<size(diam,2)
                    threshold2x=(rawx(i)+rawx(i+1))/2*0.1;
                    threshold2y=(rawy(i)+rawy(i+1))/2*0.1;
                end
                
                if rawx(i)==0 || rawx(i)<baselinex*0.66 || rawx(i)>baselinex*1.5 || (i>1 && ((abs(rawx(i)-rawx(i-1))>threshold1x) )) || (i<size(diam,2) && ((abs(rawx(i)-rawx(i+1))>threshold2x)))
                    blinkx(i)=true;
                else
                    blinkx(i)=false;
                end
                if rawy(i)==0 || rawy(i)<baseliney*0.66 || rawy(i)>baseliney*1.5 || (i>1 && ((abs(rawy(i)-rawy(i-1))>threshold1y))) || (i<size(diam,2) && ((abs(rawy(i)-rawy(i+1))>threshold2y)))
                    blinky(i)=true;
                else
                    blinky(i)=false;
                end
            end
            
            newblinkx=blinkx;
            for i=1:size(diam,2)
                if sum(blinkx(max(i-4,1):min(i+12,end)))>0 
                    newblinkx(i)=1;
                end
            end
            blinkx=newblinkx;

            newblinky=blinky;
            for i=1:size(diam,2)
                if sum(blinky(max(i-4,1):min(i+12,end)))>0 
                    newblinky(i)=1;
                end
            end
            blinky=newblinky;
                    
            newrawx = rawx;
            newrawy = rawy;
            
            %linear interpolation
            for i=1:size(diam,2)
                if blinkx(i)
                    st=i-find(~blinkx(i-1:-1:1),1);
                    en=i+find(~blinkx(i+1:end),1);
                    if isempty(st) && isempty(en)
                        newrawx(i)=nan;
                    elseif isempty(st)
                        newrawx(i)=rawx(en);
                    elseif isempty(en)
                        newrawx(i)=rawx(st);
                    else
                        newrawx(i)=rawx(st)+(rawx(en)-rawx(st))*(i-st)/(en-st);
                    end
                else
                    newrawx(i)=rawx(i);
                end
            end
            
            for i=1:size(diam,2)
                if blinky(i)
                    st=i-find(~blinky(i-1:-1:1),1);
                    en=i+find(~blinky(i+1:end),1);
                    if isempty(st) && isempty(en)
                        newrawy(i)=nan;
                    elseif isempty(st)
                        newrawy(i)=rawy(en);
                    elseif isempty(en)
                        newrawy(i)=rawy(st);
                    else
                        newrawy(i)=rawy(st)+(rawy(en)-rawy(st))*(i-st)/(en-st);
                    end
                else
                    newrawy(i)=rawy(i);
                end
            end

            newdiam = zeros(size ( diam ) ) ;
            % moving average
            for i=1:size(newdiam,2)
                if blinkx(i) && ~blinky(i)
                    newdiam(i) = newrawy(i);
                elseif ~blinkx(i) && blinky(i)
                    newdiam(i) = newrawx(i);
                else
                    newdiam(i) = nanmean([newrawx(i) newrawy(i)]);
                end
            end
            
            for i=1:size(newdiam,2)
                newdiam(i)=nanmean(newdiam(max(1,i-5):min(end,i+5)));
            end
            newdiam = newdiam.*ratio;
            
            blink = blinkx & blinky;
        end
                    

      
        
    end

end