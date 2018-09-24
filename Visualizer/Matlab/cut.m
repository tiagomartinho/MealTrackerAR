name = 'Payloads1cut';

% Read CSV
data = csvread([name '.csv'],1,0);
data = data(3178:3642,1:28);

% Write CSV
filename = [name 'cut.csv'];
dlmwrite(filename, data, '-append');