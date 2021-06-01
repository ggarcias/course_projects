program create_LonLatTimeUV

    ! https://www.nag.com/market/training/fortran-workshop/netcdf-f90.pdf

    use netcdf
    implicit none

    ! file IDs
    integer :: ncid,new_file

    ! dimensions IDs (original file;output file)
    ! time,latitude,longitude,(depth)
    integer :: idt,idla,idlo,idd,idtt,idlaa,idloo
    ! variables IDs
    integer :: iduo,idvo,idu,idv
    ! dimensions
    integer :: time,long,lat,depth

    ! origiinal file path ; dimension name
    character(len=25) :: input_data, name

    ! scale_factor (uo & vo)
    real(4) :: scl_fact

    ! uo & vo, u & v varuables (vectors)
    integer(2), dimension(:,:,:,:), allocatable :: uo, vo
    ! one key dimension less because we don't keep depth:
    real(4), dimension(:,:,:), allocatable :: u, v

    ! loops iterations
    integer :: longs,lats,depths,times

    ! we want to create NETCDF dataset LonLatTimeUV.nc from
    ! cmems_ibi_example.nc

    ! we want to:
    ! 'copy' dimensions & variables:
    ! - longitude
    ! - latitude
    ! - time
    ! - vo as v
    ! - uo as u

    ! but 'dropping':
    ! - key 'depth' for u and v
    ! - attributes:
    ! -- _CoordinateAxisType (time,long,lat)
    ! -- unit_long (time,long,lat)
    ! -- step (u,v,long,lat)
    ! -- _ChunkSizes (time,long,lat,u,v)
    ! -- valid_min (long,lat,time)
    ! -- valid_max (time,long,lat)
    ! -- add_offset (u,v)
    ! -- scale_factor (u,v)
    ! -- _FillValue (u,v)

    ! to access dimensions' number of dimensions,
    ! we first need to extract the dimensions' IDs,
    ! then their number of dimensions
    ! this is automated thx to subroutine 'extract_dimension'

    ! we don't want to 'copy' dimension 'depth' into
    ! the new file but we still need to extract it
    ! to access uo and vo because 'depth' is part of
    ! their key

    ! let's open cmems_ibi_example.nc
    input_data = "cmems_ibi_example.nc"

    call check(nf90_open(input_data, nf90_nowrite, ncid),&
    "open cmems_ibi_example.nc")

    ! let's extract dimensions' dimensions:
    call extract_dimension(ncid,"time",time)
    call extract_dimension(ncid,"longitude",long)
    call extract_dimension(ncid,"latitude",lat)
    call extract_dimension(ncid,"depth",depth)

    ! we will store uo & vo values in order to
    ! 'transform' the values into reals/floats
    ! and then store the result in final vectors
    ! u & v who will be the variables values of
    ! the new file
    allocate(uo(long,lat,depth,time))
    allocate(vo(long,lat,depth,time))

    ! let's extract the scale_factor for uo & vo
    ! (here it is the same for both variables but it could be different)
    ! first let's extract the variable ID for uo & vo
    call check(nf90_inq_varid(ncid, "uo", iduo), "inquire variable ID for uo")
    call check(nf90_inq_varid(ncid, "vo", idvo), "inquire variable ID for vo")

    ! now let's get the value of attribute 'scale_factor'
    call check(nf90_get_att(ncid, iduo, "scale_factor", scl_fact),&
     "getting scale factor from uo var")

    ! let's extract the values of uo & vo  and store them
    ! into the allocated vectors
    call check(nf90_get_var(ncid, iduo, uo), "get variable uo's values")
    call check(nf90_get_var(ncid, iduo, vo), "get variable vo's values")

    ! let's create u & v vectors
    allocate(u(long,lat,time))
    allocate(v(long,lat,time))

    ! let's store uo & vo values into u & v, but 'scaled'
    ! we can't simply type:
    ! u=scl_fact*uo
    ! v=scl_fact*vo
    ! becayse now u & v are NOT the same 'shape' as uo & vo
    ! because we 'dropped' dimension 'depth'
    ! let's do it 'manually' with a loop

    do longs=1,long
        do lats=1,lat
            do times=1,time
                ! this loop is quite useless because there's only 1 depth
                ! (that's why we could drop it)
                do depths=1,depth
                    v(longs,lats,times)=vo(longs,lats,depths,times)
                    u(longs,lats,times)=uo(longs,lats,depths,times)
                end do
            end do
        end do
    end do

    ! let's create (or overwrite) previously created file
    ! 'LonLatTimeUV.nc'
    call check(nf90_create("LonLatTimeUV.nc", NF90_CLOBBER, new_file), &
     "create LonLatTimeUV.nc")

    ! next we will:
    ! create the dimensions:
    ! - longitude (float = real(4))
    ! - latitude (float = real(4))
    ! - time (double = real(8))
    ! variables u & v (float = real(4))
    ! (because scl_fact is a float too)

    ! copy the attributes we want (see new_dataset_structure.txt)
    ! from cmems_ibi_example.nc (ncid) to LonLatTimeUV.nc (new_file)

    ! and finally set the global attributes of LonLatTimeUV.nc
    ! (most of them will be imported/'copied' from cmems_ibi_example.nc

    ! UNFINISHED

    ! now that we extracted what we needed,
    ! let's close cmems_ibi_example.nc
    call check(nf90_close(ncid), "close cmems_ibi_example.nc")

    ! let's close LonLatTimeUV.nc
    call check(nf90_close(new_file), "close LonLatTimeUV.nc")

    contains

        subroutine check(status, operation)

            use netcdf
            implicit none

            integer, intent(in) :: status
            character(len=*), intent(in) :: operation

            if (status == nf90_noerr) then
                return
            else
                print *, "Error encountered during ", operation
                print *, nf90_strerror(status)
                stop
            end if

        end subroutine check



        subroutine extract_dimension(file_id,name_dimension,dimout)

            use netcdf
            implicit none

            integer, intent(in) :: file_id
            integer :: dimid, dimval
            integer, intent(out) :: dimout
            character(len=*), intent(in) :: name_dimension

            ! extract dimension id
            call check(nf90_inq_dimid(file_id, name_dimension, dimid),&
            "inquire dimension id")

            ! extract dimension
            call check(nf90_inquire_dimension(file_id, dimid, name, dimval),&
            "inquire dimension value")

            dimout=dimval

        end subroutine extract_dimension

end program create_LonLatTimeUV
