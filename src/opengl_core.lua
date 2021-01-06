opengl_core = {};

--swizzling transformer
local swz = {x = 1, r = 1, s = 1, y = 2, g = 2, t = 2, z = 3, b = 3, p = 3, w = 4, a = 4, q = 4};

--metatable
local vector = {};
local matrix = {};

--table mult
local mxn = function(t, a)
	local mat = {};
	for i = 1, t.__dimc do
		local vec = {};
		for j = 1, t.__dimr do
			vec[j] = t.__data[i].__data[j] * a;
		end
		mat[i] = vector.__new(vec);
	end
	return matrix.__new(mat);
end

local mxv = function(t, a)
	local vec = {};
	local r = #a;
	local n = #t;
	for i = 1, r do
		local sum = 0;
		for j = 1, n do
			sum = sum + t[j][i] * a[j];
		end
		vec[i] = sum;
	end
	return vec;
end

local mxm = function(t, a)
	local mat = {};
	local r = #t[1];
	local c = #a;
	local n = #t;
	for i = 1, c do
		local vec = {};
		for j = 1, r do
			local sum = 0;
			for k = 1, n do
				sum = sum + t[k][j] * a[i][k];
			end
			vec[j] = sum;
		end
		mat[i] = vec;
	end
	return mat;
end

local ttom = function(t)
	local mat = {};
	local c = #t;
	local r = #t[1];
	for i = 1, c do
		local vec = {};
		for j = 1, r do
			vec[j] = t[i][j];
		end
		mat[i] = vector.__new(vec);
	end
	return matrix.__new(mat);
end

--member function
local vtot = function(v)
	local tbl = {};
	for i = 1, v.__dim do
		tbl[i] = v.__data[i];
	end
	return tbl;
end

local mtot = function(m)
	local tbl = {};
	for i = 1, m.__dimc do
		tbl[i] = m.__data[i]:toarray();
	end
	return tbl;
end

local dot = function(a, b)
	assert(getmetatable(a) == 'vector', 'The first argument of dot is ' .. type(a) .. ', it cannot perform the dot operatiom.');
	assert(getmetatable(b) == 'vector', 'The second argument of dot is ' .. type(b) .. ', it cannot perform the dot operatiom.');
	assert(a.__dim == b.__dim, 'Cannot dot two vectors with different length.');
	local sum = 0;
	for i = 1, a.__dim do
		sum = sum + a.__data[i] * b.__data[i];
	end
	return sum;
end

local cross = function(v, a)
	assert(getmetatable(v) == 'vector', 'The first argument in cross is ' .. type(a) .. ', it cannot perform the cross operatiom.');
	assert(getmetatable(a) == 'vector', 'The second argument in cross is ' .. type(b) .. ', it cannot perform the cross operatiom.');
	assert(v.__dim == 3, 'The length of first vector in cross is ' .. v.__dim .. ', cross only support length 3.');
	assert(a.__dim == 3, 'The length of second vector in cross is ' .. a.__dim .. ', cross only support length 3.');
	return vector.__new({
		v.__data[2] * a.__data[3] - v.__data[3] * a.__data[2],
		v.__data[3] * a.__data[1] - v.__data[1] * a.__data[3],
		v.__data[1] * a.__data[2] - v.__data[2] * a.__data[1]
	});
end

local nmlz = function(v)
	assert(getmetatable(v) == 'vector', type(v) .. ' cannot call normalize.');
	local sum = 0;
	for i = 1, v.__dim do
		sum = sum + v.__data[i] * v.__data[i];
	end
	local vec = {};
	local div = math.sqrt(sum);
	for i = 1, v.__dim do
		vec[i] = v.__data[i] / div;
	end
	return vector.__new(vec);
end

local tsps = function(m)
	assert(getmetatable(m) == 'matrix', type(m) .. ' cannot call transpose.');
	local mat = {};
	for i = 1, m.__dimr do
		local vec = {};
		for j = 1, m.__dimc do
			vec[j] = m.__data[j].__data[i];
		end
		mat[i] = vector.__new(vec);
	end
	return matrix.__new(mat);
