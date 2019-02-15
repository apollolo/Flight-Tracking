function data = track(carrier, id, year, month, day)


%data = webread('https://api.flightstats.com/flex/schedules/rest/v1/json/from/JFK/to/BOS/departing/2016/12/7?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc')


str = sprintf('https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/%s/%d/arr/%d/%d/%d?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc&utc=false', carrier, id, year, month, day);
data = webread(str)

%tracking(flight carrier, #, yy/m/d

%for i = 1:length(data.flightStatuses)
    