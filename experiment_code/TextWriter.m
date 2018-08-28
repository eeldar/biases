classdef TextWriter < handle
    
    properties
        I; %images
        w; %screen
        width; %screen width
        height; %screen height
        refh; %height in piexls of 'a'
        kern; %kerning table
        space = 3; %spacing between letters
        lineh; %line height
        defmarg = 100; %default margin
        col = [100 100 100]; %default backlground color
        pink = 0;
    end
    
    methods
        
        function obj = TextWriter(pink)
            if nargin < 1
                pink = 0;
            end
            obj.pink = pink;
        end
        
        function [str x2]= input(obj, x, y, lim, txt, txtflag)
            
            if nargin<6 || isempty(txtflag)
                txtflag = 0;
            end
            if nargin<2 || isempty(x)
                x = obj.defmarg;
            end
            if nargin<4 || isempty(lim)
                lim=10;
            end
            if nargin<5 || isempty(txt)
                txt = '';
            end
            set = 1;
            
            str = '';
            key = 0;
            x2 = x;
            y2 = y;
            wait = 0;
            keys = [KbName('delete') KbName('return') KbName('1'):KbName('0') KbName('1!'):KbName('0)') KbName('.') KbName('.>')];
            if ismac 
                keys = [keys KbName('ENTER')]; 
            else
                keys = [keys KbName('0'):KbName('9') KbName('0)'):KbName('9(')];
            end
            if txtflag
                keys = [keys KbName('a'):KbName('z') KbName('A'):KbName('Z') KbName('space')];
            end
            
            while ~any([key==KbName('return') (ismac && key==KbName('ENTER'))]) || isempty(str)
                if y==y2
                    Screen('FillRect', obj.w, obj.col, [x y2-obj.lineh(set) x2 y2+obj.lineh(set)/2]);
                else
                    Screen('FillRect', obj.w, obj.col, [x y-obj.lineh(set) obj.width y+obj.lineh(set)/2]);
                    Screen('FillRect', obj.w, obj.col, [0 y obj.width y2+obj.lineh(set)/2]);
                end
                    
                [x2 y2] = obj.drawWrappedText(str, x, y);
                if mod(GetSecs, 2)>1
                    [x2 y2] = obj.drawWrappedText('|', x2, y2,2);
                    [x2 y2] = obj.drawWrappedText([' ' txt], x2, y2);
                else
                    [x2 y2] = obj.drawWrappedText([' ' txt], x2+obj.textWidth('|',set)+obj.space, y2);
                end
                Screen('Flip',obj.w,[],1);
                if wait
                    wait = 0;
                end
                key = Utilities.waitForInput(keys, GetSecs+.2);
                [~, ~, key2] = KbCheck(-1);
                key2 = find(key2);
                if ~isempty(key2); key2=key2(1); end
                while key2==key(1)
                    [~, ~, key2] = KbCheck(-1);
                    key2 = find(key2);
                    if ~isempty(key2); key2=key2(1); end
                end                       
                key = key(1);
                if key == KbName('delete')
                    str = str(1:end-1);
                    wait = 1;
                elseif key==KbName('space') && length(str)<lim
                    str = [str ' '];
                    wait = 1;
                elseif key>0 && ~any([key==KbName('return') (ismac && key==KbName('ENTER'))]) && length(str)<lim
                    let = KbName(key);
                    str = [str let(1)];
                    wait = 1;
                end
            end
            
            
            
        end
                    
        function [x y shift] = drawWrappedText(obj, str, x, y, set, where, leftmarg, shift, rightmarg)
            
            if nargin<5 || isempty(set)
                set = 1;
            end
            if nargin<4 || isempty(y)
                y = round((obj.height-obj.I.letsz(1,1,set))/2);
            end
            if nargin<6 || isempty(where)
                where = 'left';
            end
            if nargin<7 || isempty(leftmarg)
                leftmarg = obj.defmarg;
            end
            if nargin<9 || isempty(rightmarg)
                rightmarg = obj.defmarg;
            end
            if nargin<3 || isempty(x)
                if strcmp(where,'center')
                    x = round(obj.width/2);
                else
                    x = leftmarg;
                end
            end
            startx = x;
            
            if nargin <8 || isempty(shift)
                if length(str)>=2 && strcmp(str(1:2),'~ ')
                    shift = obj.I.letsz(66,1,set)+obj.I.letsz(1,1,set);
                elseif length(str)>=3 && (str(1)>0 && str(1)<='9' && strcmp(str(2:3),'. '))
                    shift = obj.textWidth(str(1:3), set);
                else
                    shift = 0;
                end
            end
            applyshift = 0;
            
            ws = 1;
            nwe = 1;
            while ws<=length(str)
                if strcmp(where,'center')
                    netwidth = obj.width - leftmarg - rightmarg;
                    width = netwidth - abs(netwidth/2-x+leftmarg)*2;
                else
                    width = obj.width - rightmarg - x;
                end
                while nwe<=length(str) && obj.textWidth(str(ws:nwe-1),set)+applyshift*shift<width
                    we = nwe - 1;
                    nwe = nwe + 1;
                    while nwe<=length(str) && str(nwe)~=' '; nwe = nwe + 1; end
                end
                if obj.textWidth(str(ws:nwe-1),set)+applyshift*shift<width; we = nwe-1; end  %#ok<*PROP>
                switch where
                    case 'center'
                        x = x + round( - obj.textWidth(str(ws:we), set)/2);
                    case 'right'
                        x = x + (width - obj.textWidth(str(ws:we), set));
                end
                x = obj.drawText(str(ws:we), x + applyshift*shift, y, set);
                applyshift = 1;
                if we>=ws; ws = we + 2; end
                nwe = ws + 1;
                if ws<=length(str)
                    y = y + obj.lineh(set);
                    if strcmp(where,'center')
                        x = startx;
                    else
                        x = leftmarg;
                    end
                end
            end
        end
            
        function x = drawText(obj, str ,x , y, set, where, wheremarg)
            
            if nargin<5 || isempty(set)
                set = 1;
            end
            
            if nargin<6 || isempty(where)
                where = 'center';
            end
                        
            if nargin<7 || isempty(wheremarg)
                wheremarg = obj.defmarg;
            end
                        
            if nargin<4 || isempty(x)
                if nargin<4
                    y = x;
                end
                switch where
                    case 'center'
                        x = round((obj.width - obj.textWidth(str, set))/2);
                    case 'right'
                        x = round(obj.width - obj.textWidth(str, set)-wheremarg);
                    case 'left'
                        x = wheremarg;
                end
            end

            for l = 1:length(str)
                if l<length(str)
                    next = str(l+1);
                else
                    next = [];
                end
                x = obj.drawLetter(str(l), x, y, next, set) + obj.space;
            end
            
        end
        
        function w = textWidth(obj, str, set)
            w=0;
            for l=1:length(str)
                if str(l)==' '
                    w = w + obj.I.letsz(9,1,set) + obj.space;
                else
                    ind = obj.char2ind(str(l));
                    w = w + obj.I.letsz(ind,1,set) + obj.space;
                    if l<length(str)
                        next = str(l+1);
                    else
                        next = [];
                    end
                    if ~isempty(next)
                        next = obj.char2ind(next);
                        if all([ind next]<53)
                            w = w - obj.kern(ind,next,set);
                        end
                    end
                    
                end
            end
            w = w - obj.space;
        end
        
        function x2 = drawLetter(obj, l, x, y, next, set)
            
            if nargin<6 || isempty(set)
                set = 1;
            end
            
            if l==' '
                x2 = x + obj.I.letsz(9,1,set);
            else
                l = obj.char2ind(l);
                x1 = x;
                x2 = x + obj.I.letsz(l,1,set);
                y2 = y;
                switch l
                    case {7, 16, 17, 25}
                        y2 = y2 + obj.I.letsz(l,2,set) - obj.refh(set);
                    case 43
                        y2 = y2 + obj.I.letsz(l,2,set) - obj.I.letsz(27,2,set);
                    case 10
                        y2 = y2 + obj.I.letsz(l,2,set) - obj.I.letsz(9,2,set);
                    case 54
                        y2 = y - obj.I.letsz(53,2,set) + obj.I.letsz(l,2,set);
                    case 68
                        y2 = y2 + round(obj.I.letsz(1,2,set)/5);
                    case {72, 76}
                        y2 = y2 + obj.I.letsz(l,2,set) - obj.I.letsz(27,2,set);
                    case {73, 74}
                        y2 = y2 + obj.I.letsz(l,2,set) - obj.I.letsz(27,2,set)- round(1*obj.I.letsz(1,2,set)/20);
                    case 77
                        y2 = y2 + round(obj.I.letsz(1,2,set)/2);
                end
                y1 = y2 - obj.I.letsz(l,2,set);
                Screen('DrawTexture', obj.w, obj.I.lettxtr(l,set), [] , [x1 y1 x2 y2]);

                if nargin>=5 && ~isempty(next)
                    next = obj.char2ind(next);
                    if all([l next]<53)
                        x2 = x2 - obj.kern(l,next,set);
                    end
                end
            end
        end
                           
        function initialize(obj, w)
            obj.w = w;
            [obj.width obj.height] = Screen('WindowSize', w);
            obj.loadImages;
            for set = 1:size(obj.I.letsz,3)
                obj.refh(set) = obj.I.letsz(1,2,set);
            end
            files = dir('Text/kern*');
            obj.kern = zeros(52,52,length(files));
            for f=1:length(files)
                table = load(['Text/' files(f).name]);
                obj.kern(:,:,f) = cast(table.kern(1:52,1:52),'double'); 
                obj.kern(:,:,f) = min(obj.kern(:,:,f), 6);
            end
            for set = 1:size(obj.I.letsz,3)
                obj.lineh(set) = round(obj.I.letsz(1,2,set)*(2+1/3));
            end
        end
        
        function loadImages(obj)
            
            for set = 1:2:3
            
                files = dir('Text/Letter*.png');
                if set==1
                    files = files(cellfun(@(x) x(7),{files(:).name})>'9');
                else
                    files = files(cellfun(@(x) x(7),{files(:).name})<='9');
                end
                for i=1:length(files)

                    name=files(i).name;
                    [img , ~, alpha] = imread(['Text/' name]); 
                    img(:,:,4)=alpha;
                    obj.I.letsz(i,1, set)=size(img,2); %width
                    obj.I.letsz(i,2, set)=size(img,1); %height
                    obj.I.lettxtr(i, set)=Screen('MakeTexture', obj.w, img);

                    if length(obj.pink) == 1
                        img(:,:,1) = round(img(:,:,1)+(109-15));
                        img(:,:,2) = round(img(:,:,2)+(87-102));
                        img(:,:,3) = round(img(:,:,3)+(165-182));
                    else
                        img(:,:,1) = (img(:,:,1)>0) * obj.pink(1);
                        img(:,:,2) = (img(:,:,1)>0) * obj.pink(2);
                        img(:,:,3) = (img(:,:,1)>0) * obj.pink(3);
                    end
                    
                    obj.I.letsz(i,1, set+1)=size(img,2); %width
                    obj.I.letsz(i,2, set+1)=size(img,1); %height
                    obj.I.lettxtr(i, set+1)=Screen('MakeTexture', obj.w, img);
                end
                
            end    
                
        end
        
    end
    
    methods(Static)
        
        function ch = char2ind(ch)
            if ch>='a' && ch<='z'
                ch = ch - 'a' + 1;
            elseif ch>='A' && ch<='Z'
                ch = 27 + ch - 'A';
            elseif ch=='.'
                ch = 53;
            elseif ch==','
                ch = 54;
            elseif ch=='!'
                ch = 55;
            elseif ch>='0' && ch <='9'
                ch = 56 + ch - '0';
            elseif ch==':'
                ch = 66;
            elseif ch=='~'
                ch = 67;
            elseif ch=='$'
                ch = 68;
            elseif ch=='-'
                ch = 69;
            elseif ch=='?'
                ch = 70;
            elseif ch=='%'
                ch = 71;
            elseif ch==''''
                ch = 72;
            elseif ch=='('
                ch = 73;
            elseif ch==')'
                ch = 74;
            elseif ch=='"'
                ch = 75;
            elseif ch=='/'
                ch = 76;
            elseif ch=='|'
                ch = 77;
            end
        end

    end
    
end
        