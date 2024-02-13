from tkinter import *

# function for button click
def button_click(topic):
    output_data.delete(0.0, END)
    if topic == "cpu":
        output_data.insert(END, "A Central Processing Unit (CPU) is the brain of the computer. It carries out the instructions of a computer program by performing basic arithmetic, logical, control and input/output operations specified by the instructions.")
    elif topic == "ram":
        output_data.insert(END, "Random Access Memory (RAM) is a type of computer data storage that provides fast access to the computer's memory. RAM is used to store data that must be quickly accessed by the computer, such as the operating system and applications.")
    elif topic == "hard_drive":
        output_data.insert(END, "A hard drive is a type of secondary storage device that uses a hard disk to store and retrieve digital information. The hard disk is a circular, flat, and rigid platter coated with magnetic material.")
    elif topic == "motherboard":
        output_data.insert(END, "The motherboard is the main component of a computer. It is a printed circuit board that acts as the 'glue' for all hardware components in a computer. It is designed to hold and connect other hardware components inside the computer.")

# start program
window = Tk()
window.title("Computer Hardware Flash Cards")

# Buttons
Button(window, text="CPU", width=10, command=lambda: button_click("cpu")).grid(row=0, column=0, padx=10, pady=10)
Button(window, text="RAM", width=10, command=lambda: button_click("ram")).grid(row=0, column=1, padx=10, pady=10)
Button(window, text="Hard Drive", width=10, command=lambda: button_click("hard_drive")).grid(row=0, column=2, padx=10, pady=10)
Button(window, text="Motherboard", width=10, command=lambda: button_click("motherboard")).grid(row=0, column=3, padx=10, pady=10)

# Text Area
output_data = Text(window, width=75, height=6, wrap=WORD, bg="light blue")
output_data.grid(row=1, column=0, columnspan=4, padx=10, pady=10)

# Loop for program to keep running
window.mainloop()