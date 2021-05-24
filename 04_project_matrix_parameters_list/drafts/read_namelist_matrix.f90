! create an allocatable matrix where n dimension is read USING A
! NAMELIST (containing n=size, target=name_of_save_file)
! save the matrix in a file

! 1) create fortran file to create a matrix
! 2) bash code to change the template/replace parameters
! 3) run it

! create the namelist containing n=size_of_future_matrix,
! target=name_of_save_file
! create an allocatable matrix where n dimension is read USING A NAMELIST
! save the matrix in a file
! send between 5 & 10 simulations to the nodes




program read_namelist_matrix

implicit none

integer(8) :: n, file_id
character(100) :: target_file

namelist /parameters_matrix_size_and_target_file/ n, target_file

file_id=777

open(unit=file_id, file="parameters_matrix_size_and_target_file.list", action="READ")
read(file_id, NML=parameters_matrix_size_and_target_file)
close(file_id)

print *, n, target_file

    contains

        character(100) function save_matrix(A, target_file)

        implicit none

        real(8), allocatable, dimension(:,:), intent(in) :: A
        character(*), intent(in) :: target_file
        character (100) :: ok
        integer(8) :: i, file_id

        file_id = 777

        open(file_id, file=target_file)

        do i=1,size(A,1)

            write(file_id, *) A(:,i)

        end do

        close(file_id)

        save_matrix="matrix saved :)"

        end function save_matrix

end program read_namelist_matrix
