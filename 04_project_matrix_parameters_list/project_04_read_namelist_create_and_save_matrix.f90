! this code, which is called by the bash code and sent to a node,  must:
! 1) read a namelist containing:
! --- n = size_of_future_matrix ;
! --- target_file = name_of_save_file
! 2) create an allocatable matrix with the upper n parameter as size
! 3) save the matrix in the target_file entered as a parameter


program read_a_namelist_create_a_matrix_and_save_that_matrix

    implicit none

    integer(8) :: n, file_id_namelist
    character(*) :: target_file
    integer(8), allocatable, dimension(:,:) :: matrix

    namelist /parameters_matrix_size_and_target_file/ n, target_file

    file_id_namelist=777

    open(unit=file_id_namelist, file="parameters_matrix_size_and_target_file.list", action="READ")
    read(file_id_namelist, NML=parameters_matrix_size_and_target_file)
    close(file_id_namelist)

    print *, n, target_file

    call create_matrix(n, matrix)

    call save_matrix(matrix, target_file)

contains

        subroutine create_matrix(n,matrix)

            implicit none

            integer(8) :: i, j
            integer(8), intent(in) :: n
            integer(8), allocatable, dimension(:,:), intent(out) :: matrix

            allocate(matrix(1:n, 1:n))
            
            do i=1,n
                do j=1,n
                    matrix(i,j)=i
                end do
            end do

            do i=1,n
                print *, matrix(:,i)
            end do

        end subroutine create_matrix


        subroutine save_matrix(matrix, target_file)

            implicit none

            integer(8), allocatable, dimension(:,:), intent(in) :: matrix
            character(*), intent(in) :: target_file
            integer(8) :: i, file_id_matrix

            file_id_matrix = 555

            open(file_id_matrix, file=target_file)

            do i=1,size(matrix,1)

                write(file_id_matrix, *) matrix(:,i)

            end do

            close(file_id_matrix)

        end subroutine save_matrix

end program read_a_namelist_create_a_matrix_and_save_that_matrix
