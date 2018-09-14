name = 'withMoves';

% Read CSV
data = csvread([name '.csv'],1,0);
data = data(:,1:28);

% Annotate Movement
movement = data(:,28);
ranges = [1,2,12,20:1:110];
movement(ranges) = 1;
data = data(:,1:27);
data = cat(2,data,movement);

% Write CSV
filename = [name 'annotated.csv'];
header = ["jawOpen","mouthLowerDown_R","mouthLowerDown_L","mouthStretch_R","mouthStretch_L","mouthPucker","mouthFrown_R","mouthFrown_L","mouthClose","mouthFunnel","mouthUpperUp_L","mouthUpperUp_R","jawForward","mouthShrugLower","mouthShrugUpper","jawRight","jawLeft","mouthDimple_L","mouthDimple_R","mouthRollLower","mouthRollUpper","mouthLeft","mouthRight","mouthSmile_L","mouthSmile_R","mouthPress_L","mouthPress_R","movement"];
textHeader = strjoin(header, ',');
fid = fopen(filename,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
dlmwrite(filename, data, '-append');