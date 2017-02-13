clear all;
clc;
 
%A = [4 1 0 1 0; -1 4 -1 0 1; 0 -1 4 -1 0; 1 0 -1 4 -1; 0 1 0 -1 4;]
%B = [100; 100; 100; 100; 100;]
format short g;
A = [1 1 6; 1 9 -2; 8 2 -1;]
B = [-61.3; 49.1; 185.8;]
sz = size(A);
sz = sz(1);
Aug = [A B zeros(sz, 1)];
EPS = 0.000001;
    
 
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

% Precompute solution using gauss siedel;
A = Aug(:, 1:sz);
B = Aug(:, sz+1);
Residue = zeros(sz, 1);
rSolution = zeros(sz, 2);
Error = zeros(sz, 1);
Iterations = 0;
 
while true
  	rSolution(:, 1) = rSolution(:, 2);
  	Iterations++;
 
	% build residues
  	for row=1:sz
  		Residue(row) = B(row);
  		Residue(row) -= A(row, 1:row-1) * rSolution(1:row-1, 2);
  		Residue(row) -= A(row, row:sz) * rSolution(row:sz, 1);
  		
		  rSolution(row, 2) = rSolution(row, 1) + Residue(row) / A(row, row);
	  end

	  Error = abs(rSolution(:, 2) - rSolution(:, 1));
	  if ((max(Error)<EPS) || (Iterations > 2000))
      	  break
   	  end
end


minIterations = Inf;
for weight = 0.01:0.01:1.99
    A = Aug(:, 1:sz);
    B = Aug(:, sz+1);
    Residue = zeros(sz, 1);
    Solution = zeros(sz, 2);
    Error = zeros(sz, 1);
    Iterations = 0;

    while true
        Solution(:, 1) = Solution(:, 2);
        Iterations = Iterations + 1;

        % build residues
        for row=1:sz
          Residue(row)  = B(row);
          Residue(row)  = Residue(row) - A(row, 1:row-1)*Solution(1:row-1, 2);
          Residue(row)  = Residue(row) - A(row, row:sz)*Solution(row:sz, 1);
          
          Solution(row, 2) = (1-weight) * Solution(row, 1) + weight * Residue(row) / A(row, row);
        end
        
        Error = abs(Solution(:, 2) - Solution(:, 1));
        if ((max(Error)<EPS) || (Iterations > 200))
            differ = Solution(:, 2) - rSolution(:,2);
            
            if ((minIterations > Iterations) && max(differ) < EPS)
                minIterations = Iterations;
                minWeight = weight;
            end
            
            break
        end
    end
end

minIterations 
minWeight
rSolution
