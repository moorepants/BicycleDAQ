function bump_design()

L = 1; % meters
v = 5; % meters per second
h = 0.1; % meters

t = 0:0.01:L/v;
x = v.*t;

[y, ydot, yddot] = y_deriv(L, v, h);

figure(1)
subplot(4,1,1)
plot(x, y)
axis('equal')
ylim([0, max(y)+0.1])
xlim([min(x), max(x)])
xlabel('Distance in meters')
ylabel('Height in meters')

subplot(4,1,2)
plot(t, y)
xlabel('Time in seconds')
ylabel('Height [m]')

subplot(4,1,3)
plot(t, ydot)
xlabel('Time in seconds')
ylabel('Vertical Velocity [m/s]')

subplot(4,1,4)
plot(t, yddot)
xlabel('Time in seconds')
ylabel('Vertical Acceleration [m/s/s]')

function [y, ydot, yddot] = y_deriv(L, v, h)
    t = 0:0.01:L/v;
    y = h./2.*(1-cos(2.*pi.*v./L.*t));
    ydot = h.*pi.*v./L.*sin(2.*pi.*v./L.*t);
    yddot = 2.*h.*(pi.*v./L).^2.*cos(2.*pi.*v./L.*t);
    
function h = bump_size(v, a, l)
% returns bump hieght for a given speed, acceleration and bump length
% v : speed (m/s)
% a : acceleration (m/s^2)
% l : length (m)
% other compatiable units are fine too

h = a./2.*(l./pi./v).^2;

function a = bump_accel(v, h, l)

a = 2.*h.*(0.2.*pi.*v./l).^2;