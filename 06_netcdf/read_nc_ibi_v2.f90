program read_nc_ibi

use netcdf
implicit none

! for loops:
integer :: i, longitudes, latitudes, depths, times

integer :: ncid, iddimlat, iddimlong, ncid_new
! dimension of the dimensions
integer :: lat, long, time, depth
! id of the variables of :
! dimensions
integer :: idvarlat, idvarlong, idvardepth, idvartime
! variables
integer :: idvaruo, idvarvo
! scale factors : float <=> real(4)
real(4) :: scl_fact

character(len=100) :: input_data
character(len=25) :: name

! variables: vectors
real(4), dimension(:), allocatable :: varlat, varlong, vardepth
real(8), dimension(:), allocatable :: vartime
integer(2), dimension(:,:,:,:), allocatable :: uo, vo
! real-type mirror arrays of uo and vo:
real(8), dimension(:,:,:,:), allocatable :: uo_real, vo_real

! float = real(4)
! double = real(8)
! short = integer(2)

! original file
input_data="cmems_ibi_example.nc"

! open netcdf
call check(nf90_open(input_data, nf90_nowrite, ncid), "open nc")

! read dimension ids
call check(nf90_inq_dimid(ncid, "latitude", iddimlat), &
"inquire lat dimension id")
!print *, "latitude dim id = ", iddimlat

call check(nf90_inq_dimid(ncid, "longitude", iddimlong), &
"inquire long dimension id")
!print *, "longitude dim id = ", iddimlong

! read dimensions
call check(nf90_inquire_dimension(ncid, iddimlat, name, lat),&
"inquire lat dimension")
!print *, "latitude dimension: ", lat

call check(nf90_inquire_dimension(ncid, iddimlong, name, long),&
"inquire long dimension")
!print *, "longitude dimension: ", long

! read variables ids
call check(nf90_inq_varid(ncid, "latitude", idvarlat), "inquire variables lat")
!print *, "id of variable latitude: ", idvarlat

call check(nf90_inq_varid(ncid, "longitude", idvarlong), "inquire variables long")
!print *, "id of variable longitude: ", idvarlong

! read variables

allocate(varlat(1:lat))
call check(nf90_get_var(ncid, idvarlat, varlat), "get var lat")

! print *, "printing latitude values:"
! do i=1,lat
!     print *, varlat(i)
! end do

allocate(varlong(1:long))
call check(nf90_get_var(ncid, idvarlong, varlong), "get var long")

! print *, "printing longitude values:"
! do i=1,long
!    print *, varlong(i)
! end do


! read uo and vo
! we want to extract uo and vo values
! we already extracted : longitude and latitude
! we need to extract : depth and time
! lets use a subroutine

call extract_dimension(ncid,"depth",depth)
call extract_dimension(ncid,"time",time)

call check(nf90_inq_varid(ncid, "depth", idvardepth), "inquire variables depth")
call check(nf90_inq_varid(ncid, "time", idvartime), "inquire variables time")

allocate(vardepth(depth))
allocate(vartime(time))
call check(nf90_get_var(ncid, idvardepth, vardepth), "get var depth")
call check(nf90_get_var(ncid, idvartime, vartime), "get var time")

!print *, "printing depth values:"
!do i=1,depth
!    print *, vardepth(i)
!end do
!print *, "printing time values:"
!do i=1,time
!    print *, vartime(i)
!end do

allocate(uo(long,lat,depth,time))
allocate(vo(long,lat,depth,time))

call check(nf90_inq_varid(ncid, "uo", idvaruo), "inquire variables uo")
call check(nf90_inq_varid(ncid, "vo", idvarvo), "inquire variables vo")
call check(nf90_get_var(ncid, idvaruo, uo), "get var uo")
call check(nf90_get_var(ncid, idvarvo, vo), "get var vo")

! getting vo and uo values
!do longitudes=1,long
!    do latitudes=1,lat
!        do depths=1,depth
!            do times=1,time
!                print *, longitudes, latitudes, depths, times
!                do i=1,2
!                    if (i==1) then
!                        print *, "uo: ", uo(longitudes, latitudes, depths, times)
!                    else
!                        print *, "vo: ", vo(longitudes, latitudes, depths, times)
!                    end if
!                end do
!            end do
!        end do
!    end do
!end do



