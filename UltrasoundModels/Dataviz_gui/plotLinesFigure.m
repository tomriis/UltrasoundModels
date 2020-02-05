h = figure;

x = (1:700);
t = linspace(0,6*pi, 300);

y = zeros(size(x));

shift = 350;

y(shift:shift+length(t)-1) = sin(t).*exp((-((t-mean(t))/max(t)).^2)/0.25);

plot(y,'LineWidth',7);
ylim([-2.5,2.5])