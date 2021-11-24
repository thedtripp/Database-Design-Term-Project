-- 1. The list of all airlines for a given airport --
select AIRPORT_NAME, AIRLINE_NAME, FLIGHT_TYPE from AIRPORT_AIRLINE 
natural join AIRLINE 
natural join CITY
where AIRPORT_NAME = 'Los Angeles International Airport';
-- 2. The list of all flights for a given airline. You must be able to sort this list by starting location, destination, longest flight or shortest flight --

-- Sorting by the starting location --
select AIRLINE_NAME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT, FLIGHT_CREW_NAME,
FLIGHT_DATE, FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME from FLIGHT inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join AIRPORT_AIRLINE
on DEPARTURE_AIRPORT = AIRPORT_AIRLINE.AIRPORT_NAME
inner join AIRLINE on
AIRPORT_AIRLINE.AID = AIRLINE.AID
where AIRLINE_NAME = 'Gamma_Airlines'
order by DEPARTURE_AIRPORT;
-- Sorting by the destination
select AIRLINE_NAME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT, FLIGHT_CREW_NAME,
FLIGHT_DATE, FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME from FLIGHT inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join AIRPORT_AIRLINE
on DEPARTURE_AIRPORT = AIRPORT_AIRLINE.AIRPORT_NAME
inner join AIRLINE on
AIRPORT_AIRLINE.AID = AIRLINE.AID
where AIRLINE_NAME = 'Gamma_Airlines'
order by ARRIVAL_AIRPORT;
-- Sorting by the shortest flight time
select AIRLINE_NAME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT, FLIGHT_CREW_NAME,
FLIGHT_DATE, FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME, {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, FLIGHT.FLIGHT_DEPARTURE_TIME, Flight.FINAL_ARRIVAL_TIME)} as time_difference_in_minutes 
from FLIGHT inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join AIRPORT_AIRLINE
on DEPARTURE_AIRPORT = AIRPORT_AIRLINE.AIRPORT_NAME
inner join AIRLINE on
AIRPORT_AIRLINE.AID = AIRLINE.AID
where AIRLINE_NAME = 'Gamma_Airlines'
order by {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, FLIGHT.FLIGHT_DEPARTURE_TIME, Flight.FINAL_ARRIVAL_TIME)};
-- sorting by longest flight time
select AIRLINE_NAME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT, FLIGHT_CREW_NAME,
FLIGHT_DATE, FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME , {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, FLIGHT.FLIGHT_DEPARTURE_TIME, Flight.FINAL_ARRIVAL_TIME)} as time_difference_in_minutes
from FLIGHT inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join AIRPORT_AIRLINE
on DEPARTURE_AIRPORT = AIRPORT_AIRLINE.AIRPORT_NAME
inner join AIRLINE on
AIRPORT_AIRLINE.AID = AIRLINE.AID
where AIRLINE_NAME = 'Gamma_Airlines'
order by {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, FLIGHT.FLIGHT_DEPARTURE_TIME, Flight.FINAL_ARRIVAL_TIME)} desc;
-- 3. Flights that charge for extra
select FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME, FLIGHT_CREW_NAME, FLIGHT_DATE, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT, CHARGE_TYPE, CHARGE_AMOUNT 
from FLIGHT
inner join FLIGHT_SCHEDULE on
FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join CHARGED_FLIGHT on
FLIGHT_SCHEDULE.FSID = CHARGED_FLIGHT.FSID
inner join CHARGE on
CHARGED_FLIGHT.FSID = CHARGE.FSID;
-- 4. The crew Roster for each flight for each airline
select FLIGHT.FSID, all_crew.*, DEPARTURE_AIRPORT, ARRIVAL_AIRPORT, FINAL_ARRIVAL_TIME, FLIGHT_DEPARTURE_TIME from FLIGHT_SCHEDULE inner join 
FLIGHT
on FLIGHT_SCHEDULE.FSID = FLIGHT.FSID 
inner join 
(
select FLIGHT_CREW.FLIGHT_CREW_NAME, FIRST_NAME, LAST_NAME, EMAIL, AIRLINE_NAME, 'Pilot' as occupation
from FLIGHT_CREW inner join PILOT on
FLIGHT_CREW.FLIGHT_CREW_NAME = PILOT.FLIGHT_CREW_NAME
inner join CREW_MEMBER on 
PILOT.CMID = CREW_MEMBER.CMID
inner join AIRLINE on 
CREW_MEMBER.AID = AIRLINE.AID
union
select FLIGHT_CREW.FLIGHT_CREW_NAME, FIRST_NAME, LAST_NAME, EMAIL, AIRLINE_NAME,'Co_pilot' as occupation
from FLIGHT_CREW inner join CO_PILOT on
FLIGHT_CREW.FLIGHT_CREW_NAME = CO_PILOT.FLIGHT_CREW_NAME
inner join CREW_MEMBER on 
CO_PILOT.CMID = CREW_MEMBER.CMID
inner join AIRLINE on 
CREW_MEMBER.AID = AIRLINE.AID
union
select FLIGHT_CREW.FLIGHT_CREW_NAME, FIRST_NAME, LAST_NAME, EMAIL, AIRLINE_NAME,'Navigator' as occupation
from FLIGHT_CREW inner join NAVIGATOR on 
FLIGHT_CREW.FLIGHT_CREW_NAME = NAVIGATOR.FLIGHT_CREW_NAME
inner join CREW_MEMBER on 
NAVIGATOR.CMID = CREW_MEMBER.CMID
inner join AIRLINE on 
CREW_MEMBER.AID = AIRLINE.AID
union 
select FLIGHT_CREW.FLIGHT_CREW_NAME, FIRST_NAME, LAST_NAME, EMAIL, AIRLINE_NAME,'flight_attendant' as occupation
from FLIGHT_CREW inner join FLIGHT_ATTENDANT on
FLIGHT_ATTENDANT.FLIGHT_CREW_NAME = FLIGHT_CREW.FLIGHT_CREW_NAME
inner join CREW_MEMBER on 
FLIGHT_ATTENDANT.CMID = CREW_MEMBER.CMID
inner join AIRLINE on 
CREW_MEMBER.AID = AIRLINE.AID
) as all_crew
on all_crew.flight_crew_name = FLIGHT.FLIGHT_CREW_NAME
order by FSID, occupation;
-- 5 The trips that are available if you do make one stop over
select first_trip.fsid as first_flight_taken, first_trip.flight_date as first_flight_date,
first_trip.departure_airport as starting_location, first_trip.arrival_airport as intermediate_location,
first_trip.flight_departure_time as first_flight_departure_time, 
first_trip.FINAL_ARRIVAL_TIME as first_flight_arrival_time,
next_trip.fsid as available_flight, next_trip.arrival_airport as end_location,
next_trip.flight_date as second_trip_flight_date, next_trip.flight_departure_time as second_trip_departure_time,
next_trip.final_arrival_time as second_trip_arriving_time from
(SELECT FLIGHT_SCHEDULE.FSID, AIRLINE.AIRLINE_NAME,FLIGHT_SCHEDULE.ARRIVAL_AIRPORT, 
FLIGHT_SCHEDULE.DEPARTURE_AIRPORT, FLIGHT.FLIGHT_DATE, flight.FINAL_ARRIVAL_TIME, FLIGHT.FLIGHT_DEPARTURE_TIME
from FLIGHT_SCHEDULE natural join Flight natural join  PILOT natural join CREW_MEMBER natural join AIRLINE) as first_trip
inner join (select FLIGHT_SCHEDULE.fsid, AIRLINE.airline_name, FLIGHT_SCHEDULE.arrival_airport,
flight_schedule.departure_airport, flight.flight_date, flight.final_arrival_time, flight.flight_departure_time
from FLIGHT_SCHEDULE natural join flight natural join pilot natural join crew_member natural join airline) as next_trip
on first_trip.arrival_airport = next_trip.departure_airport
where next_trip.flight_date >= first_trip.flight_date
and first_trip.final_arrival_time < next_trip.flight_departure_time
order by first_trip.departure_airport;
-- 6. Mangement reports of mifly information, including arriving flights per city, departing flights per city, list of airlines in each service category, crews that fly multiple flights in a single day
-- Arriving flights per city
select CITY_NAME, count(*) as arrival_flights from FLIGHT_SCHEDULE
inner join AIRPORT on 
FLIGHT_SCHEDULE.ARRIVAL_AIRPORT = AIRPORT.AIRPORT_NAME
inner join CITY on 
CITY.CID = AIRPORT.CID
group by CITY_NAME
order by arrival_flights desc;
-- Departing flights per city
select CITY_NAME, count(*) as departure_flights from FLIGHT_SCHEDULE
inner join AIRPORT on 
FLIGHT_SCHEDULE.DEPARTURE_AIRPORT = AIRPORT.AIRPORT_NAME
inner join CITY on 
CITY.CID = AIRPORT.CID
group by CITY_NAME
order by departure_flights desc;
-- list of airlines in each service category
select AIRLINE_NAME, FLIGHT_TYPE
from AIRLINE order by FLIGHT_TYPE;
-- Crews that fly multiple flights in a single day
SELECT FLIGHT_CREW_NAME, FLIGHT_DATE, count(FLIGHT_DATE) as number_of_flights
from FLIGHT
group by FLIGHT_CREW_NAME, FLIGHT_DATE
having count(FLIGHT_DATE) > 1;
-- 7. A list of incident reports by flight
select FLIGHT.FSID,FLIGHT_DATE, INCIDENT_TYPE, SEVERITY_AMOUNT, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT from FLIGHT
inner join INCIDENT_REPORT on
FLIGHT.FSID = INCIDENT_REPORT.FSID
inner join FLIGHT_SCHEDULE on 
FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
order by FLIGHT.FSID;
-- 8. Flights that are scheduled to depart in three days
SELECT FLIGHT_DATE, FLIGHT_CREW_NAME, FLIGHT_DEPARTURE_TIME, FINAL_ARRIVAL_TIME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT
from FLIGHT
inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
WHERE {fn TIMESTAMPDIFF(SQL_TSI_DAY, CURRENT_DATE, FLIGHT.FLIGHT_DATE)} = 3;
-- 9.  All flights that have arrived in the busiest airport in the last week.
SELECT FLIGHT.FLIGHT_DEPARTURE_TIME, FLIGHT.FINAL_ARRIVAL_TIME, FLIGHT.FLIGHT_CREW_NAME, 
FLIGHT.FLIGHT_DATE, FLIGHT_SCHEDULE.DEPARTURE_AIRPORT, FLIGHT_SCHEDULE.ARRIVAL_AIRPORT
 from FLIGHT natural join FLIGHT_SCHEDULE
