import mysql.connector
from mysql.connector import errorcode
from dotenv import dotenv_values

# Load secrets from .env file
secrets = dotenv_values(".env")

# Database config
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True
}

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    # Query 1: All fields from studio
    print("------ DISPLAYING Studio RECORDS ------")
    cursor.execute("SELECT * FROM studio")
    for (studio_id, studio_name) in cursor.fetchall():
        print(f"Studio ID: {studio_id}\nStudio Name: {studio_name}\n")

    # Query 2: All fields from genre
    print("------ DISPLAYING Genre RECORDS ------")
    cursor.execute("SELECT * FROM genre")
    for (genre_id, genre_name) in cursor.fetchall():
        print(f"Genre ID: {genre_id}\nGenre Name: {genre_name}\n")

    # Query 3: Movies with runtime under 2 hours (< 120 mins)
    print("------ DISPLAYING Short Film RECORDS  ------")
    cursor.execute("SELECT film_name, film_runtime FROM film WHERE film_runtime < 120")
    for (film_name, film_runtime) in cursor.fetchall():
        print(f"Film Name: {film_name}\nRuntime: {film_runtime} minutes\n")

    # Query 4: Displaying Director records in order
    print("------ DISPLAYING Director RECORDS ------")
    cursor.execute("SELECT film_director, film_name FROM film ORDER BY film_director")
    for (film_director, film_name) in cursor.fetchall():
        print(f"Director: {film_director}\nFilm Name: {film_name}\n")

    input("\n\nPress any key to continue...")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Invalid username or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)

finally:
    if 'db' in locals() and db.is_connected():
        db.close()