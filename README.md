
Project README: System Monitoring Scripts

This document provides comprehensive steps for executing the Set-1 and Set-2 task scripts designed for system monitoring on an Amazon Linux server. These scripts help monitor CPU, memory, disk, and other resources in a straightforward or organized table format.

Project Overview
The project includes two sets of tasks:

Set-1:
TaskA-FileA.sh: Basic script execution with simple output.
TaskA-FileB.sh: Enhanced script execution with output presented in a table format.
Set-2:
TaskB-FileA.sh: Basic script execution with simple output.
TaskB-FileB.sh: Enhanced script execution with output presented in a table format.

Prerequisites
Before running the scripts, ensure the following:

Environment: Amazon Linux server (e.g., t2.micro instance)
Access Method: SSH connection using PuTTY
Tools Required:
git (for pulling the script repository)
Bash shell

Setup and Installation
1. Login to the Server:
Use PuTTY to SSH into your Amazon Linux instance with your credentials.

2. Install Git (if not already installed):
Run the following command to install Git:
```bash
sudo yum install git -y
```

3. Clone the Repository:
Fetch the script files from the Git repository:
```bash
git clone <repository-url>
```

4. Set Script Permissions:
Ensure all scripts have the correct execution permissions:
```bash
sudo chmod +x TaskA-FileA.sh TaskA-FileB.sh TaskB-FileA.sh TaskB-FileB.sh
```

Usage Instructions
Set-1: TaskA Script Execution
1. Executing TaskA-FileA.sh:
This script runs and outputs the results directly without formatting.

Example usage:
```bash
sudo ./TaskA-FileA.sh -cpu
```

2. Executing TaskA-FileB.sh:
This script organizes the output into a table format.

Example usage:
```bash
sudo ./TaskA-FileB.sh -all
```

Set-2: TaskB Script Execution
1. Executing TaskB-FileA.sh:
This script runs and outputs the results directly without formatting.

Example usage:
```bash
sudo ./TaskB-FileA.sh
```

2. Executing TaskB-FileB.sh:
This script organizes the output into a table format.

Example usage:
```bash
sudo ./TaskB-FileB.sh
```

Command-Line Arguments
Each script supports the following arguments:

-cpu: Monitors CPU usage.
-memory: Monitors memory usage.
-disk: Monitors disk usage.
-all: Monitors all resources.

Note: Use the relevant argument based on the resource you want to monitor. For TaskA-FileB.sh and TaskB-FileB.sh, the results will be presented in a neatly formatted table.

Example Workflow
1. Connect to the Server:
SSH using PuTTY.

2. Clone the Repository and Set Permissions:
Follow the steps in the setup section.

3. Execute a Script:
Choose a script (e.g., TaskA-FileA.sh) and run it with the desired argument (e.g., -cpu).

4. Review the Output:
For FileA scripts, expect straightforward output.
For FileB scripts, view the organized output in a table format.

Troubleshooting
If you encounter permission issues, recheck the permissions using:
```bash
ls -l
```
and adjust using:
```bash
sudo chmod +x file_name.sh
```

Ensure your SSH session is active and stable when executing long-running scripts.
