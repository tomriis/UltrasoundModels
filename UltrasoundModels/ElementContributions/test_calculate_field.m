app.n_elements_r = 42;
app.n_elements_y = 6;
app.a = 118/1000;
app.b = 90/1000;
app.D = [6, 6]/1000;
app.R_focus = app.a;
app.type = 'horizontal';
app.focus = [0,0,0]/1000;
app.kerf = 0.4/1000;
app.rect2D = kwave_focused_array(app.n_elements_r, 1,...,
app.kerf, app.D, app.R_focus, app.a, app.b, app.type);
app.rect3D = kwave_focused_array(app.n_elements_r,app.n_elements_y,...,
app.kerf, app.D, app.R_focus, app.a, app.b, app.type);
%show_transducer('data',app.rect3D)
app.c = 1540;
app.plane = 'xy';
app.fo = 650e3;
app.lambda = app.c/app.fo;
[x,y,z] = get_slice_xyz(app.plane, app.focus);

[c_mat, z_mat] = calculate_model_field2(app);

delays = compute_delays(app.rect3D, app.focus, app.c);
disp('Calculating Field');tic;
hp=calculate_field_timeseries(c_mat,z_mat, delays, app.c, app.fo, 0);
h=toc; disp(num2str(toc));

x_dim = size(hp,2); y_dim = size(hp,3);

max_hp = reshape(max(hp), [x_dim y_dim]);
sum_hilbert = reshape(sum(abs(hilbert(hp)), 1), [x_dim y_dim]);
max_hp_db = db(max_hp./max(max(max_hp)));
sum_hilbert_db = db(sum_hilbert./max(max(sum_hilbert)));
visualize_field(max_hp_db, x,y)