where ARRIVAL_AIRPORT = (
select arrivals.arrival_airport from (select ARRIVAL_AIRPORT, count(*) as number_of_arrivals from FLIGHT_SCHEDULE
                group by ARRIVAL_AIRPORT) as arrivals
                inner join (select DEPARTURE_AIRPORT, count(*) as number_of_departures from FLIGHT_SCHEDULE
group by DEPARTURE_AIRPORT) as departures on
arrivals.arrival_airport = departure_airport
where number_of_arrivals + number_of_departures >= all( 
select  arrivals.number_of_arrivals + number_of_departures as total
from (select ARRIVAL_AIRPORT, count(*) as number_of_arrivals from FLIGHT_SCHEDULE
                group by ARRIVAL_AIRPORT) as arrivals
                inner join (select DEPARTURE_AIRPORT, count(*) as number_of_departures from FLIGHT_SCHEDULE
group by DEPARTURE_AIRPORT) as departures on
arrivals.arrival_airport = departure_airport))
AND TIMESTAMP(FLIGHT.FLIGHT_DATE, CURRENT_TIME) BETWEEN {fn TIMESTAMPADD(SQL_TSI_DAY, -12, CURRENT_DATE)} AND {fn TIMESTAMPADD(SQL_TSI_DAY, -6, CURRENT_DATE)}; 
-- 10. Flights that have departed more than 30 minutes late
select FLIGHT_DATE, FLIGHT_CREW_NAME, FLIGHT.FLIGHT_DEPARTURE_TIME, FLIGHT.FINAL_ARRIVAL_TIME, 
FLIGHT_SCHEDULE.ARRIVAL_TIME, FLIGHT_SCHEDULE.DEPARTURE_TIME, ARRIVAL_AIRPORT, DEPARTURE_AIRPORT
 from FLIGHT 
