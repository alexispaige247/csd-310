import mysql.connector
from datetime import datetime

print(f"\n--- Report generated on {datetime.now().strftime('%Y-%m-%d %H:%M')} ---\n")

# Connect to MySQL database
conn = mysql.connector.connect(
    host="localhost",
    user="outland_user",
    password="guide",
    database="outland_adventures"
)

cursor = conn.cursor()

# Query for equipment over 5 years old
query = """
SELECT Name, PurchaseDate, 
    ROUND(DATEDIFF(CURDATE(), PurchaseDate)/365, 1) AS AgeInYears
FROM Equipment
WHERE DATEDIFF(CURDATE(), PurchaseDate)/365 > 5;
"""
cursor.execute(query)
results = cursor.fetchall()

# Headers
print("Report 2: Equipment Over 5 Years Old\n")
print(f"{'Name':<20} {'Purchase Date':<15} {'Age (Years)':<12}")
print("-" * 50)

# Print each row
for row in results:
    name, purchase_date, age_years = row
    # Format purchase_date if it's a datetime object, else convert to string
    if hasattr(purchase_date, 'strftime'):
        purchase_date_str = purchase_date.strftime('%Y-%m-%d')
    else:
        purchase_date_str = str(purchase_date)
    print(f"{name:<20} {purchase_date_str:<15} {age_years:<12}")
    

# Close connections
cursor.close()
conn.close()