end

local tr = function(m)
	assert(getmetatable(m) == 'matrix' and m.__dimc == m.__dimr, 'It does\'t have trace.');
	local sum = 0;
	for i = 1, m.__dimc do
		sum = sum + m.__data[i].__data[i];
	end
	return sum;
end

local det = function(m, a)
	assert(getmetatable(m), type(m) .. ' cannot call det.');
	if(m.__dimc ~= m.__dimr) then return 0; end
	local acc;
	if(a == nil) then acc = 0;
	else acc = math.pow(10, -a); end
	local offset = 1;
	local mat = m:toarray();
	local n = m.__dimc;
	for i = n, 2, -1 do
		local x = i;
		while x >= 1 and math.abs(mat[x][i]) <= acc do
			x = x - 1;
		end
		if(x <= 0) then return 0; end
		if(x ~= i) then
			for j = 1, n do
				mat[x][j], mat[i][j] = mat[i][j], mat[x][j];
			end
			if((x - i) % 2 == 1) then offset = -offset; end
		end
		for j = 1, i - 1 do
			local mut = mat[j][i] / mat[i][i];
			for k = 1, i - 1 do
				mat[j][k] = mat[j][k] - mut * mat[i][k];
			end
			mat[j][i] = 0;
		end
	end
	if(math.abs(mat[1][1]) <= acc) then return 0; end
	local sum = offset;
	for i = 1, n do
		sum = sum * mat[i][i];
	end
	return sum;
end

local inv = function(m, a)
	assert(getmetatable(m) == 'matrix', type(m) .. ' cannot call inv.');
	assert(m.__dimc == m.__dimr, 'A ' .. m.__dimc .. '*' .. m.__dimr .. ' matrix isn\'t the square matrix and it doesn\'t have inverse.');
	local acc;
	if(a == nil) then acc = 0;
	else acc = math.pow(10, -a); end
	local n = m.__dimc;
	local mb = {};
	local mat = m:toarray();
	for i = 1, n do
		local v = {};
		for j = 1, n do
			if(i == j) then
				v[j] = 1;
			else
				v[j] = 0;
			end
		end
		mb[i] = v;
	end

	for i = n, 1, -1 do
		local x = i;
		while x >= 1 and mat[x][i] == 0 do
			x = x - 1;
		end
		assert(math.abs(mat[x][i]) >= acc, 'This matrix doesn\'t has inverse');
		if(x ~= i) then
			for j = 1, n do
				mat[x][j], mat[i][j] = mat[i][j], mat[x][j];
				mb[x][j], mb[i][j] = mb[i][j], mb[x][j];
			end
		end
		local t = mat[i][i];
		for j = 1, n do
			mb[i][j] = mb[i][j] / t;
			mat[i][j] = mat[i][j] / t;
		end
		for j = 1, i - 1 do
			local t = mat[j][i];
			for k = 1, n do
				mb[j][k] = mb[j][k] - mb[i][k] * t;
				mat[j][k] = mat[j][k] - mat[i][k] * t;
			end
		end
	end
	for i = 1, n - 1 do
		for j = i + 1, n do
			for k = 1, n do
				mb[j][k] = mb[j][k] - mb[i][k] * mat[j][i];
			end
		end
	end
	
	local res = {};
	for i = 1, n do
		local vec = {};
		for j = 1, n do
			vec[j] = mb[i][j];
		end
		res[i] = vector.__new(vec);
	end
	return matrix.__new(res);
end

--class table
vector.__new = function(t)
	local vec = {
		__data = t,
		__dim = #t,
		toarray = vtot,
		dot = dot,
		cross = cross,
		normalize = nmlz
	};
	setmetatable(vec, vector);
	return vec;
end

vector.__eq = function(a, b)
	if(getmetatable(a) ~= 'vector' or getmetatable(b) ~= 'vector') then return false; end
	if(a.__dim ~= b.__dim) then return false; end
	for i = 1, a.__dim do
		if(a.__data[i] ~= b.__data[i]) then return false; end
	end
	return true;
