! 1) create fortran file to create a matrix
! 2) bash code to change the template/replace parameters
! 3) run it

! create the namelist containing n=size_of_future_matrix, target=name_of_save_file
! create an allocatable matrix where n dimension is read USING A NAMELIST
! save the matrix in a file
! send between 5 & 10 simulations to the nodes
