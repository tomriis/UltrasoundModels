function configure_axes(app)
    axes_limits = 2*[-app.a,app.a];
    ylim(app.UIAxes_2,7/8*axes_limits);
    xlim(app.UIAxes_2, 7/8*axes_limits);
    ylim(app.UIAxes,3/5*axes_limits);
    xlim(app.UIAxes, 3/5*axes_limits);
end