inner join FLIGHT_SCHEDULE
on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
where {fn TIMESTAMPDIFF(SQL_TSI_MINUTE, FLIGHT_SCHEDULE.DEPARTURE_TIME, FLIGHT.FLIGHT_DEPARTURE_TIME)} > 30;
-- 11. List all planes that are now retired >= 30 years of life
SELECT * FROM AIRPLANE where -{fn TIMESTAMPDIFF(SQL_TSI_YEAR, CURRENT_DATE, AIRPLANE.DATE_MANUFACTURED)} > 30;
-- 12. How many retired pilots per airline
select AIRLINE_NAME, STATE_NAME, CITY_NAME, count(*) as number_of_pilots
from PILOT
inner join CREW_MEMBER on
PILOT.CMID = CREW_MEMBER.CMID
inner join AIRLINE
on CREW_MEMBER.AID = AIRLINE.AID
inner join CITY on 
AIRLINE.CID = CITY.CID
where -{fn TIMESTAMPDIFF(SQL_TSI_YEAR, CURRENT_TIME, CREW_MEMBER.DOB)} > 65
group by AIRLINE_NAME, STATE_NAME, CITY_NAME
having count(*) >= 1;

-- 13. Crew and the airlines that they work for
select FIRST_NAME, LAST_NAME, EMAIL, AIRLINE_NAME, CITY_NAME, STATE_NAME
from CREW_MEMBER inner join AIRLINE
on CREW_MEMBER.AID = AIRLINE.AID
inner join CITY on
CITY.CID = AIRLINE.CID
order by AIRLINE_NAME;

