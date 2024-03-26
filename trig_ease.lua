--[[
    trig_ease.lua
    @三角関数移動.traで使用するモジュール
]]--


local modname = "curve_editor"
local check
if not package.loaded[modname] then
	package.preload[modname] = package.loadlib(modname .. ".auf","luaopen_" .. modname)
	check = pcall(require, modname)
	package.preload[modname] = nil
end
local trig_ease = {}

--[[
    Curve Editor.traを参考にパラメータを分類

    Curve Editor
    https://github.com/mimaraka/aviutl-plugin-curve_editor

    MIT License

    Copyright (c) 2022 mimaraka

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--
trig_ease.param = function(ce_type, par, x)
    if check then
        if ce_type == 1 and ((-2147483647 <= par and par <= -12368443) or (12368443 <= par and par <= 2147483646)) then
            x = curve_editor.getcurve(0, par, x, 0, 1)
        elseif ce_type == 1 and (1 <= par and par <= 1024) then
            x = curve_editor.getcurve(1, par, x, 0, 1)
        elseif ce_type == 2 and ((-10211201 <= par and par <= -1) or (1 <= par and par <= 10211201)) then
            x = curve_editor.getcurve(3, par, x, 0, 1)
        elseif ce_type == 2 and ((-11213202 <= par and par <= -10211202) or (10211202 <= par and par <= 11213202)) then
            x = curve_editor.getcurve(4, par, x, 0, 1)
        end
    end
    return x
end

--イージング本体
trig_ease.ease = function(pos, trig_type, ce_type, par, x, st, ed, i)
    local cos, sin = math.cos, math.sin
    local PI = math.pi

    if pos == 0 and ((trig_type == 0 and i % 2 == 0) or (trig_type == 1 and i % 2 == 1)) then
        return st + (ed - st) * (1 - cos(PI * trig_ease.param(ce_type, par, x) / 2))
    elseif pos == 0 and ((trig_type == 0 and i % 2 == 1) or (trig_type == 1 and i % 2 == 0)) then
        return st + (ed - st) * sin(PI * trig_ease.param(ce_type, par, x) / 2)
    elseif pos == 1 and trig_type == 0 then
        return st + (ed - st) * (1 - cos(PI * (trig_ease.param(ce_type, par, x) + 1 / 4)) / cos(PI / 4)) / 2
    elseif pos == 1 and trig_type == 1 then
        return st + (ed - st) * (1 - sin(PI * (trig_ease.param(ce_type, par, x) + 1 / 4)) / sin(PI / 4)) / 2
    end
end

return trig_ease