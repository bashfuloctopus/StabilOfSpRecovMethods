function [firstMin, idx] = getFirstMin(domain, ran) 
% domain and range; note that getFirstMin differs from
% findFirstMin in the same way that Matlab's get methods
% differ from its find methods. Namely, findFirstMin returns
% the *index* that corresponds to the first min of ran, while
% getFirstMin returns a matrix whose entries correspond to the
% domain and range values corresponding to that index. 

  
% e.g. domain = tau_vec, ran = lasso_error
  if isrow(ran) || iscolumn(ran)
      idx_of_first_min = findFirstMin(ran);
      ran_val = ran(idx_of_first_min);
  else
      idx_of_first_min = batchFindFirstMin(ran);
      ran_val = diag(ran(idx_of_first_min, :));
  end

  domain_val = domain(idx_of_first_min);
  
  if isrow(domain_val)
    domain_val = domain_val.';
  end
  if isrow(ran_val)
    ran_val = ran_val.';
  end
  
  %display(domain_val); display(ran_val);
  
  firstMin = [domain_val, ran_val];
  idx = idx_of_first_min;
  
end


function idx = findFirstMin(vec) 
% FINDFIRSTMIN finds the index j of the vector vec such that vec(j) <= vec(j-1) and vec(j) <= vec(j+1)
%    Note that this assumes: 
%        1) that vec is generated by some locally convex function 
%        2) vec is already listed in the desired sorting order
%
%    Also note: this function exists because e.g. lasso solver
%    eventually has many degrees of freedom when tau becomes
%    large; we would like to ignore this regime in certain
%    cases. This function thus finds the minimum before the
%    regime begins (where this 'makes sense' [what does it mean
%    to 'make sense' here?]). 

  % set result to first index trivially 
  j = 1;
  
  while j < length(vec) && vec(j+1) < vec(j)
    j = j+1;
  end

  idx = j;
  end
  
  
  
  function idxvec = batchFindFirstMin(mat)
% BATCHFINDFIRSTMIN iterates over a matrix, returning the result of findFirstMin for each column vector 
%    
  sz_mat = size(mat,2);
  idxvec = zeros(1, sz_mat);

  for k = 1:sz_mat
    idxvec(k) = findFirstMin( mat(:,k));
  end  
  
  end