-- 14. Do a query to find all retired pilots
SELECT FIRST_NAME, LAST_NAME, DOB, 'retired pilot' as occupation
from CREW_MEMBER inner join PILOT
on CREW_MEMBER.CMID = PILOT.CMID
left outer join FLIGHT_CREW on
PILOT.FLIGHT_CREW_NAME = FLIGHT_CREW.FLIGHT_CREW_NAME
where PILOT.FLIGHT_CREW_NAME is null
and -{fn TIMESTAMPDIFF(SQL_TSI_YEAR, CURRENT_TIME, CREW_MEMBER.DOB)} >= 65;

-- 15. Do a query to see the count of airlines a city has to show that no city headquarters more than 10 airlines 
select city_name, count(aid) as airlines_in_city from CITY natural join AIRLINE
group by city_name order by airlines_in_city desc;

-- 16. List all pilots doing international flights to ensure that they have over 10000 hours of experience
select distinct FIRST_NAME, LAST_NAME, EMAIL, HOUROFEXPERIENCE from CREW_MEMBER
inner join PILOT on 
CREW_MEMBER.CMID = PILOT.CMID
inner join FLIGHT_CREW on
PILOT.FLIGHT_CREW_NAME = FLIGHT_CREW.FLIGHT_CREW_NAME
inner join FLIGHT on 
FLIGHT_CREW.FLIGHT_CREW_NAME = FLIGHT.FLIGHT_CREW_NAME
inner join FLIGHT_SCHEDULE on FLIGHT.FSID = FLIGHT_SCHEDULE.FSID
inner join INTERNATIONAL_FLIGHT on
INTERNATIONAL_FLIGHT.FSID = FLIGHT_SCHEDULE.FSID;