end

vector.__add = function(a, b)
	if(getmetatable(a) ~= 'vector') then a, b = b, a; end
	local vec = {};
	if(type(b) == 'number') then
		for i = 1, a.__dim do
			vec[i] = a.__data[i] + b;
		end;
	elseif(getmetatable(b) == 'vector') then
		assert(a.__dim == b.__dim, "Can't adding two vectors with different length.");
		for i = 1, a.__dim do
			vec[i] = a.__data[i] + b.__data[i];
		end
	else
		error("The vector cannot add to " .. type(b) .. '.');
	end
	return vector.__new(vec);
end

vector.__sub = function(a, b)
	return a + (-b);
end

vector.__unm = function(a)
	local vec = {};
	for i = 1, a.__dim do
		vec[i] = -a.__data[i];
	end;
	return vector.__new(vec);
end

vector.__mul = function(a, b)
	if(getmetatable(a) ~= 'vector') then a, b = b, a; end
	local vec = {};
	if(type(b) == 'number') then
		for i = 1, a.__dim do
			vec[i] = a.__data[i] * b;
		end
	elseif(getmetatable(b) == 'vector') then
		error('To avoid confusion, the operator "*" in vector is only used to multiply by number or matrix, please use function "dot" or "cross".');
			--return a.dot(b);
	elseif(getmetatable(b) == 'matrix') then
		assert(b.__dimr == a.__dim, 'A vector cannot multiply with a matrix when the length of vector is different from the row of matrix.');
		for i = 1, b.__dimc do
			vec[i] = a:dot(b.__data[i]);
		end
	else
		error('A ' .. type(b) .. " cannot be multiplied by a vector.");
	end
	return vector.__new(vec);
end

vector.__len = function(t)
	return t.__dim;
end

