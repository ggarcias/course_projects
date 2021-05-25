program linear_interpolation

    implicit none

    real(8), dimension(:), allocatable :: xa, ya
    real(8) :: x,y

    allocate(xa(4))
    allocate(ya(4))

    xa = [0.0, 0.1, 0.2, 0.3]
    ya = exp(xa)

    x = 0.05

    call linterp1D(xa, ya, x, y)
    print *, "e^", x, " = ", y

    contains

        subroutine linterp1D(xa, ya, x, y)

            implicit none

            real(8), intent(in) :: x
            real(8), dimension(:), intent(in) :: xa, ya
            real(8), intent(out) :: y


            y = ya(1) + (x-xa(1)) / (xa(1) - xa(2))*(ya(1) - ya(2))

        end subroutine linterp1D

end program linear_interpolation
