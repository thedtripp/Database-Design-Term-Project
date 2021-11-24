# Database Design Term Project

## Contents
* [Project Description](#project-description)
* [UML Diagram](#uml-diagram)
* [Relation Scheme](#relation-scheme)

## **Project Description**

Designed a database to track airline related information.
Modeled this enterprise using the information supplied below:

- An airline can fly into and out of many airports. Each airline has a name and is headquartered in one particular city. 
- An airline can own any number of planes. These planes are made by a specific manufacturer with a specific model number (ex. Boeing 747) and hold a set number of passengers.
- Travel on an airplane is referred to as a flight schedule. Each flight schedule is arranged to leave a particular airport and return to a different airport. The flight schedule is identified by the airline and a number assigned by the airline itself. This flight schedule is associated with a specific departure time and an arrival time. 
- The actual occurrence of a flight on a specific date should be considered a flight instance. The instance of JetBlue fight 87 that occurs on August 10, 2019 is a flight instance. 
- An airplane is assigned to a flight instance.
- Each flight schedule is assigned a specific crew. Each crew is composed of one pilot, one co-pilot, one navigator, and anywhere from two to five flight attendants according to the number of passengers an airplane holds and the length of the flight. 
- Due to the tightened security restrictions, each crew member undergoes a background check by the FAA and is assigned an FAA number before being allowed on an airplane. 
- With the rising cost of gasoline, some airlines are now charging for water, pillows and blankets, and checking bags on a per flight basis on local or domestic flight. 
- Support generation of an Incident report - this allows a flight crew employee to file a report related to any type of incident that occurred on a flight.

## **UML Diagram**

![UML_Diagram](https://user-images.githubusercontent.com/38776199/143190119-1300473a-6df8-4dbe-b03c-34883c54a30a.jpeg)

## **Relation Scheme**

![Relation_Scheme FINAL](https://user-images.githubusercontent.com/38776199/143190147-9ab7dc03-d41c-434e-ba27-3aabbe571d8f.jpeg)
