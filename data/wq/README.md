This is the `data` folder. This folder contains the files:  
  
-`dis.rds` - this .rds file is needed to run the Quarterly report, information is pulled from an API using the 'waterData` package
-`dis1.rds` - this .rds file is needed to run the Quarterly report, information is pulled from an API using the 'waterData` package
- `lab.csv` - a .csv file containing the discrete and YSI water quality measurements, edited and created by the, `data_script` which pulls in the observations from the MySQL database 
- `wq.csv` - a .csv file containing the Star-Oddi and Diver sensor data, edited and created by the `data_script`, which pulls in the observations from the MySQL database  
- `wq_location_gps.txt` - this is a .txt file which contaings the GPS coordinates of the water quality sensors, this file is not used in the Shiny App  
- `wq_total.csv` - a .csv file containing the Star-Oddi and Diver sensor data, unedited (not manipultaed) and created by the `data_script`, which pulls in the observations from the MySQL database  