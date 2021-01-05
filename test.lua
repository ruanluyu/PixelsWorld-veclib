require('glua');

v1 = vec2(1);
v2 = vec3(1, 2, 3);
v3 = vec4(1, vec2(2, 3), 4);
v4 = vec4(10, 20, 30, 40);
v5 = vec3(2);
v6 = vec4(1, 2, 3, 4);
print(v3 == v4);
print(v3 == v6);

print('v1:\n' .. v1 .. '\n');
print('v2:\n' .. v2 .. '\n');
print('v3:\n' .. v3 .. '\n');
print('v4:\n' .. v4 .. '\n');

print('normalized v3:\n' .. v3:normalize() .. '\n');

print('length of v4:\n' .. #v4 .. '\n');
print('v4 - 1:\n' .. v4 - 1 .. '\n');
print('v3 - v4:\n' .. v3 - v4 .. '\n');
print('v3 dot v4:\n' .. v3:dot(v4) .. '\n');
print('v2 cross v5:\n' .. v2:cross(v5) ..  '\n');

print('v3[2]:\n' .. v3[2] .. '\n');
print('let v3[3] = 0, then v3:');
v3[3] = 0;
print(v3 .. '\n');
print('v3.wzyx:\n' .. v3.wzyx .. '\n');
print('let v4.xyz = v3.zyx, then v4:');
v4.xyz = v3.zyx;
print(v4 .. '\n');

m1 = mat2(1);
m2 = mat3(1,5,2,8,7,9,3,6,0);
m3 = mat4(1,vec3(2,3,4),vec2(5,6),vec2(7,8),9,10,11,12,vec4(13,14,15,16));
m4 = mat4x3(1, 4, 3, 6, 5, 4, 9, 7, 8, 2, 6, 4);
m5 = mat3x4(5, 6, 3, 5, 4, 7, 8, 9, 2, 0, 8, 5);
m6 = mat3x4(10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10);
m7 = mat2x3(m3);
m8 = mat4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
m9 = mat4(4);
print(m3 == m8);
print(m3 == m9);
print(m3 == 5);
print(m3 == m6);
print('m1:\n' .. m1 .. '\n');
print('m2:\n' .. m2 .. '\n');
print('m3:\n' .. m3 .. '\n');
print('m4:\n' .. m4 .. '\n');
print('m5:\n' .. m5 .. '\n');
print('m6:\n' .. m6 .. '\n');
print('m7:\n' .. m7 .. '\n');

print('transposed m2:\n' .. m2:transpose() .. '\n');
print('det of m2:\n' .. m2:det() .. '\n');
print('inv of m2:\n' .. m2:inv() .. '\n');
print('trace of m2:\n' .. m2:tr() .. '\n');

print('length of a matrix nxm is a table {n, m}:');
print('n is colnum of m5: ' .. (#m5)[1]);
print('m is row of m5: ' .. (#m5)[2] .. '\n');
print('m5 * m4:\n' .. m5 * m4 .. '\n');
print('m6 - m5:\n' .. m6 - m5 .. '\n');

print('v3 * m6:\n' .. v3 * m6 .. '\n');
print('m6 * v2:\n' .. m6 * v2 .. '\n');

print('m7[2]:\n' .. m7[2] .. '\n');
print('m7[1][2]:\n' .. m7[1][2] .. '\n');

print('let m7[2] = vec3(4, 5, 6), then m7:');
m7[2] = vec3(4, 5, 6);
print(m7 .. '\n');

print('let m7[1][2] = 0, then m7:');
m7[1][2] = 0;
print(m7 .. '\n');

print('let m7[1].rb = m7[2].ts, then m7:');
m7[1].rb = m7[2].ts;
print(m7);