local memory = require 'memory'
local font = renderCreateFont('Calibri', 12) -- стандартный шрифт и стандартный размер

local notify_data = {}
local notify_x_size = 250
local notify_x_pos = 500
local notify_y_pos = 500

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    initializateNotfPos()
    while true do
		wait(0)
		for k, v in ipairs(notify_data) do
			if (v['timeclose'] + 1) < os.clock() then
				table.remove(notify_data, k)
			end
		end
	end
end

function onD3DPresent()
	if isSampAvailable() then
		DrawRender()
	end
end

function EXPORTS.addNotification(text --[[str]], time--[[int]], style--[[int]], curve--[[int]])
	if not time then
		time = 5
	end
	if not style then
		style = 127
	end
	if not curve then
		curve = 8
	end
	table.insert(notify_data, {text = text, style = style, curve = curve, timeopen = os.clock(), timeclose = os.clock() + time})
end

function DrawRender()
	local y_pos = notify_y_pos -- начальная вертикальная координата.
	for key, val in ipairs(notify_data) do
		local show_notify = true -- надо ли рисовать уведомление?
		local x_pos = notify_x_pos -- координата по горизонатали
		local str = 0 -- количество строк в уведомлении
		local last_symb = 0
		local prelast_symb = 1
		local text_len = {} -- массив длины текста в пикселях
		for line in val['text']:gmatch("[^\r\n]+") do
			text_len[#text_len + 1] = renderGetFontDrawTextLength(font, line) -- считаем длину текста
			str = str + 1
		end
		local y_size = 20 + str * renderGetFontDrawHeight(font) + 3 * (str - 1) -- 20 – высота "бортиков" (до текста + после текста), 3 – доп. высота (отступ между строками)
		local big_len = 0
		for key2, val2 in ipairs(text_len) do
			if big_len < val2 then
				big_len = val2
			end
		end
		local notify_x_size = big_len + 20
		local timerdur = os.clock() - val['timeopen'] -- время с момента добавления уведомления
		if timerdur < 0.3 then -- 0.3 – время "раскрывания" (анимация движения вправо)
			x_pos = timerdur / 0.3 * (notify_x_pos + notify_x_size) - notify_x_size
		else
			timerdur = val['timeclose'] - os.clock() -- время до закрывания
			if timerdur > 0 and timerdur < 0.3 then -- 0.3 – время "скрывания" (анимация влево)
				x_pos = timerdur / 0.3 * (notify_x_pos + notify_x_size) - notify_x_size
			elseif timerdur > -0.2 and timerdur <= 0 then -- верхние уведомления съезжают вниз. 0.2 – время съезжания
				local new_y_pos = y_pos - y_size - 20 -- 20 – расстояние между соседними уведомлениями
				y_pos = new_y_pos - timerdur / 0.2 * (y_pos - new_y_pos)
				show_notify = false -- говорим, что уведомление показывать уже не надо
			elseif timerdur <= -0.2 then -- уведомление окончено. удаляем. 0.2 – время съезжания
				show_notify = false -- говорим, что уведомление показывать уже не надо
				--table.remove(notify_data, k)
			end
		end
		if show_notify then
			y_pos = y_pos - y_size - 20 -- 20 – расстояние между соседними уведомлениями
			if val.style == 0 then --красный
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xCDBD2F00)
			elseif val.style == 1 then --оранжевый
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xCDD66000)
			elseif val.style == 2 then --жёлтый
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xCDDBB002)
			elseif val.style == 3 then --зелёный
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xCD2B9900)
			elseif val.style == 4 then --голубой
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xCD005699)
			else --standart
				renderDrawCircleBox(notify_x_size, y_size, x_pos, y_pos, val.curve, 0xBD000000) -- 8 – радиус закругления
			end
			local text_y = y_pos + 10 -- 10 – высота "бортика" до текста
			last_symb = 1
			local tcolor = 0xFFFFFF -- текущий цвет
			local u = 1
			local text_x = x_pos + (notify_x_size - text_len[u]) / 2 -- позиция текста по X координате
			local current_str_st = 1 -- начало текущей строки (до переноса / до следующего цвета)
			while last_symb <= val.text:len() do
				if last_symb == val.text:len() then -- если последний символ
					local current_str = val.text:sub(current_str_st, last_symb)
					renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- рисуем строку текста уведомления
				elseif val.text:sub(last_symb, last_symb) == '\n' then
					u = u + 1
					local current_str = val.text:sub(current_str_st, last_symb - 1)
					renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- рисуем строку текста уведомления
					current_str_st = last_symb + 1
					text_x = x_pos + (notify_x_size - text_len[u]) / 2
					text_y = text_y + (renderGetFontDrawHeight(font) + 3) -- 3 – отступ между строками
				else -- если обычный символ (не перенос и не последний)
					local hex_color = true
					local hex_number = 0 -- сам новый цвет
					if last_symb <= val.text:len() - 7 and val.text:sub(last_symb, last_symb) == '{' and val.text:sub(last_symb + 7, last_symb + 7) == '}' then -- если формат: {......}
						local symbs = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' }
						local symbs2 = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' }
						for k = last_symb + 1, last_symb + 6 do -- обходим все 6 внутренних (между скобочками) символов
							local correct_symb = false
							for numb, hex_symb in pairs(symbs) do -- обходим все числа HEX системы
								if val.text:sub(k, k) == hex_symb or val.text:sub(k, k) == symbs2[numb] then
									correct_symb = true
									hex_number = hex_number * 0x10 + (numb - 1)
									break
								end
							end
							if not correct_symb then -- если некорретный символ, то выкидываем из цикла и не обращаем внимание
								hex_color = false
								break
							end
						end
					else
						hex_color = false -- говорим, что нету изменения цвета
					end
					if hex_color then
						local current_str = val.text:sub(current_str_st, last_symb - 1) -- записываем "текущую" строку
						renderFontDrawText(font, current_str, text_x, text_y, 0xFF000000 + tcolor, true) -- рисуем строку текста уведомления
						text_x = text_x + renderGetFontDrawTextLength(font, current_str)
						last_symb = last_symb + 7 -- все элементи {......} скипаем
						current_str_st = last_symb + 1
						tcolor = hex_number
					end
				end
				last_symb = last_symb + 1
			end
		end
	end
