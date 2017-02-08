% Sai Kiran G
% 14AE10009
% Gauss Seidel Method
 
clear all;
clc;
 
A = [2 15 1 4; 3 1 2 1; 1 3 80 2; 2 4 7 100;]
B = [2; -6; -4; 7;]
Aug = [A B];
sz = size(A)(1);
 
% make diagonally dominant
for iter=1:min(sz, 15)
	for row=1:sz
		mElem = Aug(row, row);
		mCol = row;
 
		for col=1:sz
			if mElem < Aug(row, col)
				mElem = Aug(row, col);
				mCol = col;
			end
		end
 
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
 
while true
  	Solution(:, 1) = Solution(:, 2);
  	Iterations++;
 
	% build residues
  	for row=1:sz
  		Residue(row) = B(row);
  		Residue(row) -= A(row, 1:row-1)*Solution(1:row-1, 2);
  		Residue(row) -= A(row, row:sz)*Solution(row:sz, 1);
		Residue(row) /= A(row, row);
 
		Solution(row, 2) = Solution(row, 1) + Residue(row);
	end
 
    Error = abs(Solution(:, 2) - Solution(:, 1));
	if ((max(Error)<EPS) || (Iterations > 2000))
      	Iterations
      	Solution(:, 2)
    	break
   	end
end
