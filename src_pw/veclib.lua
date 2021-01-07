local gl = require('veclib_core');

vec2 = function (...)
	return gl.prevec({...}, 2);
end

vec3 = function (...)
	return gl.prevec({...}, 3);
end

vec4 = function (...)
	return gl.prevec({...}, 4);
end

mat2 = function(...)
	return gl.premat({...}, 2, 2);
end

mat3 = function(...)
	return gl.premat({...}, 3, 3);
end

mat4 = function(...)
	return gl.premat({...}, 4, 4);
end

mat2x2 = function(...)
	return gl.premat({...}, 2, 2);
end

mat2x3 = function(...)
	return gl.premat({...}, 2, 3);
end

mat2x4 = function(...)
	return gl.premat({...}, 2, 4);
end

mat3x2 = function(...)
	return gl.premat({...}, 3, 2);
end

mat3x3 = function(...)
	return gl.premat({...}, 3, 3);
end

mat3x4 = function(...)
	return gl.premat({...}, 3, 4);
end

mat4x2 = function(...)
	return gl.premat({...}, 4, 2);
end

mat4x3 = function(...)
	return gl.premat({...}, 4, 3);
end

mat4x4 = function(...)
	return gl.premat({...}, 4, 4);
end

dot = gl.dot;
cross = gl.cross;
normalize = gl.nmlz;
vectype = gl.vectype;
transpose = gl.tsps;
tr = gl.tr;
det = gl.det;
inv = gl.inv;

local func1lst = {
	"d2r",
	"r2d",
	"abs",
	"acos",
	"asin",
	"atan",
	"ceil",
	"cos",
	"exp",
	"floor",
	"log",
	"max",
	"min",
	"modf",
	"sin",
	"sqrt",
	"tan",
}

for i,v in ipairs(func1lst) do
	_G[v] = function(...)
		local pv = select(1,...)
		local ty,dim = vectype(pv)
		local f=math[v]
		if(f==nil) then f=pw3[v] end
		assert(ty==1,'Number or vectype is expected for function ' .. v)
		if(dim == 1) then return f(pv) 
		elseif(dim == 2) then return vec2(f(pv[1]),f(pv[2]))
		elseif(dim == 3) then return vec3(f(pv[1]),f(pv[2]),f(pv[3]))
		else return vec4(f(pv[1]),f(pv[2]),f(pv[3]),f(pv[4]))
		end
	end
end