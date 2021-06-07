import numpy as np
import matplotlib.pyplot as plt

data = []

# for each file (we already know there are 12 of them but this could be automated)
for i in range(12):

    print("loading /inflammation-%02d.csv..." %(i+1))
    # load data
    file_path = "./data/input/inflammation-%02d.csv" %(i+1)
    data.append(np.loadtxt(fname=file_path, delimiter=","))
    print("loaded.")

    print("plotting /inflammation-%02d.csv..." %(i+1))
    # plot global file data
    image = plt.imshow(data[i])
    plt.show()
    print("plotted.")

    print("saving plot...")
    # save global file plot
    plot_path = "./data/output/inflammation-%02d.png" %(i+1)
    plt.savefig(plot_path)
    print("saved.")
    
    # plot & save the plot for each patient

    # for each line (=patient):
    patients = data[i].shape[0]
    # data is a list, containing numpy arrays

    print(f"saving plots for {patients} patients...")
    for j in range(patients):
        image = plt.plot(data[i][j])
        plt.show()
        plot_path = "./data/output/inflammation-%02d-" %(i+1)
        plot_path = plot_path+"patient-%04d.png" %(j+1)
        plt.savefig(plot_path)
    print(f"{patients} plots saved.")
