function [M]=make_ellipse_z_rot_mat(angle, a, b)

sa = sin(angle);
ca = cos(angle);
M=[ca   a/b*ca  0 0
    -b/a*sa   sa  0  0
  0  0  1  0
    0  0  0   1];