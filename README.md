# **Database Design Term Project**
![airplane banner](https://user-images.githubusercontent.com/38776199/143205355-c1e87920-6b7f-4278-a165-7cb9616b3cdc.jpg)


## Contents
* [Project Description](#project-description)
* [Relation Scheme](#relation-scheme)
* [UML Diagram](#uml-diagram)
* [How to Use it](#how-to-use-it)
* [Enterprise Details](#enterprise-details)

## **Project Description**

Designed a database to track air travel related information.
Created full implementation of database in PostgreSQL with SQL.

## **Relation Scheme**
[Back to top](#database-design-term-project)

![Relation_Scheme FINAL](https://user-images.githubusercontent.com/38776199/143190147-9ab7dc03-d41c-434e-ba27-3aabbe571d8f.jpeg)

## **UML Diagram**
[Back to top](#database-design-term-project)

![UML_Diagram](https://user-images.githubusercontent.com/38776199/143190119-1300473a-6df8-4dbe-b03c-34883c54a30a.jpeg)

## **How to Use it**
[Back to top](#database-design-term-project)

- Clone the repository to your local machine and change to the directory.
  - $ `git clone https://github.com/thedtripp/Database-Design-Term-Project.git`
  - $ `cd ./Database-Design-Term-Project`
- Create your database.
- Run the SQL files in the following order.
  - Data definition language (DDL):
  - $ `./create_table.sql`
  - Data manipulation language (DML):
  - $ `./final_dml.sql`
  - Test queries:
  - $ `./queries.sql`

## **Enterprise Details**
[Back to top](#database-design-term-project)

- An airline can fly into and out of many airports. Each airline has a name and is headquartered in one particular city. 
- An airline can own any number of planes. These planes are made by a specific manufacturer with a specific model number (ex. Boeing 747) and hold a set number of passengers.
- Travel on an airplane is referred to as a flight schedule. Each flight schedule is arranged to leave a particular airport and return to a different airport. The flight schedule is identified by the airline and a number assigned by the airline itself. This flight schedule is associated with a specific departure time and an arrival time. 
- The actual occurrence of a flight on a specific date should be considered a flight instance. The instance of JetBlue fight 87 that occurs on August 10, 2019 is a flight instance. 
- An airplane is assigned to a flight instance.
- Each flight schedule is assigned a specific crew. Each crew is composed of one pilot, one co-pilot, one navigator, and anywhere from two to five flight attendants according to the number of passengers an airplane holds and the length of the flight. 
- Due to the tightened security restrictions, each crew member undergoes a background check by the FAA and is assigned an FAA number before being allowed on an airplane. 
- With the rising cost of gasoline, some airlines are now charging for water, pillows and blankets, and checking bags on a per flight basis on local or domestic flight. 
- Support generation of an Incident report - this allows a flight crew employee to file a report related to any type of incident that occurred on a flight.

[Back to top](#database-design-term-project)
