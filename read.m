function y = read(dep, arr, year, month, day, which, varargin)


%data = webread('https://api.flightstats.com/flex/schedules/rest/v1/json/from/JFK/to/BOS/departing/2016/12/7?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc')

str = sprintf('https://api.flightstats.com/flex/schedules/rest/v1/json/from/%s/to/%s/%s/%d/%d/%d?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc',dep,arr,which, year, month, day);
data = webread(str) %depart, arrive, yy/m/d

%str = sprintf('https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/%s/%d/arr/%d/%d/%d?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc&utc=false','JBU',1907, 2016, 12, 7);
%tracking(flight carrier, #, yy/m/d


c = 0;
if(~isempty(data.scheduledFlights))
for i = 1:length(data.scheduledFlights)
    flightID = strcat(data.scheduledFlights{i}.carrierFsCode, data.scheduledFlights{i}.flightNumber);
    numstops = data.scheduledFlights{i}.stops;
    if isfield(data.scheduledFlights{i}, 'arrivalTerminal') == 1
        arrterm = data.scheduledFlights{i}.arrivalTerminal;
    else
        arrterm = 'N/A';
    end
    if isfield(data.scheduledFlights{i}, 'departureTerminal') == 1
        depterm = data.scheduledFlights{i}.departureTerminal;
    else
        depterm ='N/A';
    end
    deptime = data.scheduledFlights{i}.departureTime;
    arrtime = data.scheduledFlights{i}.arrivalTime;
    
    arrtime = cut(arrtime);
    deptime = cut(deptime);
    
    if strcmp('departing', which) == 1
        hour = deptime{2}(1:2);
        sorthr = deptime{2}(1:5);
    else
        hour = arrtime{2}(1:2);
        sorthr = arrtime{2}(1:5);
    end
    
    c = c+1; %flight id
    
    sorthr = strrep(sorthr, ':', '.'); %change it to decimal
    sorthr = str2num(sorthr); %change it to number
    
    mat(1,i) = c; 
    mat(2,i) = sorthr; %id vs hr
    
    %fprintf('flight#%d: %s \n',c, flightID)
    %fprintf('stops: %d\n',numstops)
    %fprintf('Departure: %s terminal:%s\n', deptime{2}, depterm)
    %fprintf('Arrival: %s terminal:%s\n\n', arrtime{2}, arrterm)
  
    y(i) = str2num(hour); %every hour of each flight
    
    
end

else
    fprintf('No flights \n\n')
end

store = make(y);
if nargin == 7
    hr = varargin{1};
    %printfn(data, store{hr})%
else
    hr = 1:length(data.scheduledFlights);
    %printfn(data, hr)
end

fprintf('\n\n\n')
out = sorttime(mat);
%printfn(data, out)


end
