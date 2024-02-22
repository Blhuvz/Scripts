# First GUI Project. 

from tkinter import *
from tkinter import messagebox
import random

def submit_data():
    accepted = accept_var.get()

    if accepted == "Accepted":
        # Generate a patient number
        patient_number = random.randint(1000, 9999)

        # Get patient info
        name = name_entry.get()
        address = address_entry.get()
        gender = gender_var.get()
        dob = dob_entry.get()
        patient_phone_number = patient_number_entry.get()
        next_of_kin = next_of_kin_entry.get()
        next_of_kin_phone = next_of_kin_phone_entry.get()
        allergies = allergies_entry.get("1.0", "end-1c")

        if name and address and gender and dob and patient_phone_number and next_of_kin and next_of_kin_phone:
            messagebox.showinfo(title="Submission Successful", message=f"Thank you {name}! Your patient number is {patient_number}.")

            print("------------------------------------------")
            print("Name:", name)
            print("Address:", address)
            print("Gender:", gender)
            print("DOB:", dob)
            print("Patient's Phone Number:", patient_phone_number)
            print("Next of Kin:", next_of_kin)
            print("Next of Kin's Phone Number:", next_of_kin_phone)
            print("Allergies:", allergies)
            print("------------------------------------------")
            print("Patient Number:", patient_number)
            print("------------------------------------------")
        else:
            messagebox.showwarning(title="Error", message="Please fill in all required fields.")
    else:
        messagebox.showwarning(title="Error", message="You have not accepted the terms")

window = Tk()

window.title("Hospital Admission Form")

frame = Frame(window)
frame.pack()

# Patient Info
patient_info_frame = LabelFrame(frame, text="Patient Information")
patient_info_frame.grid(row=0, column=0, padx=20, pady=10)

name_label = Label(patient_info_frame, text="Full Name")
name_label.grid(row=0, column=0)
name_entry = Entry(patient_info_frame)
name_entry.grid(row=0, column=1)

address_label = Label(patient_info_frame, text="Address")
address_label.grid(row=1, column=0)
address_entry = Entry(patient_info_frame)
address_entry.grid(row=1, column=1)

gender_label = Label(patient_info_frame, text="Gender")
gender_label.grid(row=2, column=0)
gender_var = StringVar(window)
gender_menu = OptionMenu(patient_info_frame, gender_var, "", "Male", "Female", "Other")
gender_menu.grid(row=2, column=1)

dob_label = Label(patient_info_frame, text="DOB")
dob_label.grid(row=3, column=0)
dob_entry = Entry(patient_info_frame)
dob_entry.grid(row=3, column=1)

patient_number_label = Label(patient_info_frame, text="Patient's Phone Number")
patient_number_label.grid(row=4, column=0)
patient_number_entry = Entry(patient_info_frame)
patient_number_entry.grid(row=4, column=1)

next_of_kin_label = Label(patient_info_frame, text="Next of Kin")
next_of_kin_label.grid(row=5, column=0)
next_of_kin_entry = Entry(patient_info_frame)
next_of_kin_entry.grid(row=5, column=1)

next_of_kin_phone_label = Label(patient_info_frame, text="Next of Kin's Phone Number")
next_of_kin_phone_label.grid(row=6, column=0)
next_of_kin_phone_entry = Entry(patient_info_frame)
next_of_kin_phone_entry.grid(row=6, column=1)

allergies_label = Label(patient_info_frame, text="Allergies")
allergies_label.grid(row=7, column=0)
allergies_entry = Text(patient_info_frame, height=4, width=30)
allergies_entry.grid(row=7, column=1) 

# Accept terms
terms_frame = LabelFrame(frame, text="Terms & Conditions")
terms_frame.grid(row=1, column=0, sticky="news", padx=20, pady=10)

accept_var = StringVar(value="Not Accepted")
terms_check = Checkbutton(terms_frame, text="I accept that this data is Valid.",
                                  variable=accept_var, onvalue="Accepted", offvalue="Not Accepted")
terms_check.grid(row=0, column=0)

# Button
button = Button(frame, text="Submit", command=submit_data)
button.grid(row=2, column=0, sticky="news", padx=20, pady=10)

# Loop to make sure program doesn't close. 
window.mainloop()
