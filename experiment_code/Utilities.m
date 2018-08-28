classdef Utilities < handle
    
    properties
        
    end
    
    methods(Static)

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
                Utilities.ciplot(sigi-semi, sigi+semi,x,Utilities.hsv2rgb([col, .5 .9]));
            end            
            for i = 1:N
                sigi = nanmean(sig(i,:,:),3);
                n = (length(sigi)-1)/2;
                if nargin<2 || isempty(cols); col = (i-0.9)/N; else col = cols(i); end
                h(i) = plot(x, sigi, 'Color', Utilities.hsv2rgb([col, 0.9 1]), 'LineWidth', 2);
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
        
        
        
        function pressSpace(w, col, goback)
            
            txtsz=Screen('TextSize',w);
            [~, height]=Screen('WindowSize',w);
            y=height-txtsz*3.5;
            
            Screen('TextSize', w ,round(txtsz/5*4));

            if ~exist('col','var')
                col=[];
            end
            if ~exist('goback','var')
                goback=0;
            end
            
            if goback 
                DrawFormattedText(w, '(Use index finger to continue or middle finger to go back)', 'center' , y, col);
            else
                DrawFormattedText(w, '(Use index finger to continue)', 'center' , y, col);
            end
            
            Screen('TextSize', w ,txtsz );
            
            Screen('Flip', w);
            WaitSecs(0.3);
            
        end
        
        function [key, when] = waitForInput(keys, timeout)
            
            % wait for a keypress of type keys until timeout
            
            pressed = 0;
            when=-1;
            
            if ~exist('timeout','var')
                timeout=inf;
            end
            
            while ~pressed && (GetSecs < timeout)
                [pressed, when, keycode] = KbCheck(-1);
                if (pressed)
                    key = find(keycode);
                    if isempty(intersect(key, keys))
                        pressed = 0;
                    end
                end
            end
            
            if pressed == 0
                key = nan;
            end
            
        end
        
        function res=randprop(x)
        % returns i with probability proportional to x(i)
            nx=x./sum(x);
            cx=cumsum(nx);
            draw=rand;
            i=1;
            while draw>cx(i)
                i=i+1;
            end
            res=i;
        end
        
        function message(w, str)
            txtsz=Screen('TextSize',w);
            Screen('TextSize',w,round(txtsz*1.5));
            DrawFormattedText(w, str,'center','center');
            Screen('TextSize',w,txtsz);
            Screen('Flip',w);
            WaitSecs(2);
        end

        function WaitForTrigger(window)
        % waits for the experimenter to press 'g' for GO and then waits for the scanner trigger to make sure the MRI has
        % started and everything is fine...

            % Wait for experimenter button press, ignore scanner trigger if present
            Utilities.WaitForExperimenter(window)

            % Wait for Scanner
            Screen('Flip',window);
            str = 'Waiting for scanner...';
            DrawFormattedText(window,str,'center','center',[],50);
            Screen('Flip',window);
            
            if ispc
                trigger='Shift';
            else
                trigger='LeftShift';
            end
            pressed = 0;
            while ~pressed
                WaitSecs(0.001);
            OSX = IsOSX; % to save time we ask this only once
                
                if OSX
                    [pressed, secs, keyCode] = KbCheck(-1); % Mac; on old versions of PTB should be KbCheckMulti
                else
                    [pressed, secs, keyCode] = KbCheck; % Windows
                end
                if (pressed)
                    key_name = KbName(keyCode);
                    key_size = length(key_name);
                    if (iscell(key_name)||(key_size==length(trigger) && all(key_name==trigger))) % this was the scanner trigger
                        pressed = 1;
                    else
                        pressed = 0;
                    end
                end
            end
            fprintf('got trigger!')
            return   
        end
        
        function keyCode = WaitForSubject
            % Wait for subject to press any valid button/key, ignore scanner trigger
            if ispc
                trigger=KbName('Shift');
            else
                trigger=KbName('LeftShift');
            end
            pressed = 0;
            OSX = IsOSX; % to save time we ask this only once
            while ~pressed
                if OSX
                    [pressed, secs, keyCode] = KbCheck(-1); % Mac; on old versions of PTB should be KbCheckMulti
                else
                    [pressed, secs, keyCode] = KbCheck; % Windows
                end
                if (pressed)
                    keyCode(trigger) = 0;
                    if ~sum(keyCode)  % nothing other than the trigger was pressed
                        pressed = 0;
                        WaitSecs(0.005); % RTs based on this function will only be this accurate anyway, due to properties of KbCheck
                    end
                end
            end
            return      
        end

        function WaitForExperimenter(window)
        % waits for the experimenter to press 'g' for GO and then waits for the scanner trigger to make sure the MRI has
        % started and everything is fine...

            % Wait for experimenter button press, ignore scanner trigger if present
            Screen('Flip',window);
            str = 'Waiting for experimenter to press ''g''...';
            DrawFormattedText(window,str,'center','center',[],50);
            Screen('Flip',window);
            OSX=IsOSX;
            pressed = 0;
            while ~pressed
                WaitSecs(0.001);
                if OSX
                    [pressed, secs, keyCode] = KbCheck(-1); % Mac; on old versions of PTB should be KbCheckMulti
                else
                    [pressed, secs, keyCode] = KbCheck; % Windows
                end
                if(pressed)
                    if ~(keyCode(KbName('g')))  % 'g' was not pressed
                        pressed = 0;
                    end
                end
            end

            return   
        end
        
        function strs = splitStr(str, chr)
            if nargin<2 || isempty(chr)
                chr = ' ';
            end
            inds = find(str==chr);
            strs = cell(length(inds)+1,1);
            for i = 1:length(inds)+1
                if i==1; ind1 = 1; else ind1 = inds(i-1)+1; end
                if i>length(inds); ind2 = length(str); else ind2 = inds(i)-1;end
                strs{i} = str(ind1:ind2);
            end
        end
                    
                    
        
    end
end
