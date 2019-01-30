function [M]=make_ellipse_y_rot_mat(angle, a, b)

sa = sin(angle);
ca = cos(angle);
M=[ca   0 a/b*sa   0
    0   1  0  0
  -b/a*sa  0  ca  0
    0  0  0   1];