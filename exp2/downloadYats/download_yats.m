clc; clear all; close all;


% -----  CONFIGURATION  -----------------------------

scriptFileName = 'download_yats.sh';
url = 'http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros';
downloadDir = '../datasetDN/';
limitRate = 0; % 0 no limits
parallelThreads = 100;
logFileName = "download_yats.log";

% filters
yats = ["YAT1Audible", "YAT2Audible", "YAT3Audible"];
years = ["2020"];
months = ["3","4","5"];
hours = ["2","6","10","14","18","22"];
minutes = ["0"];


% -----  EXECUTION  --------------------------------

% regex yyyyMMdd_hhMMss.WAV
yearRegex = strjoin( pad(years, 2, 'left','0') , "|" );
monthsRegex = strjoin( pad(months, 2, 'left','0') , "|" );
hoursRegex = strjoin( pad(hours, 2, 'left','0') , "|") ;
minutesRegex = strjoin( pad(minutes, 2, 'left','0') , "|" );
regex = strcat("(", yearRegex, ")", ...    % hours
               "(", monthsRegex,")", ...   % months
               "([0-3][0-9])", ...         % days
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
mkdirCmd= sprintf('mkdir -p "%s"', downloadDir);
wgetCmd = sprintf(['wget -r -np -nH --max-threads=%d -o "%s" ' ...
    '--limit-rate=%d --cut-dirs=%s --accept-regex "%s" -P "%s" %s'], ...
     parallelThreads, logFileName, limitRate, cutDirs, regex, ...
     downloadDir, strjoin(urls, ' '));
    
% write on file
fd = fopen(scriptFileName,'w');
fprintf(fd,'%s', sheBang);
fprintf(fd,'\n\n');
fprintf(fd,'%s', mkdirCmd);
fprintf(fd,'\n\n');
fprintf(fd,'%s', wgetCmd);
fclose(fd);

% exec directly
% [status, result] = system(mkdirCmd);
% disp(['Mkdir [ status',status,", exitCode: ",result,"]\n"]);
% [status, result] = system(wgetCmd);
% disp(['WGet [ status',status,", exitCode: ",result,"]\n"]);
































% clc;
% clear all;
% close all;
%
% % configuration
% scriptFileName='scarica_file.sh';
% url='http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros';
% downloadDir='./datasetDN/';
%
% yats=['YAT1Audible' 'YAT2Audible' 'YAT3Audible'];
% years=['2020'];
% months=['3' '4' '5'];
% hours=['2' '6' '10' '14' '18' '22'];
% minutes=['0'];

% % execution
%
% % DEFINE CREATE DIR AND SET OUTPUT FILE
%
% fd = fopen(scriptFileName,'w');
% ora = 0;
%
% for yearIdx = 1:length(years)
%     year = years(yearIdx);
%
%     for monthIdx = 1:length(months)
%         month = months(monthIdx);
%
%         monthDuration = days(eomday(str2double(year), str2double(month)));
%         daysOfMonth = length(days(1:monthDuration));
%
%         for dayIdx = 1:daysOfMonth
%             for hourIdx = 1:length(hours)
%                 hour = hours(hourIdx);
%                 for minuteIdx = 1:length(minutes)
%                     minute = minutes(minuteIdx);
%
%                     monthStr = sprintf('%0*d', 2, str2double(month));
%                     dayStr = sprintf('%0*d', 2, dayIdx);
%                     hourStr = sprintf('%0*d', 2, str2double(hour));
%                     minuteStr = sprintf('%0*d', 2, str2double(minute));
%
%                     fileName = sprintf('%s%s%s_%s%s00.WAV', year, monthStr, dayStr, hourStr, minuteStr);
%                     fileUrl = sprintf('%s/%s', url, fileName);
%                     outputFilePath = sprintf('%s/%s', dir, fileName);
%                     command = sprintf([ ...
%                         'wget -q --spider "%s" ' ...
%                         '&& wget -q -O "%s" "%s"' ...
%                         '|| echo -e "Failed download for %s"'], fileUrl, outputFilePath, fileUrl, fileUrl);
%
%                     fprintf(fd,'%s\n',command);
%                 end
%             end
%         end
%     end
% end
%
% fclose(fd);



