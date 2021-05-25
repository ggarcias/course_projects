program linear_interpolation

! 1) f(x) [0,10] -> sin(x) (x follows a step of 1)
! 2) create another array defined from 0 -> 10 but whose step is 0.1
! 3) create a subroutine similar to linear_interpolation where xa & ya are arrays
! like before BUT x and y are not points anymore, they are values ; and their
! output is the interpolation
! -> function that automatically locates the two points determining the
! surrounding points: cf. Guillermo's e-mail & locate function

real(8), dimension(:), allocatable :: xa, ya
real(8) :: x,y,step
integer(8) :: i,n

n = 11

allocate(xa(n))
allocate(ya(n))

do i=0,10

end do
ya = sin(xa)

x = 0.05

call linterp1D(xa, ya, x, y)
print *, "e^", x, " = ", y


contains

    real(8) function f(x)

        implicit none

        real(8), intent(in) :: x
        real(8), intent(out) :: f

        f=sin(x)

    end function f


    FUNCTION locate(xx,x)
        implicit none

        REAL(KIND=16), DIMENSION(:), INTENT(IN) :: xx
        REAL(KIND=16), INTENT(IN) :: x
        INTEGER(SELECTED_INT_KIND(9)) :: locate
        !Given an array xx(1: N ) , and given a value x , returns a value j 
        such
        !that x is between xx( j  ) and xx( j + 1  ) . xx must be monotonic, 
        either increasing or decreasing.
        !j = 0 or j = N is returned to indicate that x is out of range.
        INTEGER(SELECTED_INT_KIND(9)) :: n,jl,jm,ju
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


end program linear_interpolation
