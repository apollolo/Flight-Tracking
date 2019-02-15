function Flight
f = figure('Visible', 'off', 'color', 'white', 'Units', 'Normalized', 'Position', [0.5 0.5 0.3 0.3], 'Color', [0 0.8 0.8]);
f.Name = 'Flight';
movegui(f, 'center')
find_button =  uicontrol('Style', 'pushbutton', 'String', 'START', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.35 .2 .3 .3], 'Callback', @callbackfn);
f.Visible = 'on'
%Call back function
function callbackfn(hObject, eventdata)
set([find_button], 'Visible', 'off');
airport = uicontrol('Style', 'text', 'String', 'Airport', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.75 .2 .1]);
depart = uicontrol('Style', 'text', 'String', 'Depart', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.3 0.85 .2 .1]);
arrive = uicontrol('Style', 'text', 'String', 'Arrive', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.5 0.85 .2 .1]);
date = uicontrol('Style', 'text', 'String', 'Date (Year/Month/Date)', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.55 .2 .1]);
time = uicontrol('Style', 'text', 'String', 'Time(0-23hr) (optional)', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.35 .2 .1]);
hour = uicontrol('Style', 'text', 'String', 'Hour of Day', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.3 0.35 .2 .1]);
depart1 = uicontrol('Style', 'edit', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.3 0.75 .2 .1]);
arrive1 = uicontrol('Style', 'edit', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.5 0.75 .2 .1]);
day1 = uicontrol('Style', 'edit', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.3 0.55 .2 .1]);
hour1 = uicontrol('Style', 'edit', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.3 0.35 .2 .1]);
search_button = uicontrol('Style', 'pushbutton', 'String', 'SEARCH','FontSize', 20, 'Units', 'Normalized', 'Position', [.37 .2 .3 .1], 'Callback', @callbackfn2);
grouph=uibuttongroup('Parent',f,'Units','Normalized','Position',[0.5 0.35 0.3 0.3]);
toph=uicontrol(grouph,'Style','radiobutton','String','arrive','Units','Normalized','FontSize',20,'Position',[0.5 0.55 0.3 0.15]);
both=uicontrol(grouph,'Style','radiobutton','String','depart','Units','Normalized','FontSize',20,'Position',[0.5 0.25 0.3 0.15]);
    
    
function callbackfn2(~,~)
    set([airport depart arrive date time hour depart1 arrive1 day1 hour1 search_button grouph toph both],'Visible','off')
    dep = depart1.String;
    arr = arrive1.String;
    [year rest]=strtok(day1.String,'/');
    [month rest2]=strtok(rest,'/');
    [day rest3]=strtok(rest2,'/');
    opttime = hour1.String; 

    select = get(grouph, 'SelectedObject');

    if select == toph 
        which = 'arriving';
    else 
        which = 'departing';
    end
         
if(isempty(dep)||isempty(arr)||isempty(day1.String))

    err = uicontrol('Style', 'text', 'String', 'error, please check if airport codes or dates are correct', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.35 .5 .3 .1]);
    movegui(err,'center')
    %display error if faulty inputs

    
else
str = sprintf('https://api.flightstats.com/flex/schedules/rest/v1/json/from/%s/to/%s/%s/%d/%d/%d?appId=7de41b79&appKey=cac6a6dbe5e9182cc0357e5ca0f3a2dc',dep,arr,which, str2num(year), str2num(month), str2num(day));
data = webread(str); %read the API format: depart, arrive, yy/m/d

c = 0;%initial for # of flights


for i = 1:length(data.scheduledFlights)
   
    deptime = data.scheduledFlights{i}.departureTime; %return (date)T(time)
    arrtime = data.scheduledFlights{i}.arrivalTime; 
    
    arrtime = cut(arrtime); %cut the T out
    deptime = cut(deptime);
    
    if strcmp('departing', which) == 1
        hour = deptime{2}(1:2); %display time only
        sorthr = deptime{2}(1:5); %display time for sort
    else
        hour = arrtime{2}(1:2);
        sorthr = arrtime{2}(1:5);
    end
    
    c = c+1; %number of flights
    
    sorthr = strrep(sorthr, ':', '.'); %change it to string decimal
    sorthr = str2num(sorthr); %change it to number
    
    mat(1,i) = c; 
    mat(2,i) = sorthr; %id vs hr
    
   
    y(i) = str2num(hour); %every hour of each flight
    
    
