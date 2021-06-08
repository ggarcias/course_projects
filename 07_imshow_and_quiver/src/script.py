import numpy as np
import matplotlib.pyplot as plt
import netCDF4 as nc
import math

# =============================================================================
# =============================================================================
# =============================================================================

# PROJECT 7

# input : cmems_ibi_example.nc NETCDF file
# (downloaded by main script)

# output : plots (imshow+quiver)

# =============================================================================

# load the file
# for loop:
# for each value of time:
    # imshow(sqrt(u(time=i,depth,long=:,lat=:)^2+v(same;same;same;same)^2))
    # superpose quiver

# =============================================================================
# =============================================================================
# =============================================================================



# loading the file
file_path = "./data/input/cmems_ibi_example.nc"
data = nc.Dataset(file_path, "r")

time_values = data["time"]

# for each time value (lines), for each variable : uo, vo, sqrt(uo^2+vo^2)
# fig, axs = plt.subplots(len(time_values),3)

# for each time value (3 of them)
for i in range(len(time_values)):

    j = 0
    # plot plain uo and vo
    for var in ["uo","vo"]:

        # imshow
        # axs[i,j].imshow(data.variables[var][i,0,:,:])
        # axs[i,j].set_title(f"t={i};var={var}")

        # quiver
        # plt.quiver(data.variables[var][i,0,:,:])
        # plt.quiver()
        # plot_path = f"./data/output/quiver_cmems_ibi_example_{var}_time_{i}.png"
        # plt.savefig(plot_path)

        j += 1

    # plot sqrt(uo^2+vo^2)
    # axs[i,j].imshow(np.sqrt((data.variables["uo"][i,0,:,:])**2+(data.variables["vo"][i,0,:,:])**2))
    # axs[i,j].set_title(f"t={i};var=sqrt(uo^2+vo^2)")
    # axs[i,j].quiver(data.variables["uo"][i,0,:,:], data.variables["vo"][i,0,:,:])

    plt.imshow(np.sqrt((data.variables["uo"][i,0,:,:])**2+(data.variables["vo"][i,0,:,:])**2))
    plt.clim([0, 0.5]) # colour limit
    plt.colorbar() # colour bar 

    plt.quiver(data.variables["uo"][i,0,:,:], data.variables["vo"][i,0,:,:])
    
    plt.title("que tal amaia?")
    plt.xlabel("Longitude (º) E", fontsize=12)
    plt.ylabel("Latitude (º) N", fontsize=12)

    
    plt.savefig(f"./data/output/plot_time_{i}.png", dpi=600)

# plt.savefig("./data/output/plot.png", dpi=3000)
