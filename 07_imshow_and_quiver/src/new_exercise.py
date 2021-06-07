#  1) save in a list all the csv files
#  2) subplots of different patients inside each csv

import numpy as np
import matplotlib.pyplot as plt
import glob

# print("list of inflammation files :",glob.glob('../visualizations/data/input/inflammation*.csv'))

# print("==============================================")

# sort the list

unsorted_list = glob.glob('../visualizations/data/input/inflammation*.csv')

sorted_list = sorted(unsorted_list)

# print("sorted list:", sorted_list)

# ===================================================

# take the 3 first files
# do 3 subplots with 3 plots of the first 3 patients

number_of_files = 3
number_of_patients = 3

files_to_plot = sorted_list[:number_of_files]

fig, axs = plt.subplots(number_of_files,number_of_patients)

for files in files_to_plot:
    print(f"file : {files}")
    i = files_to_plot.index(files)

    # load the file
    data = np.loadtxt(fname=files, delimiter=",")

    patients_to_plot = data[:3,:]
    #print(f"")

    j = 0
    for patient in patients_to_plot:

        print(f"patient n°{j+1} : {patient}")

        axs[i,j].plot(patient)
        title="inflammation-%02d.csv : patient n°" %(i+1)
        title=title+str(j+1)
        axs[i,j].set_title(title)

        j += 1

plt.savefig("./plot.png")
print("end of script.")
