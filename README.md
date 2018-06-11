# xconfig


This program builds and runs a simple GUI using Perl modules Tkx and includes buttons and text fields that will execute commands to the Miktrotik routers using the Mtik module. 


The text fields following "Current Username", "Current Password", and "Current IP" are required to log in to the router to execute the commands. Currently there is no option to change any of these fields from defaults, though that may be implemented in the future. These three fields must be filled out at all times when the program attempts to connect with the router as the program does not maintain a connection through the session, instead it makes a new connection each time a button requiring a connection is pressed and ends that session when the code is executed. 


Exit : Closes out of the program 

Clear: Clears out all fields except for the "Current Username", "Current Password", and "Current IP" 

Print: Prints out a router configuration sheet using information from the text fields. These sheets are held on the Data Truck servers and are filled out and printed at our office and given to customers. The sheets contain the SSID and Wifi password as well as simple troubleshooting tips. Requires SSID, Wifi Password, and both Name fields to be filled out or an error message will appear. 

Read: Connects to the router and pulls information out of it to fill in (and overwrite any preexisting text) all of the text fields. The connection is then ended. 

Write: Writes all fields back into the router. Note that leaving a field blank will write a blank into the router, so it is advised to read first and make changes before writing back into the router. 

New: Generates a randomized password and fills in the Wifi Password field with that. Passwords are currently designed to be SouthDakota with 5 random numbers appended. 

Fill Fields: Requires the filling of the first and last name fields, then takes that information and generates standard information based on that name. Description is filled out with first and last name, Hostname is set to first initial and last name with "Router" appended, SSID is set to the first initial of the first name and the first 16 letters of last name. A random password is generated, the same as pressing "New". 
