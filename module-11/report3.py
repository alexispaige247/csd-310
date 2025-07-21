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

# Query for the Equipment table
equipment_query = """
    SELECT EquipmentID, Name, Type, PurchaseDate, Conditions, 
           StockQuantity, ReorderLevel, Price, ManagedByEmployeeID 
    FROM Equipment
    ORDER BY EquipmentID
"""

# Execute Equipment data
mycursor.execute(equipment_query)
equipment_results = mycursor.fetchall()

# Display Equipment results
print("\n=== Equipment Inventory ===")
print(f"{'ID':<5} {'Name':<20} {'Type':<15} {'Purchase Date':<15} {'Condition':<12} {'Stock':<7} {'Reorder':<8} {'Price':<10} {'ManagedByEmpID':<10}")
print("-" * 105)
for row in equipment_results:
    purchase_date = row[3].strftime('%Y-%m-%d') if isinstance(row[3], datetime) else str(row[3])
    print(f"{row[0]:<5} {row[1]:<20} {row[2]:<15} {purchase_date:<15} {row[4]:<12} {row[5]:<7} {row[6]:<8} {row[7]:<10} {row[8]:<10}")

# Query for the EquipmentTransaction table
transaction_query = """
    SELECT TransactionID, CustomerID, EquipmentID, TransactionType, TransactionDate, Quantity 
    FROM EquipmentTransaction
    ORDER BY TransactionID
"""

# Execute EquipmentTransaction data
mycursor.execute(transaction_query)
transaction_results = mycursor.fetchall()

# Display Transaction results
print("\n=== Equipment Transactions ===")
print(f"{'TID':<5} {'CustomerID':<12} {'EquipID':<9} {'Type':<18} {'Date':<15} {'Qty':<5}")
print("-" * 70)
for row in transaction_results:
    transaction_date = row[4].strftime('%Y-%m-%d') if isinstance(row[4], datetime) else str(row[4])
    print(f"{row[0]:<5} {row[1]:<12} {row[2]:<9} {row[3]:<18} {transaction_date:<15} {row[5]:<5}")

# Close the database connection
mydb.close()
