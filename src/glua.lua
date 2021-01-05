local gl = require('opengl_core');

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