import mysql.connector
from mysql.connector import errorcode

# Database connection configuration
config = {
    "user": "outland_user",
    "password": "guide",
    "host": "localhost",
    "database": "outland_adventures",
    "raise_on_warnings": True
}

# Initialize to avoid 'can be undefined' warnings
db = None
cursor = None

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    tables = [
        "Employee", "Guide", "Customer", "Trip", "TripGuide",
        "Booking", "Equipment", "EquipmentTransaction"
    ]

    for table in tables:
        print(f"\n-- DISPLAYING {table.upper()} RECORDS --")
        query = f"SELECT * FROM {table}"
        cursor.execute(query)
        rows = cursor.fetchall()
        for row in rows:
            print(" | ".join(str(value) for value in row))

    input("\n\nPress any key to exit...")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Invalid username or password.")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist.")
    else:
        print(err)

finally:
    if cursor is not None:
        cursor.close()
    if db is not None and db.is_connected():
        db.close()