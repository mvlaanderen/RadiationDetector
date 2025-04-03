"""
============================================================
|                 RadDetector - Radiation Monitoring       |
|----------------------------------------------------------|
| Version : v1.0                                           |
| Author  : M. Vlaanderen                                  |
| GitHub  : https://github.com/mflanders/RadDetector       |
| License : MIT                                            |
============================================================
"""

import time
import datetime
import configparser
import mysql.connector
import RPi.GPIO as GPIO
from collections import deque

# Load configuration
config = configparser.ConfigParser()
config.read('config.ini')

# MySQL Database settings
DB_CONFIG = {
    'host': config['database']['host'],
    'user': config['database']['user'],
    'password': config['database']['password'],
    'database': config['database']['database']
}

# Geiger settings
USVH_RATIO = float(config['geiger']['usvh_ratio'])
GEIGER_PIN = int(config['geiger']['geiger_pin'])

# GPIO setup
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
GPIO.setup(GEIGER_PIN, GPIO.IN)

counts = deque()

def countme(channel):
    counts.append(datetime.datetime.now())

GPIO.add_event_detect(GEIGER_PIN, GPIO.FALLING, callback=countme)

# Function definitions
def get_db_connection():
    return mysql.connector.connect(**DB_CONFIG)

def save_measurement(cpm, usvh):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        cursor.execute("""
            INSERT INTO radiation (timestamp, cpm, usvh)
            VALUES (%s, %s, %s)
        """, (timestamp, cpm, usvh))

        conn.commit()
        cursor.close()
        conn.close()
        print(f"Data send to database: CPM={cpm}, uSv/h={usvh}")
    except mysql.connector.Error as e:
        print(f"Database error: {e}")

def main():
    loop_count = 0
    while True:
        try:
            while counts and counts[0] < datetime.datetime.now() - datetime.timedelta(seconds=60):
                counts.popleft()
        except IndexError:
            pass

        loop_count += 1

        if loop_count == 10:
            cpm = len(counts)
            usvh = round(cpm * USVH_RATIO, 2)

            save_measurement(cpm, usvh)

            counts.clear()
            loop_count = 0

        time.sleep(1)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("RadDetector stopped by user.")
        GPIO.cleanup()
