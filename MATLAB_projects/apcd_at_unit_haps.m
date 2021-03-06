function foo = apcd_at_unit_haps(apcd_list)

%% determine air pollution controls installed at the unit 
% mark the controls at each generator with a flag 
ctrls = apcd_list; % a list of all the controls at the generator 
flag = zeros(size(ctrls,1),4); % each column is a type of control 
for i = 1:size(ctrls,1)
    str = ctrls{i,1}; % the list of controls present 
    % for Hg controls
    index = regexp(str,'ACSI');
    if size(index,1) > 0
        flag(i,1) = 1; % ACI present
    end
    % for NOx controls
    index1 = regexp(str,'SCR'); % regexp finds the index of a pattern ('SCR') within a string (str)
    index2 = regexp(str,'SNCR');
    if size(index1,1) > 0 && size(index2,1) > 0 % if SCR & SNCR present 
        flag(i,2) = 9; 
    elseif size(index1,1) > 0 % if SCR present 
        flag(i,2) = 1; 
    elseif size(index2,1) > 0 % if SNCR present 
        flag(i,2) = 2; 
    end
    % for PM controls
    index1 = regexp(str,'ESPc'); 
    index2 = regexp(str,'ESPh'); 
    index3 = regexp(str,'FF'); 
    if size(index1,1) > 0 && size(index2,1) > 0 % if there are cESPs and hsESPs 
        flag(i,3) = 9; % default for multiple controls installed at one boiler 
    elseif size(index1,1) > 0 && size(index3,1) > 0 % csESPs and FFs present
        flag(i,3) = 9;
    elseif size(index2,1) > 0 && size(index3,1) > 0 % hsESPs and FFs present 
        flag(i,3) = 9;
    elseif size(index1,1) > 0 % csESP 
        flag(i,3) = 1;
    elseif size(index2,1) > 0 % hsESP
        flag(i,3) = 2;
    elseif size(index3,1) > 0 % FF
        flag(i,3) = 3;
    end
    % for SO2 controls
    index = regexp(str,'FGDw');
    index2 = regexp(str,'FGD');
    if size(index,1) > 0 && size(index,1) == size(index2,1) % wFGD reported & the number of wFGD reported = number of FGD units
        flag(i,4) = 1; % only wFGD present
    elseif size(index,1) > 0 && size(index2,1) > 0 % wFGD and other FGD controls reported 
        flag(i,4) = 9; 
    elseif size(index2,1) > 0 % only dFGD present 
        flag(i,4) = 2; 
    end


end 

%%
foo = flag(:,1) + flag(:,2)*10 + flag(:,3)*100 + flag(:,4)*1000;
% Consider implementing FFs to the main model� use data from Zhu as guidance. 
% To do so, reconsider how apcds are coded in the body of code. Instead of
% relying on binary which gets confusing after awhile, use powers of 10.
% Ones digit is ACI (1 or 0), tens digit is SCR (1 or 0), hundreds is PM (1
% csESP, 2 hsESP, 3 FF), and thousands is SO2 (1 is wFGD and 2 is dFGD). 9
% is multiple controls for all circumstances 


end 