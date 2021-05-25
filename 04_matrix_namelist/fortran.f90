! this code, which is called by the bash code and sent to a node,  must:
! 1) read a namelist containing:
! --- n = size_of_future_matrix ;
! --- target_file = name_of_file_where_the_matrix_is_saved
! 2) create an allocatable matrix with the upper n parameter as
! size
! 3) save the matrix in the target_file entered as a parameter
! which name is matrix00n.txt


program program_matrix

    implicit none

    integer(8) :: n, file_id_namelist
    character(100) :: target_file
    integer(8), allocatable, dimension(:,:) :: matrix

    namelist /parameters_matrix/ n, target_file

    file_id_namelist=777

    open(unit=file_id_namelist,file="parameters_matrix.list", action="READ")
    read(file_id_namelist, NML=parameters_matrix)
    close(file_id_namelist)

    print *, "n: ", n, "; target file: ", target_file

    allocate(matrix(1:n,1:n))

    call create_matrix(n, matrix)

    call save_matrix(matrix, target_file)

contains
    
    subroutine create_matrix(n,matrix)

        implicit none

        integer(8) :: i, j
        integer(8), intent(in) :: n
        integer(8), dimension(:,:), intent(out) :: matrix

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

        integer(8), dimension(:,:), intent(in) :: matrix
        character(100), intent(in) :: target_file
        integer(8) :: i, file_id_matrix
        
        file_id_matrix = 555

        open(file_id_matrix, file=target_file)

        do i=1,size(matrix,1)
            write(file_id_matrix, *) matrix(:,i)
        end do

        close(file_id_matrix)

    end subroutine save_matrix

end program program_matrix