end

function initializateNotfPos()
	local radar_x_left = memory.getfloat(memory.getuint32(0x58A79B, true), true)
	local radar_y = memory.getfloat(memory.getuint32(0x58A7C7, true), true)
	radar_x_left, radar_y = convertGameScreenCoordsToWindowScreenCoords(radar_x_left, radar_y)
	radar_y = select(2, getScreenResolution()) - radar_y
	local radar_x_right = memory.getfloat(memory.getuint32(0x58A79B, true), true) + memory.getfloat(memory.getuint32(0x5834C2, true), true)
	radar_x_right, _ = convertGameScreenCoordsToWindowScreenCoords(radar_x_right, radar_y)
	notify_x_size = radar_x_right - radar_x_left
	notify_x_pos = radar_x_left + 20
	notify_y_pos = radar_y + 20 - 30 -- 20 – расстояние между соседними уведомлениями; 30 – высота уведомления над радаром
end

function renderDrawCircleBox(sizex, sizey, posx, posy, radius, color)
	sizex = sizex - 2 * radius
	sizey = sizey - 2 * radius
	posx = posx + radius
	posy = posy + radius
	renderDrawBox(posx - radius, posy, radius, sizey, color)
	renderDrawBox(posx + sizex, posy, radius, sizey, color)
	renderDrawBox(posx, posy - radius, sizex, sizey + 2 * radius, color)
	for i = posx + sizex, posx + sizex + radius - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx + sizex)) * (i - (posx + sizex)))
		renderDrawBox(i, posy - dist, 1, dist, color)
	end
	for i = posx - radius, posx - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx - 1)) * (i - (posx - 1)))
		renderDrawBox(i, posy - dist, 1, dist, color)
	end
	for i = posx + sizex, posx + sizex + radius - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx + sizex)) * (i - (posx + sizex)))
		renderDrawBox(i, posy + sizey, 1, dist, color)
	end
	for i = posx - radius, posx - 1 do
		local dist = math.sqrt(radius * radius - (i - (posx - 1)) * (i - (posx - 1)))
		renderDrawBox(i, posy + sizey, 1, dist, color)
	end
end