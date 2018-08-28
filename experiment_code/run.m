function run()
    %% Flags
    short=0;
    eyetrack=0;
    color_convert = 1;
    
    %% Initialize
    number=input('Subjects number? ');
    if isempty(number)
        number = 0;
    end

    EXPT = Biases(short, eyetrack, mod(number,2)+1,color_convert);
    
    try
        %Anchoring task
        [Ans{11} Tm{11}] = EXPT.runauditoryoddball(1,0);
        EXPT.start;
        [Ans{1} Tm{1} Type{1}] = EXPT.runanchor;
        saveTemp(1);
        
        %Sample-Size Neglect task
        [Ans{12} Tm{12}] = EXPT.runauditoryoddball(2,1);        
        [Ans{2} Tm{2}] = EXPT.runcoin;
        saveTemp(2);
        
        %Attribute framing task
        [Ans{13} Tm{13}] = EXPT.runauditoryoddball(3,1);
        [Ans{3} Tm{3} Type{3}] = EXPT.runrate(1); 
        [Ans{4} Tm{4} Type{4}] = EXPT.runrate(2);
        [Ans{5} Tm{5} Type{5}] = EXPT.runrate(3);
        saveTemp(3);

        %Risky Choice framing task
        [Ans{14} Tm{14}] = EXPT.runauditoryoddball(4,1);
        [Ans{6} Tm{6} Type{6}] = EXPT.runoption1;
        saveTemp(4);
        
        %?Task Framing? task
        [Ans{15} Tm{15}] = EXPT.runauditoryoddball(5,1);
        [Ans{18} Tm{18} Type{18}] = EXPT.runoption2;
        saveTemp(5);
        
        %Persistence of Belief task
        [Ans{16} Tm{16}] = EXPT.runauditoryoddball(6,1);
        [Ans{7} Tm{7}] = EXPT.runurn;
        saveTemp(6);
        
        [Ans{17} Tm{17}] = EXPT.runauditoryoddball(7,1);
        saveTemp(7);
        
        Ans{8} = EXPT.runnfc;
        Ans{9} = EXPT.runsat;
        [Ans{10} Tm{10}] = EXPT.rundsq;
        EXPT.thankyou;
        
        %% end
        EXPT.close(number);
        if ~exist('Data','file')
            mkdir('Data');
        end
        save(sprintf('Data/S%02d_%d%02d%02d_%02d%02d%02d.mat',number,fix(clock)));

    catch exception
        if ~exist('Data','file')
            mkdir('Data');
        end
        save(sprintf('Data/%d_%d-%d-%d_%d-%d-%d-crash_external.mat',fix(clock)));
        EXPT.close(number);
        rethrow(exception);
    end 
    function saveTemp(ii)
        if ~exist('Data','file')
            mkdir('Data');
        end
        save(strcat(sprintf('Data/%d_%d-%d-%d_%d-%d-%d-',fix(clock)),'crash_external_temp_',num2str(ii),'.mat'));
    end
end

