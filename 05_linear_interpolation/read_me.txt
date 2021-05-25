1) f(x) [0,10] -> sin(x) step 1
2) create another array defined from 0 -> 10 but step 0.1 and which function is sin(x)
3) create a subroutine similar to linear_interpolation where xa ya are arrays BUT x and y are not points but values
& which output is the interpolation
-> function that automatically locates the two points determining the surrounding points


1) xa = [1..10] step 1
ya = [sin(1)..sin(10)] step 1

2) x = 0.5 (one point) or [0.1..10] step 0.1 (array)
y = interpolation of x


do i=1, size(x)
    1) locate in xa the lowest neighbor of x, return its index = index_x
    2) y(i) = ya(index_x) + [(xa(index_x + 1) - xa(index_x)) / (ya(index_x + 1) - ya(index_x))] * x(i)
