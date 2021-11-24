create table Airline
(
	"NAME" VARCHAR(255) not null,
	HQLocation VARCHAR(255),
	Logo VARCHAR(255)
);

create unique index AIRLINE_NAME_UINDEX
	on Airline ("NAME");

alter table Airline
	add constraint AIRLINE_PK
		primary key ("NAME");

create table AirportAbbreviation
(
	ABBV VARCHAR(8) not null
	constraint AIRPORTABBREVIATION_PK
	primary key
);

create table Airport
(
	airportAbbv VARCHAR(8) not null
	constraint AIRPORT_AIRPORTABBREVIATION_ABBV_FK
	references AirportAbbreviation,
	airportName VARCHAR(255),
	airportLocation VARCHAR(255),
	radioOperator VARCHAR(255)
);

create unique index AIRPORT_AIRPORTABBV_UINDEX
	on Airport (airportAbbv);

alter table Airport
	add constraint AIRPORT_PK
		primary key (airportAbbv);

create table AirportAirline
(
	airportAbbv VARCHAR(8) not null
		constraint AIRPORTAIRLINE_AIRPORT_AIRPORTABBV_FK
			references Airport,
	airlineName VARCHAR(255) not null
		constraint AIRPORTAIRLINE_AIRLINE_NAME_FK
			references Airline,
	LOCATION VARCHAR(255),
	constraint AIRPORTAIRLINE_PK
		primary key (airportAbbv, airlineName)
);

create table Amenity
(
	amenityCode INTEGER not null,
	amenityName VARCHAR(255) not null
		constraint AMENITY_AMENITYNAME_UINDEX
			unique
);

create unique index AMENITY_AMENITYCODE_UINDEX
	on Amenity (amenityCode);


alter table Amenity
	add constraint AMENITY_PK
		primary key (amenityCode);

create table FlightCrew
(
	crewID INTEGER not null,
	crewSize INTEGER
);

create unique index FLIGHTCREW_CREWID_UINDEX
	on FlightCrew (crewID);


alter table FlightCrew
	add constraint FLIGHTCREW_PK
		primary key (crewID);

create table FlightSchedule
(
	flightNo INTEGER not null,
	airlineName VARCHAR(255) not null
		constraint FLIGHTSCHEDULE_AIRLINE__FK
			references Airline,
	schDeptTime TIME not null,
	schArrivalTime TIME not null,
	crewID INTEGER not null
		constraint FLIGHTSCHEDULE_FLIGHTCREW_CREWID_FK
			references FlightCrew,
	ORIGIN VARCHAR(8) not null
		constraint FLIGHTSCHEDULE_AIRPORT_AIRPORTABBV_FK
		references Airport,
	DESTINATION VARCHAR(8) not null
		constraint FLIGHTSCHEDULE_AIRPORT_AIRPORTABBV_FK_2
			references Airport
);

create unique index FLIGHTSCHEDULE_FLIGHTNO_UINDEX
	on FlightSchedule (flightNo);

alter table FlightSchedule
	add constraint FLIGHTSCHEDULE_PK
		primary key (flightNo);

create table Model
(
	modelName VARCHAR(255) not null,
	MANUFACTURER VARCHAR(255) not null,
	numberOfPassengers INTEGER,
	constraint MODEL_PK
		primary key (modelName, MANUFACTURER)
);

create table Airplane
(
	tailNumber VARCHAR(10) not null
		constraint AIRPLANE_PK
			primary key,
	airlineName VARCHAR(255)
		constraint AIRPLANE_AIRLINE_NAME_FK
			references Airline,
	modelName VARCHAR(255),
	MANUFACTURER VARCHAR(255),
	NICKNAME VARCHAR(255),
	constraint AIRPLANE_MODEL_MODELNAME_MANUFACTURER_FK
		foreign key (modelName, MANUFACTURER) references Model
);

create table "Role"
(
	rName VARCHAR(255) not null
);

create unique index ROLE_RNAME_UINDEX
	on "Role" (rName);


alter table "Role"
	add constraint ROLE_PK
		primary key (rName);

create table CrewMember
(
	faaNum INTEGER not null,
	fName VARCHAR(255),
	lName VARCHAR(255),
	SEX VARCHAR(255),
	"ROLE" VARCHAR(255)
		constraint CREWMEMBER_ROLE_RNAME_FK
			references "Role"
);

create unique index CREWMEMBER_FAANUM_UINDEX
	on CrewMember (faaNum);


alter table CrewMember
	add constraint CREWMEMBER_PK
		primary key (faaNum);

create table FlightCrew_CrewMember
(
	crewID INTEGER not null
		constraint FLIGHTCREW_CREW_MEMBER_FLIGHTCREW_CREWID_FK
			references FlightCrew,
	faaNum INTEGER not null
		constraint FLIGHTCREW_CREW_MEMBER_CREW_MEMBER_FAANUM_FK
			references CrewMember,
	presentRole VARCHAR(255),
	constraint FLIGHTCREW_CREW_MEMBER_PK
		primary key (crewID, faaNum)
);

create table Status
(
	statusName VARCHAR(255) not null
		constraint STATUS_PK
			primary key
);

