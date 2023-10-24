#                             SQL- Game of Thrones Dataset
# I am a huge Game of Thrones fan and I wanted to learn more about the tv show. So with this project I'll be
# answering some questions I thought would be interesting.

#1 Looking at the entire dataset
select * 
from got_data;

#2 How many episodes has each director made?
Select Director, 
count(Director) as episodes_directed
from got_data
group by Director 
order by episodes_directed DESC;

#3 Question:What director brought in a higher rating for their episodes?
Select Director, 
Round(AVG (Imdb_Rating),2) AS Imdb_Rating
from got_data
group by Director 
order by Imdb_Rating DESC;

#4 Episodes nine are notorious for being the most intese of each season. Are they the most viewed each season?
SELECT Number_in_Season, AVG (US_viewers_million) AS avg_us_viewers
FROM got_data
GROUP BY Number_in_Season
order by avg_us_viewers DESC;

#5 People often say the last season (season 8) is the worst season. Is it also the lowest rated?
SELECT Season, 
ROUND(AVG(Imdb_Rating), 2) as season_rate
FROM got_data
GROUP BY Season
order by season_rate ASC;

# 6 Watching the show is a time commitment. What season will take you the longest to watch?
SELECT Season, 
SUM((Runtime_mins)/60) as season_length_hr
FROM got_data
GROUP BY Season
order by season_length_hr DESC;

#7 How many hours will it take you to watch the entire show?
select sum(Runtime_mins)/60 as total_hours
FROM got_data; 

#7 In what season were there more character killed?
SELECT Season,
SUM(Notable_Death_Count) as total_deaths
FROM got_data
GROUP BY Season
order by total_deaths desc;


#8 What writer or duo of writters have killed the most characters?
SELECT Writer,SUM(Notable_Death_Count) as total_killed
FROM got_data
GROUP BY Writer
ORDER BY total_killed DESC;

