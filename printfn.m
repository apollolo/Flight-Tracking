function result = printfn(data, what)


result = [];
for i = what
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
    
    result{i}= sprintf('flight#%d: %s \nDeparture: %s terminal:%s\nArrival: %s terminal:%s\n\n',i, flightID, deptime{2}, depterm, arrtime{2}, arrterm);
%fprintf('stops: %d\n',numstops)
%fprintf('Departure: %s terminal:%s\n', deptime{2}, depterm)
%fprintf('Arrival: %s terminal:%s\n\n', arrtime{2}, arrterm)
end

if isempty(result) == 0
result = [];
end


end