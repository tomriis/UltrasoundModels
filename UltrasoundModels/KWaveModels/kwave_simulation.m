function [txfield,xdc_data] = kwave_simulation(varargin)
% create the computational grid
Nx = 256;
Ny = 256;
Nz = 256;
dx = 1e-3;
dy = 1e-3;
dz = 1e-3;
kgrid = makeGrid(Nx, dx, Ny, dy, Nz, dz);
% number of grid points in the x (row) direction
% number of grid points in the y (column) direction
% grid point spacing in the x direction [m]
% grid point spacing in the y direction [m]
% define the medium properties
medium.sound_speed = 1500*ones(Nx, Ny); % [m/s]
medium.sound_speed(1:50, :) = 1800;     % [m/s]
medium.density = 1040;                  % [kg/m^3]
% define an initial pressure using makeDisc
disc_x_pos = 75;
disc_y_pos = 120;
disc_radius = 8;
disc_mag = 3;
source.p0 = disc_mag*makeDisc(Nx, Ny, disc_x_pos, disc_y_pos, disc_radius);
% define a Cartesian sensor mask of a centered circle with 50 sensor elements
sensor_radius = 2.5e-3;                 % [m]
num_sensor_points = 50;
sensor.mask = makeCartCircle(sensor_radius, num_sensor_points);
% run the simulation
sensor_data = kspaceFirstOrder2D(kgrid, medium, source, sensor,'DataCast', 'single');
txfield = sensor_data;
xdc_data = source;
end
