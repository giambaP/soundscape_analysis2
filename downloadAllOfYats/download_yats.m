clc; clear all; close all;


% -----  CONFIGURATION  -----------------------------

scriptFileName = 'download_yats.sh';
url = 'http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros';
downloadDir = './datasetAll/';
limitRate = 0; % 0 no limits
parallelThreads = 100;
logFileName = "download_yats.log";

% filters: if empty all of types
yats = ["YAT1Audible", "YAT2Audible", "YAT3Audible"];
years = []; %["2020"];
days = []; %[1:31];
months = []; % ["3","4","5"];
hours = []; %["2","6","10","14","18","22"]; 
minutes = []; % ["0"];


% -----  EXECUTION  --------------------------------

function res = getRegexOrDefaultIfNoFilter(arr, padding, defaultRegex)
    if ~isempty(arr);  res = strjoin(pad(arr,padding,'left','0'),"|"); 
    else; res = defaultRegex; end
end

% regex yyyyMMdd_hhMMss.WAV
yearRegex = getRegexOrDefaultIfNoFilter(years, 4, "[1,2]{1}[0-9]{3}");
monthsRegex = getRegexOrDefaultIfNoFilter(months, 2, "[0,1]{1}[0-9]{1}");
daysRegex = getRegexOrDefaultIfNoFilter(days, 2, "[0-3]{1}[0-9]{1}");
hoursRegex = getRegexOrDefaultIfNoFilter(hours, 2, "[0-2]{1}[0-9]{1}");
minutesRegex = getRegexOrDefaultIfNoFilter( minutes, 2, "[0-5]{1}[0-9]{1}");
regex = strcat("(", yearRegex, ")", ...    % hours
               "(", monthsRegex,")", ...   % months
               "(", daysRegex, ")", ...    % days
               "_", ...                    % _
               "(", hoursRegex,")", ...    % hours
               "(", minutesRegex,")", ...  % minutes
               "([0-5][0-9])", ...         % seconds
               "\.WAV");                   % extension
% wget param cut-dirs
cutDirs = num2str(count(url, "/") - 2);
% yat urls
urls = strcat(url, "/", yats, "/");

% commands
sheBang = "#!/bin/sh";
errMgmt = "set -e";
mkdirCmd= sprintf('mkdir -p "%s"', downloadDir); 
wgetCmd = sprintf(['wget -r -v -nc -np -nH --max-threads=%d -a "%s" ' ...
    '--limit-rate=%d --cut-dirs=%s --accept-regex "%s" -P "%s" %s'], ...
     parallelThreads, logFileName, limitRate, cutDirs, regex, ...
     downloadDir, strjoin(urls, ' '));
    
% write on file
fd = fopen(scriptFileName,'w');
fprintf(fd,'%s', sheBang);
fprintf(fd,'\n\n');
fprintf(fd,'%s', errMgmt);
fprintf(fd,'\n\n');
fprintf(fd,'%s', mkdirCmd);
fprintf(fd,'\n\n');
fprintf(fd,'%s', wgetCmd);
fclose(fd);
