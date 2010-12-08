function bump_design(L, v, h)

% L = 1; % meters
% v = 9; % meters per second
% h = 0.03; % meters

[t, y, ydot, yddot] = y_deriv(L, v, h);
x = v.*t;

figure(1)
subplot(4,1,1)
m2in = 39.3700787;
mps2mph = 2.23693629;
plot(x.*m2in, y.*m2in)
axis('equal')
ylim([0, max(y.*m2in)+0.5*max(y.*m2in)])
xlim([min(x.*m2in), max(x.*m2in)])
title(sprintf('Velocity = %0.2f m/s (%0.2f mph)\nMax Accel = %0.2f g, Min Accel = %0.2f g', v, v*mps2mph, max(yddot./9.81), min(yddot./9.81)))
xlabel('Length [in]')
ylabel('Height [in]')

subplot(4,1,2)
plot(t, y)
xlabel('Time in seconds')
ylabel('Height [m]')

subplot(4,1,3)
plot(t, ydot)
xlabel('Time in seconds')
ylabel('Vertical Velocity [m/s]')

subplot(4,1,4)
plot(t, yddot/9.81)
xlabel('Time in seconds')
ylabel('Vertical Acceleration [g]')

function [t, y, ydot, yddot] = y_deriv(L, v, h)
    t = 0:0.01*(L/v):L/v;
    y = h./2.*(1-cos(2.*pi.*v./L.*t));
    ydot = h.*pi.*v./L.*sin(2.*pi.*v./L.*t);
    yddot = (2.*h.*(pi.*v./L).^2.*cos(2.*pi.*v./L.*t))+9.81;