vector.__newindex = function(t, k, v)
	if(type(k) == 'number') then
		assert(t.__data[k], "This vector doesn't have componet of " .. k .. '.');
		assert(type(v) == 'number', 'A ' .. type(v) .. " can't be used to assign for a number.");
		t.__data[k] = v;
		return;
	end
	assert(type(k) == 'string', 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".');
	if(#k == 1) then
		if(type(v) == 'number') then
			assert(swz[k], 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".');
			t.__data[swz[k]] = v;
			return;
		else
			error('A ' .. type(v) .. " can't be used to assign for a number.");
		end
	end
	assert(getmetatable(v) == 'vector', 'A ' .. type(v) .. " can't be used to assign for a vector.")
	assert(#k <= v.__dim, 'The vector supplied does not have enough length.')
	for i = 1, #k do
		local c = k:sub(i, i);
		assert(swz[c], 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".')
		assert(swz[c] <= t.__dim, "This vector doesn't have componet of " .. c .. '.');
		t.__data[swz[c]] = v.__data[i];
	end
end

vector.__index = function(t, k)
	if(type(k) == 'number') then
		assert(t.__data[k], "This vector doesn't have componet of " .. k .. '.');
		return t.__data[k];
	end
	assert(type(k) == 'string', 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".');
	if(#k == 1) then
		assert(swz[k], 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".');
		assert(t.__data[swz[k]], "This vector doesn't have componet of " .. k .. '.');
		return t.__data[swz[k]];
	end
	local len = #k;
	local vec = {};
	for i = 1, len do
		local c = k:sub(i, i);
		assert(swz[c], 'Swizzling only suppose a string include "xyzw", "rgba" or "stpq".')
		assert(t.__data[swz[c]], "This vector doesn't have componet of " .. c .. '.');
		vec[i] = t.__data[swz[c]];
	end
	return vector.__new(vec);
end

vector.__concat = function(t, a)
	if(getmetatable(t) == 'vector') then return vector.__tostring(t) .. a;
	else return t .. vector.__tostring(a); end
end

vector.__tostring = function (a)
	local str = "[" .. a.__data[1];
	for i = 2, a.__dim do
		str = str .. ', ' .. a.__data[i];
	end
	str = str .. ']';
	return str;
end

vector.__metatable = 'vector';

matrix.__new = function(t)
	local mat = {
		__data = t,
		__dimc = #t,
		__dimr = t[1].__dim,
		toarray = mtot,
		transpose = tsps,
		tr = tr,
		det = det,
		inv = inv
	};
	setmetatable(mat, matrix);
	return mat;
end

matrix.__eq = function(a, b)
	if(getmetatable(a) ~= 'matrix' or getmetatable(b) ~= 'matrix') then return false; end
	if(a.__dimc ~= b.__dimc or a.__dimr ~= b.__dimr) then return false; end
	for i = 1, a.__dimc do
		for j = 1, a.__dimr do
			if(a.__data[i].__data[j] ~= b.__data[i].__data[j]) then return false; end
		end
	end
	return true;
end

matrix.__index = function(t, k)
	assert(type(k) == 'number', 'The matrix only index by number.');
	assert(t.__data[k], 'Out of range');
	return t.__data[k];
end

matrix.__newindex = function(t, k, v)
	assert(type(k) == 'number', 'The matrix only index by number.');
	assert(t.__data[k], 'Out of range');
	assert(getmetatable(v) == 'vector', 'A ' .. type(v) .. ' cannot assign for a column of matrix.');
	t.__data[k] = v;
end

matrix.__add = function(t, a)
	if(getmetatable(t) ~= 'matrix') then t, a = a, t; end
	assert(getmetatable(a) == 'matrix', 'A ' .. type(a).. ' cannot add with matrix.');
	assert(t.__dimc == a.__dimc and t.__dimr == a.__dimr, 'Cannot adding two matrix with different number of row or column.');
	local mat = {};
	for i = 1, t.__dimc do
		local vec = {};
		for j = 1, t.__dimr do
			vec[j] = t.__data[i].__data[j] + a.__data[i].__data[j];
		end
		mat[i] = vector.__new(vec);
	end
	return matrix.__new(mat);
end

matrix.__sub = function(t, a)
	return t + (-a);
end

matrix.__unm = function(t)
	local mat = {};
	for i = 1, t.__dimc do
		local vec = {};
		for j = 1, t.__dimr do
			vec[j] = -t.__data[i].__data[j];
		end
		mat[i] = vector.__new(vec);
	end
	return matrix.__new(mat);
end

matrix.__mul = function(t, a)
	if(getmetatable(t) ~= 'matrix') then t, a = a, t; end
	assert(type(a) == 'number' or getmetatable(a) == 'vector' or getmetatable(a) == 'matrix', 'A ' .. type(a) .. ' cannot multiply with matrix.');
	local mat = {};
	if(type(a) == 'number') then return mxn(t, a);
	elseif(getmetatable(a) == 'vector') then
		assert(a.__dim == t.__dimc, 'A matrix cannot multiply with a vector when the column of matrix is different from the length of vector.');
		return vector.__new(mxv(t:toarray(), a:toarray()));
	elseif(getmetatable(a) == 'matrix') then
		assert(t.__dimc == a.__dimr, 'Two matrix cannot multiply when the column of left matrix is different from the row of right matrix.');
		return ttom(mxm(t:toarray(), a:toarray()));
	end
end

matrix.__pow = function(t, a)
	assert(getmetatable(t) == 'matrix', 'Cannot pow ' .. type(t) .. ' and ' .. type(a) .. '.');
	assert(t.__dimc == t.__dimr, 'Only square matrix can pow.');
	local e = math.floor(a);
	assert(type(a) == 'number' and e == a, 'The exponent must be integer.');
	if(e < 0) then
		t = t:inv();
		e = -e;
	end
	local mat = t:toarray();
	local flag = {};
	local idx = 1;
	while e > 0 do
		flag[idx] = e % 2;
		idx = idx + 1;
		e = e // 2;
	end
	for i = 1, #flag do
		print(flag[i]);
	end
	print(idx);
	local n = t.__dimc;
	local res = {};
	for i = 1, n do
		local resv = {};
		for j = 1, n do
			if(i == j) then resv[j] = 1;
			else resv[j] = 0; end
		end
		res[i] = resv;
	end
	for i = idx - 1, 1, -1 do
		res = mxm(res, res);
		if(flag[i] == 1) then res = mxm(res, mat); end
	end
	return ttom(res);
end

matrix.__len = function(t)
	return {t.__dimc, t.__dimr};
end

matrix.__metatable = 'matrix';

matrix.__concat = function(t, a)
	if(getmetatable(t) == 'matrix') then return matrix.__tostring(t) .. a;
	else return t .. matrix.__tostring(a); end
end

matrix.__tostring = function(t)
	local str = '[';
	str = str .. vector.__tostring(t.__data[1]);
	for i = 2, t.__dimc do
		str = str .. ', ' .. vector.__tostring(t.__data[i]);
	end
	return str .. ']';
end

--useful function

local contect = function(arg, num)
	local tbl = {};
	local idx = 1;
	local iidx = 1;
	for i = 1, num do
		if(type(arg[idx]) == 'number') then
			tbl[i] = arg[idx];
			idx = idx + 1;
		elseif(getmetatable(arg[idx]) == 'vector' or getmetatable(arg[idx]) == 'matrix') then
			tbl[i] = arg[idx].__data[iidx];
			iidx = iidx + 1;
			if(iidx > arg[idx].__dim) then
				idx = idx + 1;
				iidx = 1;
			end
		else
			error(type(arg[idx]) .. " can't be used to creat a vector.");
		end
	end
	return tbl;
end

local prevec = function(t, n)
	if(#t == 1 and type(t[1]) == 'number') then
		local arg = {};
		for i = 1, n do
			arg[i] = t[1];
		end
		return vector.__new(arg);
	else
		return vector.__new(contect(t, n));
	end
end

local premat = function(t, c, r)
	local mat = {};
	if(#t == 1 and (type(t[1]) == 'number' or getmetatable(t[1]) == 'matrix')) then
		local a = t[1];
		if(type(t[1]) == 'number') then
			assert(c == r, 'Only square matrix can be create by a number.');
			for i = 1, c do
				vec = {};
				for j = 1, r do
					if(i == j) then vec[j] = a;
					else vec[j] = 0.0; end
				end
				mat[i] = vector.__new(vec);
			end
		else
			assert(a.__dimc >= c and a.__dimr >= r, 'The ' .. a.__dimc .. 'x' .. a.__dimr .. ' matrix is too small to create a ' .. c .. 'x' .. r .. ' matrix');
			for i = 1, c do
				vec = {};
				for j = 1, r do
					vec[j] = a.__data[i].__data[j];
				end
				mat[i] = vector.__new(vec);
			end
		end
	else
		local idx = 1;
		for i = 1, c do
			local n = 0;
			local vec = {};
			local j = 1;
			while true do
				if(type(t[idx]) == 'number') then
					n = n + 1;
				elseif(getmetatable(t[idx]) == 'vector') then
					n = n + t[idx].__dim;
				else
					error('A ' .. type(t[idx]) .. ' cannot be used to create a matrix.');
				end
				vec[j] = t[idx];
				j = j + 1;
				idx = idx + 1;
				assert(n <= r, 'A vector will be divided in the end of a column when creating matrix.');
				if(n == r) then break; end
			end
			local con = contect(vec, r);
			mat[i] = vector.__new(con);
		end
	end
	return matrix.__new(mat);
end

vectype = function(a)
	if(type(a) == 'number') then return {1, 1}; end
	if(getmetatable(a) == 'vector') then return {1, a.__dim}; end
	if(getmetatable(a) == 'matrix') then return {2, a.__dimc, a.__dimr}; end
	return nil;
end

opengl_core.premat = premat;
opengl_core.prevec = prevec;
opengl_core.vectype = vectype;
opengl_core.dot = dot;
opengl_core.cross = cross;
opengl_core.nmlz = nmlz;
opengl_core.tsps = tsps;
opengl_core.tr = tr;
opengl_core.det = det;
opengl_core.inv = inv;

return opengl_core;