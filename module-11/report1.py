import mysql.connector
from datetime import datetime

# Establish the database connection
mydb = mysql.connector.connect(
    user="outland_user",
    password="guide",
    host="localhost",
    database="outland_adventures",
    raise_on_warnings=True
)

# Create a cursor object
mycursor = mydb.cursor()

# Query to get booking counts per year and destination
trend_query = """
    SELECT 
        Trip.Destination,
        YEAR(Booking.BookingDate) AS BookingYear,
        COUNT(*) AS TotalBookings
    FROM Booking
    JOIN Trip ON Booking.TripID = Trip.TripID
    GROUP BY Trip.Destination, BookingYear
    ORDER BY Trip.Destination, BookingYear
"""

# Execute the query
mycursor.execute(trend_query)
trend_results = mycursor.fetchall()

# Process results into a dictionary
trends = {}
for row in trend_results:
    destination = row[0]
    year = row[1]
    total = row[2]
    if destination not in trends:
        trends[destination] = []
    trends[destination].append((year, total))

# Display results
print("\n=== Booking Trends by Destination ===")
for destination in trends:
    print(f"\nDestination: {destination}")
    print(f"{'Year':<8} {'Bookings':<10}")
    print("-" * 20)
    for year, count in trends[destination]:
        print(f"{year:<8} {count:<10}")

    # Check for downward trend
    bookings = [count for year, count in trends[destination]]
    downward = all(bookings[i] > bookings[i + 1] for i in range(len(bookings) - 1))
    if downward:
        print("↓ Downward trend detected!")
    else:
        print("→ No consistent downward trend.")

# Close the connection
mydb.close()
