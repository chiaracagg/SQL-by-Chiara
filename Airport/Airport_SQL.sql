#                   Atlanta Airport Dataset

# this dataset contains all the information on the flights that arrived at Atlanta Airport
Select * 
from atl_flightdata;

# This dataset which contains information on the airports
Select * 
from airports_1
order by State;


#I want to join both dataset but first I want to see what data is missing 
#from the second dataset to have a complete new table when combined
SELECT Distinct  atl_flightdata.origin 
FROM  atl_flightdata
LEFT JOIN  airports_1 
ON  atl_flightdata.origin = airports_1.IATA_CODE
WHERE airports_1.IATA_CODE IS NULL;


#With the code above I saw that one airport didn't have a value for the state in which is 
#located so I manually filled in the null values (this case is special as it is only
#one null value) and this new table is the one I'll use for future queries

CREATE TABLE final_table AS
SELECT CASE 
        WHEN atl_flightdata.origin = 'ECP' AND airports_1.State IS NULL THEN 'FL' 
        ELSE airports_1.State
    END AS 'State', atl_flightdata.*
FROM  atl_flightdata
LEFT JOIN airports_1 
ON atl_flightdata.origin = airports_1.IATA_CODE;

#Now I can start looking at some valuable insights with the new table I have created
SELECT COUNT(*) as count_table
FROM final_table;

# 1. Which airline operated the most flights out of ATL last year, and how many flights did they operate? 
#(data only has first day of each month)
select airline,count(*) as number_of_flights
from final_table 
group by airline
order by number_of_flights desc;
 
 #How many different origin airports did each airline fly from into ATL in 2021?
 select airline,count(DISTINCT origin)
 from final_table
 group by airline
 order by count(*) desc ;
 
#How many DIFFERENT origin states did each airline fly from (into ATL) in 2021?
 select airline,count(DISTINCT State)
 from final_table
 group by airline
 order by count(*) desc;
 
 #What airline only flys to ATL?
SELECT airline, COUNT(DISTINCT State) as count_state
FROM final_table
GROUP BY airline
HAVING count_state = 1;

 
 # The observation above will be ignored to calculate delays because since its 
 #delays could be due to problems at the one airport it flies from
 SELECT *
 FROM final_table
WHERE (airline != 'Alaska');
 
 
 # let's start analyzing delay data among the remaining airlines
 SELECT airline, AVG(arrival_delay) AS 'avg_delay'
FROM final_table
GROUP BY airline 
ORDER BY (avg_delay) DESC;
 
 # I want to analyze delays so I only want to use airlines with delays so i'll be removing the ones with
 #no avg delay
 SELECT airline, AVG(delay_airline) 
FROM final_table
GROUP BY airline 
HAVING AVG(delay_airline)  > 1
ORDER BY AVG(delay_airline)desc;
 
# A possible reason for delays is the airport of departure and not the airline itself. To get a better understanding
#on airlines performance I'll select 4 airports in two different states to see the average delay in each of them. If one airline has consistently 
#lower delays from all these airports, that is strong evidence that this airline really does perform better than the others.
 SELECT 
    airline,origin, COUNT(*) AS 'Num_flights'
FROM
    final_table
WHERE 
origin in ('JFK','LGA','ORD','MDW')
GROUP BY airline, origin
ORDER BY (airline),(origin) ASC;
 
 #With the query below it was shown that only Delta operates in all airports selected
 #I'll only select the two airports in Chicago (ORD,MDW) as the city test to see delays across airlines 
 #I chose this state because it is the city in which all airlines operate from
 
 #Best airport to fly out of to fly Chicago- ATL is:
SELECT airline,origin, AVG(arrival_delay) AS 'avg_delay',COUNT(*) AS num_flights
FROM final_table
WHERE origin in ('MDW','ORD')
GROUP BY  airline,origin
ORDER BY (avg_delay) asc;
 
#Here we can take a closer look at why each earline was delayed
# We can see that Soutwest delays are caused by the airline itself
#Delta has the highest delays caused by air traffic control
#If you are flying Delta you have higher chances of delay coming out of MDW airport. 
SELECT 
    airline,
    origin, 
    AVG(arrival_delay) AS avg_delay, 
    AVG(delay_airline) AS total_airline_delay, 
    AVG(delay_nas) AS total_nas_delay, 
    AVG(delay_aircraft_arrival) AS total_aircraft_delay
FROM 
    final_table
WHERE 
    origin IN ('MDW', 'ORD')
GROUP BY  
    airline, 
    origin
ORDER BY 
    avg_delay ASC;
 
 