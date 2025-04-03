# RadDetector

RadDetector is a simple Geiger-Müller counter monitoring application that captures radiation data in **CPM** (Counts per Minute) and **µSv/h** (Microsieverts per hour) using a Geiger counter (such as RadiationD-v1.1(CALJOE)) connected to a Raspberry Pi. The data is stored in a MySQL database, and can be visualized through a tool like Grafana, Zabbix, Cacti, etc..

---

## Features

- **Real-time Radiation Monitoring**: Continuously monitors radiation levels.
- **Data Logging**: Logs **CPM** and **µSv/h** values to a MySQL database.
- **Customizable**: Easily configurable for your specific Geiger counter.
- **Service-Based**: Runs as a systemd service on Linux, automatically starting on boot.
- **Web-Based Visualization**: Easily integrates with tools like Grafana for visualizing radiation data.

---

## Installation Instructions

### Prerequisites

- Raspberry Pi running **Raspbian** OS (or similar Linux distribution).
- A Geiger counter compatible with GPIO (such as RadiationD-v1.1(CALJOE)).
- MySQL server installed.
- Python 3 and required libraries.

### 1: Clone the repository

First, clone this repository to your Raspberry Pi or server on which your Geiger-Muller counter is connected:
```bash
git clone https://github.com/mflanders/RadDetector.git
cd RadDetector
```
Make sure you have a running MySQL-server.

### 2: Run the setup script
To install all dependencies and configure the system service, simply run the setup script:
```bash
sudo ./setup.sh
```
The setup script will automatically:

- Install Required Dependencies:
- Installs Python 3, MySQL client, and required Python libraries (mysql-connector, etc.).
- Copying the applicaties files to /opt/raddetector.
- Install a systemd service that will run the application on boot.

The setup script will NOT automatically:

- Install MySQL-server. (You need to install it yourself on this device or another.)
- Make database modifications (You need to execute database.sql yourself.)

## Configuration
### Application settings (`config.ini`)
The `config.ini` file allows you to modify application settings, such as:
- CPM to µSv/h ratio (Depends on your tube; J305 is specified) 
- Geiger Counter GPIO-pin.
- Database connections settings for logging detection results.

#### Example configuration
```ini
[database]
host = 127.0.0.1
user = raddetectuser
password = ChangeMe!
database = raddetect

[geiger]
pin = 7
usvh_ratio = 0.00812037037037 # For J305 tubes
```
### Database settings (`database.sql`)
- Please modify the database password in `database.sql` and run the script on your MySQL-server.
- Make sure that the password matches in the `config.ini` file.

## Troubleshooting
- If the service is not starting: Check the logs using `sudo journalctl -u raddetector`.
- Database issues: Make sure that the credentials in the `config.ini` file are correct and check if the database is accessable.

## Additional
Each Geiger-Müller tube has a different ratio for converting CPM to microsieverts (µSv/h). Below are some example ratios for the most common tubes:
#### SI-3BG
  1 CPM to µSv/h ratio: 0.00008 µSv/h per 1 CPM

#### J305
  1 CPM to µSv/h ratio: 0.0000812 µSv/h per 1 CPM

#### SBM-20
  1 CPM to µSv/h ratio: 0.00005 µSv/h per 1 CPM

#### LND-712
  1 CPM to µSv/h ratio: 0.000035 µSv/h per 1 CPM

#### LND-7317
  1 CPM to µSv/h ratio: 0.00001 µSv/h per 1 CPM

#### LND-712 (Low Range)
  1 CPM to µSv/h ratio: 0.00001 µSv/h per 1 CPM

#### FJ-80
  1 CPM to µSv/h ratio: 0.00007 µSv/h per 1 CPM

## License
This project is licensed under the MIT License.
