import mysql.connector
from mysql.connector import errorcode
from dotenv import dotenv_values

# Load credentials from .env
secrets = dotenv_values(".env")

# DB config
config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True
}

# Function to display film info with joins
def show_films(cursor, title):
    # Inner join query across film, genre, and studio
    cursor.execute("""
        SELECT film_name as Name, film_director as Director, genre_name as Genre, studio_name as 'Studio Name'
        FROM film
        INNER JOIN genre ON film.genre_id = genre.genre_id
        INNER JOIN studio ON film.studio_id = studio.studio_id
    """)

    films = cursor.fetchall()
    print("\n  -- {} --".format(title))
    for film in films:
        print("Film Name: {}\nDirector: {}\nGenre Name ID: {}\nStudio Name: {}\n".format(
            film[0], film[1], film[2], film[3]
        ))

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    # DISPLAYING FILMS (initial)
    show_films(cursor, "DISPLAYING FILMS")

   # INSERT a new film 
    cursor.execute("""
        INSERT INTO film (film_name, film_director, genre_id, studio_id, film_runtime, film_releaseDate)
        VALUES ('Oppenheimer', 'Christopher Nolan', 3, 1, 180, '2023-07-21')
    """)

    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER INSERT")


    # UPDATE Alien's genre to Horror (genre_id = 1)
    cursor.execute("UPDATE film SET genre_id = 1 WHERE film_name = 'Alien'")
    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER UPDATE- Changed Alien to Horror")

    # DELETE Gladiator
    cursor.execute("DELETE FROM film WHERE film_name = 'Gladiator'")
    db.commit()
    show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

    input("\n\nPress any key to continue...")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Invalid username or password")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)

finally:
    if db.is_connected():
        db.close()