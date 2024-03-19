# GUI Project Using SQL

import sqlite3
import random
from tkinter import *
from tkinter import messagebox, simpledialog

# Function to create database table
def create_database():
    conn = sqlite3.connect('hospital_database.db')
    cursor = conn.cursor()

    sql_Fields = '''CREATE TABLE IF NOT EXISTS Patients (
                     patient_number INTEGER,
                     name TEXT,
                     address TEXT,
                     gender TEXT,
                     dob TEXT,
                     patient_phone_number INTEGER,
                     next_of_kin TEXT,
                     next_of_kin_phone INTEGER,
                     allergies TEXT
                 )'''
    
    cursor.execute(sql_Fields)
    conn.close()

# Insert data into database
def insert_database(name, address, gender, dob, patient_phone_number, next_of_kin, next_of_kin_phone, allergies, patient_number):
    conn = sqlite3.connect('hospital_database.db')
    cursor = conn.cursor()

    sql_Insert = '''INSERT INTO Patients (name, address, gender, dob, patient_phone_number, next_of_kin, next_of_kin_phone, allergies, patient_number)
                      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'''
    
    cursor.execute(sql_Insert,
                   (name, address, gender, dob, patient_phone_number, next_of_kin, next_of_kin_phone, allergies, patient_number))
    
    conn.commit()
    conn.close()

# Generate a unique patient number
def generate_patient_number():
    conn = sqlite3.connect('hospital_database.db')
    cursor = conn.cursor()

    while True:
        patient_number = random.randint(1000, 9999)
        cursor.execute("SELECT * FROM Patients WHERE patient_number=?", (patient_number,))
        existing_patient = cursor.fetchone()
        if not existing_patient:
            conn.close()
            return patient_number
        

def submit_data():
    # Getting Info
    name = name_entry.get()
    address = address_entry.get()
    gender = gender_var.get()
    dob = dob_entry.get()
    patient_phone_number = patient_number_entry.get()
    next_of_kin = next_of_kin_entry.get()
    next_of_kin_phone = next_of_kin_phone_entry.get()
    allergies = allergies_entry.get("1.0", "end-1c")

    # Error Handling
    if not name or not name.isalpha():
        messagebox.showerror("Error", "Please enter a valid name.")
        return

    if not address:
        messagebox.showerror("Error", "Please enter an address.")
        return

    if not gender:
        messagebox.showerror("Error", "Please select a gender.")
        return

    if not dob:
        messagebox.showerror("Error", "Please enter a date of birth.")
        return

    if not patient_phone_number or not patient_phone_number.isdigit():
        messagebox.showerror("Error", "Please enter a valid patient's phone number.")
        return

    if not next_of_kin:
        messagebox.showerror("Error", "Please enter the name of the next of kin.")
        return

    if not next_of_kin_phone or not next_of_kin_phone.isdigit():
        messagebox.showerror("Error", "Please enter a valid phone number for the next of kin.")
        return

    patient_number = generate_patient_number()

    # Insert data into database
    insert_database(name, address, gender, dob, patient_phone_number, next_of_kin, next_of_kin_phone, allergies, patient_number)
    messagebox.showinfo(title="Submission Successful", message=f"Thank you {name}! Your patient number is {patient_number}.")

    clear_data()


def clear_data():
    name_entry.delete(0, END)
    address_entry.delete(0, END)
    gender_var.set("") 
    dob_entry.delete(0, END)
    patient_number_entry.delete(0, END)
    next_of_kin_entry.delete(0, END)
    next_of_kin_phone_entry.delete(0, END)
    allergies_entry.delete("1.0", END)


def lookup_info():
    patient_number = simpledialog.askinteger("Lookup Info", "Enter the patient number:")

    if patient_number is not None:
        conn = sqlite3.connect('hospital_database.db')
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Patients WHERE patient_number = ?", (patient_number,))
        patient_data = cursor.fetchone()
        conn.close()

        if patient_data:
            info_message = (
                f"Name: {patient_data[1]}\n"
                f"Address: {patient_data[2]}\n"
                f"Gender: {patient_data[3]}\n"
                f"DOB: {patient_data[4]}\n"
                f"Patient's Phone Number: {patient_data[5]}\n"
                f"Next of Kin: {patient_data[6]}\n"
                f"Next of Kin's Phone Number: {patient_data[7]}\n"
                f"Allergies: {patient_data[8]}"
            )
            messagebox.showinfo("Patient Information", info_message)
        else:
            messagebox.showwarning("Patient Information", "Patient not found.")

