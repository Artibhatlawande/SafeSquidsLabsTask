TaskA-FileA.sh and TaskA-FileB.sh both have Script for first/Set-1 task.
TaskB-FileA.sh and TaskB-FileB.sh both have Script for second/Set-2 task.
Difference in FileA and FileB is, FileA of both task have script that execute and prints only expected simple output while FileB of both task have script that after execution will print an output in organised manner in table format.

To execute all File
Prerequisites: 
1. Amazon Linux server with any configuration (here it is t2.micro)
2. Connected server via Putty SSH

Steps:
1. First login server via Putty
2. Install git on server and pull the required files on your machine
3. After getting files to your machine, check permissions of files
4. Make sure file has permission for execution, if not we can give by => sudo chmod +x file_name
5. Now, file can be executed by => sudo ./file_name      // For TaskA files needs to use => sudo ./file_name -argument  (argument can be -cpu, -memory, -disk or for everything we can use -all)

In this way we can run all files!!