! ==========================================================



! 27/05/2012 in-course assignment :
! extract from uo and vo the scale factor
! create new variable float uo_real & float vo_real
! float = real(4)
! values of new variables uo_real & vo_real are :
! scale factor of uo/vo * real(uo/vo)
! because uo/vo are short=integer(2)
! and scale factor is float = real(4)

allocate(uo_real(long,lat,depth,time))

! create real mirror array of uo & vo
! uo_real = real(uo)

! extract the scale factor:
! nf90_get_att(ncid, VAR_ID, NAME_OF_ATTRIBUTE, scl_fact)
! we have the variable ids :
! idvaruo & idvarvo
call check(nf90_get_att(ncid, idvaruo, "scale_factor", scl_fact),&
 "getting scale factor from uo var")

!print *, "extracted scale factor for uo: ", scl_fact
uo_real=scl_fact*real(uo)


allocate(vo_real(long,lat,depth,time))
! vo_real = real(vo)
call check(nf90_get_att(ncid, idvaruo, "scale_factor", scl_fact),&
"getting scale factor from uo var")
!print *, "extracted scale factor for vo: ", scl_fact
vo_real=scl_fact*real(vo)


!print *, "let's print the 10 first values of variable uo vs. uo_real"
!do i=1,10
!    print *, uo(i,i,1,1), "vs", uo_real(i,i,1,1)
!end do

!print *, "let's print the 10 first values of variable vo vs. vo_real"

!do i=1,10
!    print *, vo(i,i,1,1), "vs", vo_real(i,i,1,1)
!end do



! ==========================================================
! ==========================================================
! ==========================================================



! PROJECT N°6

! create a new netcdf_file with:

! dimensions :
! - lon : float / real(4)
! - lat : float / real(4)
! - time : double / real(8)

! variables :
! /!\ remove attributes : fill_value ; chunksize /!\
! - u(lon,lat,time) : double / real(8)
! - v(lon,lat,time) : double / real(8)

print *, "Let's create a new dataset: LonLatTimeUV.nc"
print *, "based on cmems_ibi_example.nc dataset"
print *, "containing dimensions: long(itude), lat(itude), time;"
print *, "variables: u, v"

! create new netcdf dataset / overwrites if file exists
call check(nf90_create("LonLatTimeUV.nc", NF90_CLOBBER, ncid_new), "create new netcdf")

! global attributes
! imported: Conventions; source; institution;
! modified: title

! dimensions : lon, lat, time
! LONGITUDE ; LATITUDE ; TIME :
! imported attributes from previous dataset :
! standard_name ; long_name ; units ; axis
! for TIME only : calendar

!call check(nf90_def_dim(), "def dim new netcdf")

! variables : u, v
! imported attributes from previous dataset :
! standard_name ; long_name ; units ; unit_long
!call check(nf90_def_var(), "def var new netcdf")

! attributes : same as old_file
!call check(nf90_copy_att(), "copying attributes from old dataset")

! renaming the attributes of the new dataset
!call check(nf90_rename_att(), "renaming attribute")

! deleting attributes remaining unnecessary attributes
!call check(nf90_del_att(), "deleting attribut")

! we extracted all we need from the original file, we can close it
!call check(nf90_close(ncid), "close netcdf")

! BUT scale_factor of u and v are now 1
!call check(nf90_put_att(), "put att new netcdf")

!call check(nf90_enddef(), "enddef new netcdf")

! filling the new netcdf dataset with values
!call check(nf90_put_var(), "put var new netcdf")

! close netcdf
call check(nf90_close(ncid_new), "close new netcdf")







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



subroutine extract_dimension(file_id,name_dimension, dimout)

use netcdf
implicit none

integer, intent(in) :: file_id
integer :: dimid, dimval
integer, intent(out) :: dimout
character(len=*), intent(in) :: name_dimension

! extract dimension id
call check(nf90_inq_dimid(file_id, name_dimension, dimid), "inquire dimension id")
!print *, "dim id of ", name_dimension, " : ", dimid

! extract dimension
call check(nf90_inquire_dimension(file_id, dimid, name, dimval), "inquire dimension value")
!print *, "dimension of ", name_dimension, " : ", dimval

dimout=dimval

end subroutine extract_dimension



end program read_nc_ibi
