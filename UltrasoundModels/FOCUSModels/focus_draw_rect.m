function focus_draw_rect(xdcr,color)
    x=xdcr.center(1);
    y=xdcr.center(2);
    z=xdcr.center(3);
    w=xdcr.width/2;
    h=xdcr.height/2;
    drawx=[-w w w -w];
    drawy=[h h -h -h];
    drawz=zeros(1,4);
    cord_grid=[drawx(:) drawy(:) drawz(:)];
    cord_grid=focus_trans_rot(cord_grid,[x y z],[xdcr.euler(1) xdcr.euler(2) xdcr.euler(3)],1);
    patch(cord_grid(:,1),cord_grid(:,2),cord_grid(:,3),color);
