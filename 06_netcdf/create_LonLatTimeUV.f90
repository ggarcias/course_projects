program create_LonLatTimeUV

    ! https://www.nag.com/market/training/fortran-workshop/netcdf-f90.pdf

    use netcdf
    implicit none

    ! file IDs
    integer :: ncid,new_file

    ! dimensions IDs (original file;output file)
    ! time,latitude,longitude,(depth)
    integer :: idt,idla,idlo,idd,idtt,idlaa,idloo
    ! dimensions' variables IDs
    integer :: idvt, idvla, idvlo, idvtt, idvlaa, idvloo
    ! variables IDs
    integer :: iduo,idvo,idu,idv
    ! dimensions
    integer :: time,long,lat,depth

    ! original file path ; dimension/variable name
    character(len=25) :: input_data, name

    ! scale_factor (float extracted from uo/vo)
    real(4) :: scl_fact

    ! uo & vo, u & v variables (vectors)
    ! shorts
    integer(2), dimension(:,:,:,:), allocatable :: uo, vo
    ! one key dimension less because we don't keep depth:
    ! floats
    real(4), dimension(:,:,:), allocatable :: u, v

    ! dimensions' variables
    ! floats
    real(4), dimension(:), allocatable :: longitude,latitude
    ! doubles
    real(8), dimension(:), allocatable :: timee

    ! loops iterations
    integer :: longs,lats,depths,times



    ! =========================================================================
    ! =========================================================================
    ! =========================================================================



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



    ! =========================================================================
    ! =========================================================================
    ! =========================================================================



    ! let's open cmems_ibi_example.nc

    input_data = "cmems_ibi_example.nc"
    call check(nf90_open(input_data, nf90_nowrite, ncid),&
    "open cmems_ibi_example.nc")



    ! let's extract dimensions' dimensions & ids:

    call extract_dimension(ncid,"time",idt,time)
    call extract_dimension(ncid,"longitude",idlo,long)
    call extract_dimension(ncid,"latitude",idla,lat)
    call extract_dimension(ncid,"depth",idd,depth)



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

    ! we can't simply type: "u/v=scl_fact*uo/vo"
    ! because now u & v are NOT the same 'shape' as uo & vo
    ! since we 'dropped' dimension 'depth'
    ! let's do it 'manually' with a loop

    do longs=1,long
        do lats=1,lat
            do times=1,time
                ! this loop is quite useless because there's only 1 depth
                ! (that's why we could drop it)
                do depths=1,depth
                    v(longs,lats,times)=scl_fact*vo(longs,lats,depths,times)
                    u(longs,lats,times)=scl_fact*uo(longs,lats,depths,times)
                end do
            end do
        end do
    end do



    ! =========================================================================
    ! =========================================================================
    ! =========================================================================



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
    ! (because scl_fact is a float)

    ! copy the attributes we want (see new_dataset_structure.txt)
    ! from cmems_ibi_example.nc (ncid) to LonLatTimeUV.nc (new_file)

    ! and finally set the global attributes of LonLatTimeUV.nc
    ! (most of them will be imported/'copied' from cmems_ibi_example.nc





    ! let's create the dimensions with command:
    ! nf90_def_dim(ncid, name, len, dimid)
    ! here parameter 'len' can be set as an integer or NF90 UNLIMITED
    ! but we know the final size: number of dimensions extracted before!

    call check(nf90_def_dim(new_file, "time", time, idtt),&
    "def dimension time in new dataset")
    call check(nf90_def_dim(new_file, "latitude", lat, idlaa),&
    "def dimension latitude in new dataset")
    call check(nf90_def_dim(new_file, "longitude", long, idloo),&
    "def dimension longitude in new dataset")



    ! let's create the variables of the dimensions using:
    ! nf90_def_var(ncid, name, xtype, dimids, varid)
    ! here dimids is not necessary because it's one-dimension variables

    call check(nf90_def_var(new_file, "time", NF90_DOUBLE, (/idtt/), idvtt), &
    "def var time")
    call check(nf90_def_var(new_file, "longitude", NF90_FLOAT, (/idloo/), &
    idvloo), "def var longitude")
    call check(nf90_def_var(new_file, "latitude", NF90_FLOAT, (/idlaa/), &
    idvlaa), "def var latitude")



    ! let's create the variables u & v

    call check(nf90_def_var(new_file, "u", NF90_FLOAT, &
    (/idloo, idlaa, idtt/), idu), "def var u")
    call check(nf90_def_var(new_file, "v", NF90_FLOAT, &
    (/idloo, idlaa, idtt/), idv), "def var v")






    ! let's 'import' dimensions' & variables' attributes with:
    ! nf90_copy_att(ncid_in, varid_in, name, ncid_out, varid_out)



    ! to 'copy' attributes of the dimension's variables, we need their var_id
    ! let's extract it

    call check(nf90_inq_varid(ncid, "longitude", idvlo), "inq. var. ID long")
    call check(nf90_inq_varid(ncid, "latitude", idvla), "inq. var. ID lat")
    call check(nf90_inq_varid(ncid, "time", idvt), "inq. var. ID time")



    ! importing attributes for the dimensions & variables


    ! standard_name : all variables
    call check(nf90_copy_att(ncid, idvt, &
    "standard_name", new_file, idvtt), "copy attribute standard_name")
    call check(nf90_copy_att(ncid, idvla, &
    "standard_name", new_file, idvlaa), "copy attribute standard_name")
    call check(nf90_copy_att(ncid, idvlo, &
    "standard_name", new_file, idvloo), "copy attribute standard_name")
    call check(nf90_copy_att(ncid, iduo, &
    "standard_name", new_file, idu), "copy attribute standard_name")
    call check(nf90_copy_att(ncid, idvo, &
    "standard_name", new_file, idv), "copy attribute standard_name")


    ! long_name : all variables
    call check(nf90_copy_att(ncid, idvt, &
    "long_name", new_file, idvtt), "copy attribute long_name")
    call check(nf90_copy_att(ncid, idvla, &
    "long_name", new_file, idvlaa), "copy attribute long_name")
    call check(nf90_copy_att(ncid, idvlo, &
    "long_name", new_file, idvloo), "copy attribute long_name")
    call check(nf90_copy_att(ncid, iduo, &
    "long_name", new_file, idu), "copy attribute long_name")
    call check(nf90_copy_att(ncid, idvo, &
    "long_name", new_file, idv), "copy attribute long_name")


    ! units : all variables
    call check(nf90_copy_att(ncid, idvt, &
    "units", new_file, idvtt), "copy attribute units")
    call check(nf90_copy_att(ncid, idvla, &
    "units", new_file, idvlaa), "copy attribute units")
    call check(nf90_copy_att(ncid, idvlo, &
    "units", new_file, idvloo), "copy attribute units")
    call check(nf90_copy_att(ncid, idvo, &
    "units", new_file, idv), "copy attribute units")
    call check(nf90_copy_att(ncid, iduo, &
    "units", new_file, idu), "copy attribute units")


    ! axis : only time, long, lat (dimensions)
    call check(nf90_copy_att(ncid, idvt, &
    "axis", new_file, idvtt), "copy attribute axis")
    call check(nf90_copy_att(ncid, idvlo, &
    "axis", new_file, idvloo), "copy attribute axis")
    call check(nf90_copy_att(ncid, idvla, &
    "axis", new_file, idvlaa), "copy attribute axis")


    ! unit_long : only u & v (proper variables)
    call check(nf90_copy_att(ncid, iduo, &
    "unit_long", new_file, idu), "copy attribute unit_long")
    call check(nf90_copy_att(ncid, idvo, &
    "unit_long", new_file, idv), "copy attribute unit_long")





    ! let's set the global attributes


    ! let's copy some of them:

    call check(nf90_copy_att(ncid, NF90_GLOBAL, &
    "Conventions", new_file, NF90_GLOBAL), "cp glb attribute Conventions")
    call check(nf90_copy_att(ncid, NF90_GLOBAL, &
    "source", new_file, NF90_GLOBAL), "cp glb attribute source")
    call check(nf90_copy_att(ncid, NF90_GLOBAL, &
    "title", new_file, NF90_GLOBAL), "cp glb attribute title")
    call check(nf90_copy_att(ncid, NF90_GLOBAL, &
    "domain_name", new_file, NF90_GLOBAL), "cp glb attribute domain_name")
    call check(nf90_copy_att(ncid, NF90_GLOBAL, &
    "references", new_file, NF90_GLOBAL), "cp glb attribute references")



    ! let's set these:
    ! (using: nf90_put_att(ncid, varid, name, values) )

    call check(nf90_put_att(new_file, NF90_GLOBAL, &
    "Acknowledgements", "Dr Ana Mancho & Guillermo Garcia from ICMAT"), &
    "creating new global attribute Acknowledgements")
    call check(nf90_put_att(new_file, NF90_GLOBAL, &
    "comment", ""), "creating new global attribute comment")
    call check(nf90_put_att(new_file, NF90_GLOBAL, &
    "history", "2021-06-03"), "creating new global attribute history")
    call check(nf90_put_att(new_file, NF90_GLOBAL, &
    "institution", "ICMAT internship"), &
    "creating new global attribute institution")
    call check(nf90_put_att(new_file, NF90_GLOBAL, &
    "Authors", "Amaia Marcano"), "creating new global attribute Authors")



    ! let's 'fill' the dimensions & variables using:
    ! nf90_put_var(ncid, varid, values, start, count, stride, map)



    ! let's extract the dimension's variables
    ! (nf90_get_var(ncid, varid, values, start, count, stride, map) )


    allocate(timee(time))
    allocate(longitude(long))
    allocate(latitude(lat))


    call check(nf90_get_var(ncid, idvt, timee), "get var time")
    call check(nf90_get_var(ncid, idvlo, longitude), "get var long")
    call check(nf90_get_var(ncid, idvla, latitude), "get var lat")



    ! let's close the "define" phase and open the "write" phase with:
    ! nf90_enddef(ncid, h_minfree, v_align, v_minfree, r_align)

    call check(nf90_enddef(new_file), "closing definition phase of new file")



    ! let's 'write' into the new dataset

    call check(nf90_put_var(new_file, idvtt, timee), &
    "writing time variables")
    call check(nf90_put_var(new_file, idvlaa, latitude), &
    "writing lat variables")
    call check(nf90_put_var(new_file, idvloo, longitude), &
    "writing long variables")
    call check(nf90_put_var(new_file, idu, u), &
    "writing u variables")
    call check(nf90_put_var(new_file, idv, v), &
    "writing v variables")



    ! let's close LonLatTimeUV.nc

    call check(nf90_close(new_file), "close LonLatTimeUV.nc")


    ! now that we extracted what we needed,
    ! let's close cmems_ibi_example.nc

    call check(nf90_close(ncid), "close cmems_ibi_example.nc")

    ! =========================================================================
    ! DONE ====================================================================
    ! =========================================================================


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



        subroutine extract_dimension(file_id,name_dimension,iddimout,dimout)

            use netcdf
            implicit none

            integer, intent(in) :: file_id
            integer :: dimid, dimval
            integer, intent(out) :: iddimout, dimout
            character(len=*), intent(in) :: name_dimension

            ! extract dimension id
            call check(nf90_inq_dimid(file_id, name_dimension, dimid),&
            "inquire dimension id")

            ! extract dimension
            call check(nf90_inquire_dimension(file_id, dimid, name, dimval),&
            "inquire dimension value")

            dimout=dimval
            iddimout=dimid

        end subroutine extract_dimension

end program create_LonLatTimeUV
