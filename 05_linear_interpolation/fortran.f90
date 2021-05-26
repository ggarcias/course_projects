program program_linear_interpolation

      implicit none

      integer(4) :: n, i
      real(4), dimension(:), allocatable :: xa, ya
      real(4) :: x, y
      real(4), dimension(:), allocatable :: x_single_value, x_array, y_array,&
      y_single_value

      print *, "xa will be an n-sized array with values from 1 to n with a step of 1"
      print *, "x_array will be an n-sized array with values from 0 to 1 with a step of 0.1"
      print *, "enter n size of vectors xa and x_array:"
      read *, n

      allocate(xa(n))
      allocate(ya(n))
      allocate(x_array(n))
      allocate(y_array(n))

      do i=1,n
      xa(i) = real(i)
      end do

      ya = sin(xa)

      print *, "enter real value of x:"
      read *, x

      do i=1,n
      x_array(i) = real(i)*0.1
      end do

      print *, "xa : ", xa
      print *, "ya = sin(xa) : ", ya
      print *, "x: ", x
      print *, "x_array: ", x_array

      print *, "let's find 1) y: linear interpolation of sin(", x,")"

      allocate(x_single_value(1))
      allocate(y_single_value(1))

      x_single_value(1) = x
      y_single_value = linear_interpolation(x_single_value,xa,ya)
      y = y_single_value(1)

      print *, "y = ", y

      print *, "2) y_array: linear interpolation of ", x_array

      y_array = linear_interpolation(x_array,xa,ya)

      print *, "y_array = ", y_array
      print *, "true values of sin(",x_array,") :"
      print *, sin(x_array)

      contains

          ! in the function we input the vector we want to interpolate;
          ! the xa "reference_vector"
          ! the ya "reference_values" which contains the true output...
          ! ... of the function we don't know

          ! we changed the names of parameters because the line was too long
          ! u : vector_to_interpolate
          ! v : reference_vector
          ! w : reference_values
          function linear_interpolation(u,v,w) result(linear_interpolated_vector)

          implicit none

          real(4), dimension(:) :: u,v,w
          real(4), dimension(:), allocatable :: output_vector
          real(4) :: neighbor, neighbor_sup
          integer(4) :: neighbor_index, neighbor_sup_index
          real(4), dimension(1:size(u)) :: linear_interpolated_vector

          ! linear_interpolation is the output, which will be stored in
          ! ...
          ! ... y and y_array for example in our script

          allocate(output_vector(size(u)))

          ! for each point
          do i=1,size(u)

          ! let's find its lower neighbor
          neighbor_index = locate(v, u(i))
          neighbor = v(neighbor_index)
          ! this returns the INDEX of the lower neighbor

          ! if the user is actually asking for an extrapolation:
          if (neighbor_index==size(v)) then

              print *, "the interpolation is not possible for ", u(i)
              print *, "inside the intervall ", v

          else

          ! now the find the upper neighbor
          neighbor_sup_index = neighbor_index + 1
          neighbor_sup = v(neighbor_sup_index)

          ! let's interpolate the value of the point
          output_vector(i) = w(neighbor_index) + (u(i)-v(neighbor_index)) / &
          (v(neighbor_index) - v(neighbor_sup_index)) * (w(neighbor_index) - &
          w(neighbor_sup_index))

          end if
          end do

          linear_interpolated_vector = output_vector

          ! return

          end function linear_interpolation





          INTEGER(4) FUNCTION locate(xx,x)

              implicit none

              REAL(4), DIMENSION(:), INTENT(IN) :: xx
              REAL(4), INTENT(IN) :: x
              ! INTEGER(SELECTED_INT_KIND(9)) :: locate

              !Given an array xx(1: N ) , and given a value x , returns
              !a value j
              !such that x is between xx( j  ) and xx( j + 1  ) . xx
              !must be monotonic,
              !either increasing or decreasing.
              !j = 0 or j = N is returned to indicate that x is out of
              !range.

              INTEGER(4) :: n,jl,jm,ju
              LOGICAL :: ascnd

              n=size(xx)
              ascnd = (xx(n) >= xx(1))

              jl=0
              ju=n+1

              do
              if (ju-jl <= 1) exit
              jm=(ju+jl)/2
              if (ascnd .eqv. (x >= xx(jm))) then
                  jl=jm
              else
                  ju=jm
              end if
              end do
              if (x == xx(1)) then
                  locate=1
              else if (x == xx(n)) then
                  locate=n-1
              else
                  locate=jl
              end if

              END FUNCTION locate


end program program_linear_interpolation
