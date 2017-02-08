clear all;
clc;
 
A = [4 1 0 1 0; -1 4 -1 0 1; 0 -1 4 -1 0; 1 0 -1 4 -1; 0 1 0 -1 4;]
B = [100; 100; 100; 100; 100;]
sz = size(A)(1);
Aug = [A B zeros(sz, 1)];
 
% find maximum position in each row
for row=1:sz
	mElem = Aug(row, row);
	mCol = row;
 
	for col=1:sz
		if abs(mElem) < abs(Aug(row, col))
			mElem = Aug(row, col);
			mCol = col;
		end
		if ((abs(mElem)==abs(Aug(row, col))) && col==row)
			mElem = Aug(row, col);
			mCol = col;
		end
	end
 
	Aug(row, sz+2) = mCol;
end
 
% make diagonally dominant
for iter=1:15
	for row=1:sz
		mCol = Aug(row, sz+2);
		tmp = Aug(row, :);
		Aug(row, :) = Aug(mCol, :);
		Aug(mCol, :) = tmp;
	end
end

A = Aug(:, 1:sz);
B = Aug(:, sz+1);
EPS = 0.000001;
Residue = zeros(sz, 1);
Solution = zeros(sz, 2);
Error = zeros(sz, 1);
Iterations = 1;
weight = 1.0;

while true
  	Solution(:, 1) = Solution(:, 2);
  	Iterations++;

	% build residues
  	for row=1:sz
  		Residue(row)  = B(row);
  		Residue(row) -= A(row, 1:row-1)*Solution(1:row-1, 2);
  		Residue(row) -= A(row, row:sz)*Solution(row:sz, 1);
		Residue(row) /= A(row, row);
		
		Solution(row, 2) = Solution(row, 1) + weight * Residue(row);
	end
    
    Error = abs(Solution(:, 2) - Solution(:, 1));
	if ((max(Error)<EPS) || (Iterations > 2000))
      	Iterations
      	Solution(:, 2)
    	break
   	end
end
