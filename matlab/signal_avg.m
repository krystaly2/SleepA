function filtered_data = signal_avg(signal, n)

x = transpose(signal);
n = 100;
s1 = size(x, 1);
M  = s1 - mod(s1, n);
y  = reshape(x(1:M), n, []);
filtered_data = transpose(sum(y, 1) / n);