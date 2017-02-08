%14AE10009
%Sai Kiran G
 
clear all
clc
 
A = [0 3 7 -4; 8 0 4 -2; -1 6 0 2; 5 4 8 1;];
B = [-46; 0; 13; 7;];
 
Aug = [A B];
Size = 4;
solution = zeros(1,Size);
 
for row=1:Size
 
	% check if pivot element is zero
	if Aug(row, row)==0
 
		% find max element in pivot column
		mxrow = row;
		mxe = -Inf;
		for col = row+1:Size
			if (Aug(col,row) > mxe)
				mxe = Aug(col, row);
				mxrow = col;
			end
		end
 
		%swap zero row with max element row in the column
		for col=1:Size+1
			tmp = Aug(mxrow, col);
			Aug(mxrow, col) = Aug(row, col);
			Aug(row, col) = tmp;
		end
 
	end
 
	%Convert the matrix into diagonal matrix
	for crow=1:Size
        if ~(crow==row)
            rat = Aug(crow, row)/Aug(row, row);
            for col=1:Size+1
                Aug(crow, col) = Aug(crow, col) - rat * Aug(row, col);
            end    
        end
	end
end
 
%fetch values from diagonal matrix
for row = 1:Size
	solution(row) = Aug(row, Size+1)/Aug(row, row);
end
 
Aug
solution