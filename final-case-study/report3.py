import mysql.connector
from datetime import datetime

print(f"\n--- Report generated on {datetime.now().strftime('%Y-%m-%d %H:%M')} ---\n")


# Establish the database connection
mydb = mysql.connector.connect(
    user="outland_user",
    password="guide",
    host="localhost",
    database="outland_adventures",
    raise_on_warnings=True
)

# Create a cursor object
mycursor = mydb.cursor(dictionary=True)  


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
    purchase_date = row["PurchaseDate"].strftime('%Y-%m-%d') if isinstance(row["PurchaseDate"], datetime) else (str(row["PurchaseDate"]) if row["PurchaseDate"] is not None else "")
    print(f"{row['EquipmentID']:<5} {row['Name']:<20} {row['Type']:<15} {purchase_date:<15} {row['Conditions']:<12} {row['StockQuantity']:<7} {row['ReorderLevel']:<8} {row['Price']:<10} {row['ManagedByEmployeeID']:<10}")

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
    transaction_date = row["TransactionDate"].strftime('%Y-%m-%d') if isinstance(row["TransactionDate"], datetime) else (str(row["TransactionDate"]) if row["TransactionDate"] is not None else "")
    print(f"{row['TransactionID']:<5} {row['CustomerID']:<12} {row['EquipmentID']:<9} {row['TransactionType']:<18} {transaction_date:<15} {row['Quantity']:<5}")

# Close the database connection
mydb.close()
