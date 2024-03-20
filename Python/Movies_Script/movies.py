import sqlite3
from time import sleep

# Create the database
def create_database():
    newDB = sqlite3.connect("database.db")
    cursor = newDB.cursor()

    sql_query = '''CREATE TABLE IF NOT EXISTS Movies
    (movie_name TEXT,
    date TEXT,
    genre TEXT,
    rating TEXT)'''
   
    cursor.execute(sql_query)

    newDB.commit()
    newDB.close()



# Validation
def data_validation(result):
    valid_options = ['1', '2', '3', '4', '5']
    return result in valid_options



# Options
print("Option 1: View whole database")
print("Option 2: Insert a new record")
print("Option 3: Search for a record")
print("Option 4: Delete a film record")
print("Option 5: Update a current film record \n")



entry_invalid = True

while entry_invalid:
    result = input("Enter an option (1, 2, 3, 4 or 5): \n")

    if data_validation(result):
        print("Valid option, Thank you! Please wait for result.\n")
        sleep(0.3)
        
        if result == '1':
            database = sqlite3.connect("database.db")
            cursor = database.cursor()

            sql_lookup = '''SELECT * FROM Movies'''
            
            cursor.execute(sql_lookup)
            values = cursor.fetchall()

            if values:
                for movie in values:
                    print("Movie Details: ")
                    print(f"Movie Name: {movie[0]}")
                    print(f"Date: {movie[1]}")
                    print(f"Genre: {movie[2]}")
                    print(f"Rating: {movie[3]}")
                    print("")
            else:
                print("No movies found in the database.")

            database.close()
            entry_invalid = False


        elif result == '2':
            database = sqlite3.connect("database.db")
            cursor = database.cursor()

            name = input("Enter the name of the movie: ").lower()
            date = input("Enter the date the movie was made: ").lower()
            genre = input("Enter the genre of the movie: ").lower()
            rating = input("Enter the movie's rating: ").lower()

            sql_insert = '''INSERT INTO Movies (movie_name, date, genre, rating) VALUES (?, ?, ?, ?)'''

            cursor.execute(sql_insert, (name, date, genre, rating))

            database.commit()
            database.close()

            print("Record inserted successfully!")
            entry_invalid = False


        elif result == '3':
            while True:
                database = sqlite3.connect("database.db")
                cursor = database.cursor()
        
                movie_name = input("Enter the movie name: ").lower()
        
                sql_select = '''SELECT * FROM Movies WHERE movie_name = ?'''
                
                cursor.execute(sql_select, (movie_name,))
                movie = cursor.fetchone()
        
                if movie is None:
                    print(f"Error: Movie '{movie_name}' not found in the database.")
                    database.close()
                    continue
                
                print("Movie details:")
                print(f"Movie Name: {movie[0]}")
                print(f"Date: {movie[1]}")
                print(f"Genre: {movie[2]}")
                print(f"Rating: {movie[3]}")
                print("")
        
                database.close()
                break
            
            entry_invalid = False


        elif result == '4':
            while True:
                database = sqlite3.connect("database.db")
                cursor = database.cursor()

                movie_name = input("Enter the name of the movie to delete: ").lower()

                sql_select = '''SELECT * FROM Movies WHERE movie_name = ?'''
                
                cursor.execute(sql_select, (movie_name,))
                movie = cursor.fetchone()

                if movie is None:
                    print(f"Error: Movie '{movie_name}' not found in the database.")
                    database.close()
                    continue
                
                sql_delete = '''DELETE FROM Movies WHERE movie_name = ?'''
                
                cursor.execute(sql_delete, (movie_name,))
                database.commit()

                print(f"Record for '{movie_name}' deleted successfully!")

                database.close()
                break
            
            entry_invalid = False


        elif result == '5':
            while True:
                database = sqlite3.connect("database.db")
                cursor = database.cursor()

                movie_name = input("Enter the name of the movie to update: ").lower()

                sql_select = '''SELECT * FROM Movies WHERE movie_name = ?'''
                
                cursor.execute(sql_select, (movie_name,))
                movie = cursor.fetchone()

                if movie is None:
                    print(f"Error: Movie '{movie_name}' not found in the database.")
                    database.close()
                    continue
                
                field_name = input("Enter the field to update (movie_name, date, genre, rating): ").lower()

                valid_names = ['movie_name', 'date', 'genre', 'rating']

                if field_name not in valid_names:
                    print("Error: Invalid field name. Please check your input.")
                    database.close()
                    continue
                
                new_value = input(f"Enter the new value for {field_name}: ").lower()
                sql_update = f'''UPDATE Movies SET {field_name} = ? WHERE movie_name = ?'''
                cursor.execute(sql_update, (new_value, movie_name))
                database.commit()

                print(f"Record for '{movie_name}' updated successfully!")

                database.close()
                break
            
            entry_invalid = False

    else:
        print("Invalid Input, enter option 1, 2, 3, 4 or 5 /n")