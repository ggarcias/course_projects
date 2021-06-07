mkdir data;
mkdir data/input;
mkdir data/output;

# let's import the data from guillermo's directory
# cp /LUSTRE/users/ggarcia/gfd_course/cmems_ibi_example.nc ./data/input
rsync -va amarcano@lovelace.icmat.es:/LUSTRE/users//ggarcia/gfd_course/cmems_ibi_example.nc ./data/input

# let's run the python script
env/bin/python ./src/script.py
