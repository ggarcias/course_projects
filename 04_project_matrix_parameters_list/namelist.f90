program namelist

    implicit none

    real(8) :: x, y

    ! means the name of a list where you can save the variables
    namelist /my_parameters/ x,y

    ! open the file (ID_of_file, ..., only action allowed is read)
    open(unit=100, file="my_parameters.list", action="READ")
    ! speacial instruction for reading namelists
    read(100, NML=my_parameters)
    close(100)

    print *, x, y

end program namelist