create table FlightInstance
(
	flightInstanceID INTEGER not null,
	flightNo INTEGER not null
		constraint FLIGHTINSTANCE_FLIGHTNO_UINDEX
			unique
		constraint FLIGHTINSTANCE_FLIGHT_SCHEDULE_FLIGHTNO_FK
			references FlightSchedule,
	tailNumber varchar(10) not null
		constraint FLIGHTINSTANCE_AIRPLANE_TAILNUMBER_FK
			references Airplane,
	STATUS VARCHAR(255)
		constraint FLIGHTINSTANCE_STATUS_STATUSNAME_FK
			references Status,
	departureDate DATE,
	departureTime TIME,
	arrivalTime TIME,
	numberRegisteredPassengers INTEGER
);

create unique index FLIGHTINSTANCE_FLIGHTINSTANCEID_UINDEX
	on FlightInstance (flightInstanceID);


alter table FlightInstance
	add constraint FLIGHTINSTANCE_PK
		primary key (flightInstanceID);

create table ChargableInstance
(
	flightInstanceID INTEGER not null
		constraint CHARGABLEINSTANCE_FLIGHT_INSTANCE_FLIGHTINSTANCEID_FK
			references FlightInstance
);

create unique index CHARGABLEINSTANCE_FLIGHTINSTANCEID_UINDEX
	on ChargableInstance (flightInstanceID);


alter table ChargableInstance
	add constraint CHARGABLEINSTANCE_PK
		primary key (flightInstanceID);

create table AmenityChargableInstance
(
	amenityCode INTEGER not null
		constraint AMENITYFLIGHT_INSTANCE_AMENITY_AMENITYCODE_FK
			references Amenity,
	flightInstanceID INTEGER not null
		constraint AMENITYFLIGHT_INSTANCE_CHARGABLE_INSTANCE_FLIGHTINSTANCEID_FK
			references ChargableInstance,
	constraint TABLE_NAME_PK
		primary key (amenityCode, flightInstanceID)
);

create table DomesticInstance
(
	flightInstanceID INTEGER not null
		constraint DOMESTIC_INSTANCE_PK
			primary key
		constraint DOMESTIC_INSTANCE_CHARGABLE_INSTANCE_FLIGHTINSTANCEID_FK
			references ChargableInstance
);


create table IncidentReport
(
    IncidentID INTEGER not null,
    flightInstanceID INTEGER not null
        constraint INCIDENTREPORT_FLIGHT_INSTANCE_FLIGHTINSTANCEID_FK
            references FlightInstance,
    reporterFAANo INTEGER not null,
    reportedFAANo INTEGER not null,
    IncidentType INTEGER not null,
    reportTime TIME not null,
    DESCRIPTION VARCHAR(255)
);

create unique index INCIDENTREPORT_INCIDENTID_UINDEX
    on IncidentReport (IncidentID);

alter table IncidentReport
    add constraint INCIDENTREPORT_PK
        primary key (IncidentID);

create table InternationalInstance
(
	flightInstanceID INTEGER not null
		constraint INTERNATIONALINSTANCE_FLIGHT_INSTANCE_FLIGHTINSTANCEID_FK
			references FlightInstance
);

create unique index INTERNATIONALINSTANCE_FLIGHTINSTANCEID_UINDEX
	on InternationalInstance (flightInstanceID);


alter table InternationalInstance
	add constraint INTERNATIONALINSTANCE_PK
		primary key (flightInstanceID);

create table LocalInstance
(
	flightInstanceID INTEGER not null
		constraint LOCALINSTANCE_PK
			primary key
		constraint LOCALINSTANCE_CHARGABLE_INSTANCE_FLIGHTINSTANCEID_FK
			references ChargableInstance
);

create table PersonnelReport
(
    incidentID INTEGER not null
        constraint PERSONNELREPORT_INCIDENT_REPORT_INCIDENTID_FK
            references IncidentReport,
    SENTIMENT VARCHAR(255) not null,
        reportedFAANo INTEGER
                constraint PERSONNELREPORT_INCIDENT_REPORT_REPORTERFAANO_FK
                        references IncidentReport,
    constraint PERSONNELREPORT_PK
        primary key (incidentID,sentiment)
);

create unique index STATUS_STATUSNAME_UINDEX
	on Status (statusName);

CREATE VIEW busiestAirport AS
SELECT busyarrive.airportname, SUM(busyarrive.arriving + busydept.departing) AS totalDeptArrive FROM
    (select airportname, COUNT(flightNo) AS arriving from flightschedule fs INNER JOIN airport a ON fs.DESTINATION = a.AIRPORTABBV INNER JOIN flightinstance fi USING (flightNo) WHERE departureDate BETWEEN CAST (({fn TIMESTAMPADD( SQL_TSI_DAY, -7, CURRENT_TIMESTAMP)}) AS DATE) AND DATE(CURRENT_TIMESTAMP) group by airportname) busyarrive 
    INNER JOIN 
    (select airportname, COUNT(flightNo) AS departing from flightschedule fs INNER JOIN airport a ON fs.ORIGIN = a.AIRPORTABBV INNER JOIN flightinstance fi USING (flightNo) WHERE departureDate BETWEEN CAST (({fn TIMESTAMPADD( SQL_TSI_DAY, -7, CURRENT_TIMESTAMP)}) AS DATE) AND DATE(CURRENT_TIMESTAMP) group by airportname) busydept 
    ON busyarrive.airportname = busydept.airportname
    GROUP BY busyarrive.airportname
    ORDER BY totalDeptArrive DESC FETCH FIRST ROW ONLY;