! create an allocatable matrix where n dimension is read USING A
! NAMELIST (containing n=size, target=name_of_save_file)
! save the matrix in a file


program read_namelist_matrix

implicit none

integer(8) :: n
character(100) :: target_file

namelist /parameters_matrix_size_and_target_file/ n, target_file

open(unit=777, file="parameters_matrix_size_and_target_file.list", action="READ")
read(777, NML=parameters_matrix_size_and_target_file)
close(777)

print *, n, target_file

end program read_namelist_matrix