# Create the database table if it doesn't exist
create_database()


# Main GUI Code            
window = Tk()
window.title("Hospital Database")

frame = Frame(window)
frame.pack()

# Patient Info
patient_info_frame = LabelFrame(frame, text="Patient Information")
patient_info_frame.grid(row=0, column=0, padx=20, pady=10, sticky="nsew")

name_label = Label(patient_info_frame, text="Full Name:")
name_label.grid(row=0, column=0, padx=10, pady=5, sticky=W)
name_entry = Entry(patient_info_frame)
name_entry.grid(row=0, column=1, padx=10, pady=5, sticky=W)

address_label = Label(patient_info_frame, text="Address:")
address_label.grid(row=1, column=0, padx=10, pady=5, sticky=W)
address_entry = Entry(patient_info_frame)
address_entry.grid(row=1, column=1, padx=10, pady=5, sticky=W)

gender_label = Label(patient_info_frame, text="Gender:")
gender_label.grid(row=2, column=0, padx=10, pady=5, sticky=W)

gender_var = StringVar(window)

rb_male = Radiobutton(patient_info_frame, text="Male", variable=gender_var, value="Male")
rb_male.grid(row=3, column=0, padx=10, pady=5, sticky=W)

rb_female = Radiobutton(patient_info_frame, text="Female", variable=gender_var, value="Female")
rb_female.grid(row=4, column=0, padx=10, pady=5, sticky=W)

rb_other = Radiobutton(patient_info_frame, text="Other", variable=gender_var, value="Other")
rb_other.grid(row=5, column=0, padx=10, pady=5, sticky=W)

dob_label = Label(patient_info_frame, text="DOB:")
dob_label.grid(row=6, column=0, padx=10, pady=5, sticky=W)
dob_entry = Entry(patient_info_frame)
dob_entry.grid(row=6, column=1, padx=10, pady=5, sticky=W)

patient_number_label = Label(patient_info_frame, text="Patient's Phone Number:")
patient_number_label.grid(row=7, column=0, padx=10, pady=5, sticky=W)
patient_number_entry = Entry(patient_info_frame)
patient_number_entry.grid(row=7, column=1, padx=10, pady=5, sticky=W)

next_of_kin_label = Label(patient_info_frame, text="Next of Kin:")
next_of_kin_label.grid(row=8, column=0, padx=10, pady=5, sticky=W)
next_of_kin_entry = Entry(patient_info_frame)
next_of_kin_entry.grid(row=8, column=1, padx=10, pady=5, sticky=W)

next_of_kin_phone_label = Label(patient_info_frame, text="Next of Kin's Phone Number:")
next_of_kin_phone_label.grid(row=9, column=0, padx=10, pady=5, sticky=W)
next_of_kin_phone_entry = Entry(patient_info_frame)
next_of_kin_phone_entry.grid(row=9, column=1, padx=10, pady=5, sticky=W)

allergies_label = Label(patient_info_frame, text="Allergies:")
allergies_label.grid(row=10, column=0, padx=10, pady=5, sticky=W)
allergies_entry = Text(patient_info_frame, height=4, width=30)
allergies_entry.grid(row=10, column=1, padx=10, pady=5, sticky=W) 

# Button
button = Button(frame, text="Submit", command=submit_data)
button.grid(row=1, column=0, sticky="ew", padx=20, pady=10)

clear_button = Button(frame, text="Clear Fields", command=clear_data)
clear_button.grid(row=1, column=1, sticky="ew", padx=20, pady=10)

# Menubar 
menuBar = Menu(window)
firstMenu = Menu(menuBar, tearoff=0)
firstMenu.add_command(label="Lookup Info", command=lookup_info)
firstMenu.add_command(label="Quit", command=window.destroy)
menuBar.add_cascade(label="Options", menu=firstMenu)

window.config(menu=menuBar)

# Loop to make sure program doesn't close. 
window.mainloop()