end


store = make(y); %return what flight leaves at what hour


show_button = uicontrol('Style', 'pushbutton', 'String', 'Show All the Flights','FontSize', 20, 'Units', 'Normalized', 'Position', [.37 .7 .3 .1], 'Callback', @callbackfn4);

plot_button = uicontrol('Style', 'pushbutton', 'String', 'Plot the Flights by Time','FontSize', 20, 'Units', 'Normalized', 'Position', [.37 .5 .3 .1], 'Callback', @callbackfn5);

stats_button = uicontrol('Style', 'pushbutton', 'String', 'Show the Statistic','FontSize', 20, 'Units', 'Normalized', 'Position', [.37 .3 .3 .1], 'Callback', @callbackfn6);

end
        
function callbackfn4(~,~) 
            
set([plot_button stats_button show_button],'Visible','off')
            
if isempty(opttime) == 0
               
 hr = str2num(opttime); 
 result = printfn(data, store{hr-1});
            
else
 hr = 1:length(data.scheduledFlights);
 result = printfn(data, hr);
            
end
            
flighttext = uicontrol('Style', 'text', 'String','The Available Flights', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.85 .4 .1]);
            

if isempty(result) == 0
result = result(~cellfun('isempty',result)); %cut out all empty strings to organize
 else
result = 'No Flights'; %if no flights leave in that hour, disply no flights
end

flightsID = uicontrol('Style', 'edit', 'String',result, 'FontSize', 10, 'Min',0, 'Max',2,'Unit', 'Normalized', 'Position', [.2 0.3 .4 .3]);            
%print out flight information

         end
   
       
function callbackfn5 (~,~)
set([show_button stats_button plot_button],'Visible','off')
bartext = uicontrol('Style', 'text', 'String', 'The Flights on This Day', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.9 .35 .08]);
x = 0:23; 
axes('Unit','Normalized','Position',[.1 .5 .35 .35])
[store vec] = make(y); %return number of flights leaving in that hour
bar(x,vec) %graph it
xlabel('Hour of the day')
ylabel('Number of the flights')
axis([0 23 0 30])

end
      
  
function callbackfn6 (~,~)
    set([show_button plot_button stats_button],'Visible','off')
    stdnum1=std('arrtime');
    stdnum2=std('deptime');
    stdnum3=std('durationtime')
            
    stdtext1= uicontrol('Style', 'text', 'String','The std of the arrive time', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.9 .4 .1]);
    stdnumbox1= uicontrol('Style', 'text', 'String', stdnum1, 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.8 .4 .1]);
    stdtext2= uicontrol('Style', 'text', 'String','The std of the depart time', 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.6 .4 .1]);
    stdnumbox2= uicontrol('Style', 'text', 'String', stdnum2, 'FontSize', 20, 'Units', 'Normalized', 'Position', [.1 0.5 .4 .1]);

end


end

function str = cut(time) %function that cut out the T
    str = strsplit(time,'T');
    str{2} = str{2}(1:8);
    end
    
function [store, varargout] = make(y)%function that creates vector of hours
    for n = 1:24
        len = find(y==(n-1));
        vec(n) = length(len);
        store{n} = len;
    end
    if nargout == 2
        varargout{1} = vec;
    end
end

function result = printfn(data, what) %function that gets the information
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

end

    if isempty(result) == 1
        result = [];
    end


end
    
function outv = sorttime(mat) %function that sort the hours in order

    id = mat(1,:);
    hr = mat(2,:);
    for i=1:length(hr)-1
         indlow=i;
         for j=i+1:length(hr)
            if hr(j) < hr(indlow)
              indlow=j;
            end
         end
         temp=hr(i);
         hr(i)=hr(indlow);
         hr(indlow)=temp;
        
         temp=id(i);
         id(i)=id(indlow);
         id(indlow)=temp;
    end
    outv=id;
end


end
    
end



