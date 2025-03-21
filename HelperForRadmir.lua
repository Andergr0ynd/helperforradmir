script_name("HelperForRadmir")
script_version("v2.7")

local name = "[Helper] "
local color1 = "{FFD700}" 
local color2 = "{7FFFD4}"
local tag = color1 .. name .. color2 
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local new = imgui.new
local ffi = require 'ffi'
local ev = require 'samp.events'
local new, str = imgui.new, ffi.string
local socket_url = require'socket.url' -- Для кодирования URL
local vkeys = require 'vkeys'
local hotkey = require 'mimgui_hotkeys'
local faicons = require("fAwesome6")

local script_version = "2.6"
local update_time = "20.03.2025 9:00"

local tab = 1
local WinState = new.bool()

local msm = ''
local act = false
local needStop = false
local needOpen = false

local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, u8:decode[[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Andergr0ynd/helperforradmir/tree/main"
        end
    end
end

local sounds = {
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest1.mp3',
        file_name = 'arrest1.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest2.mp3',
        file_name = 'arrest2.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest3.mp3',
        file_name = 'arrest3.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest4.mp3',
        file_name = 'arrest4.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest5.mp3',
        file_name = 'arrest5.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest6.mp3',
        file_name = 'arrest6.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest7.mp3',
        file_name = 'arrest7.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest8.mp3',
        file_name = 'arrest8.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest9.mp3',
        file_name = 'arrest9.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest10.mp3',
        file_name = 'arrest10.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/sounds/arrest11.mp3',
        file_name = 'arrest11.mp3',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap01.txt',
        file_name = 'koap01.txt',
    },
        {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap02.txt',
        file_name = 'koap02.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap03.txt',
        file_name = 'koap03.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap04.txt',
        file_name = 'koap04.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap05.txt',
        file_name = 'koap05.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap06.txt',
        file_name = 'koap06.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap07.txt',
        file_name = 'koap07.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap07_2.txt',
        file_name = 'koap07_2.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap08.txt',
        file_name = 'koap08.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap09.txt',
        file_name = 'koap09.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap10.txt',
        file_name = 'koap10.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap11.txt',
        file_name = 'koap11.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap12.txt',
        file_name = 'koap12.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap13.txt',
        file_name = 'koap13.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap14.txt',
        file_name = 'koap14.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap15.txt',
        file_name = 'koap15.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap16.txt',
        file_name = 'koap16.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap17.txt',
        file_name = 'koap17.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap18.txt',
        file_name = 'koap18.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap19.txt',
        file_name = 'koap19.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap20.txt',
        file_name = 'koap20.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/koap/koap21.txt',
        file_name = 'koap21.txt',
    },
    {
        url = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/logo.png',
        file_name = 'logo.png',
    },
}

local as_action = require('moonloader').audiostream_state
local sampev = require 'lib.samp.events'

local sound_streams = {}

local ini = require 'inicfg'
local settings = ini.load({
    player = {
        name = '',
        tag = '',
        rang = '',
        department = '',
    },
    othersettings = {
        menu = 'mvd',
        music = false,
        volume = 1,
        slider = 1.5,
        not_slider = 5.5,
    },
    dop = {
        castom_mhelp = 'mhelp',
        castom_msm = 'msm',
        castom_mdoc = 'mdoc',
        castom_mdoc1 = 'mdoc1',
        castom_mdoc2 = 'mdoc2',
        castom_mdoc3 = 'mdoc3',
        castom_mdoc4 = 'mdoc4',
        castom_mdoc5 = 'mdoc5',
        castom_omondoc = 'omondoc',
        castom_msearch = 'msearch',
        castom_mcuff = 'mcuff',
        castom_muncuff = 'muncuff',
        castom_mclear = 'mclear',
        castom_msu = 'msu',
        castom_marrest = 'marrest',
        castom_mpg = 'mpg',
        castom_mtakelic = 'mtakelic',
        castom_mputpl = 'mputpl',
        castom_mticket = 'mticket',
        castom_mescort = 'mescort',
        castom_mbreak_door = 'break_door',
        castom_mattach = 'mattach',
        castom_miranda = 'miranda',
        castom_photo = 'photo',
        castom_mcheckdocs = 'mcheckdocs',
    },
    hotkey_cfg = {
        bind = '[]',
        bind2 = '[120]',
    },
}, 'MVDHelper.ini')

local sw, sh = getScreenResolution()
local mainWindow = imgui.new.bool(true)
local HotkeyCFGMsm
local HotkeyCFGMenu

local inputname = new.char[256](u8(settings.player.name))
local inputtag = new.char[256](u8(settings.player.tag))
local inputrang = new.char[256](u8(settings.player.rang))
local inputdepartment = new.char[256](u8(settings.player.department))
local menu = new.char[12](u8(settings.othersettings.menu))
local musicsettings = new.bool(settings.othersettings.music)
local volume = imgui.new.int(settings.othersettings.volume)
local slider = imgui.new.int(settings.othersettings.slider)
local not_slider = imgui.new.int(settings.othersettings.not_slider)

local castommhelp = new.char[12](u8(settings.dop.castom_mhelp))
local castommsm = new.char[12](u8(settings.dop.castom_msm))
local castommdoc = new.char[12](u8(settings.dop.castom_mdoc))
local castommdoc1 = new.char[12](u8(settings.dop.castom_mdoc1))
local castommdoc2 = new.char[12](u8(settings.dop.castom_mdoc2))
local castommdoc3 = new.char[12](u8(settings.dop.castom_mdoc3))
local castommdoc4 = new.char[12](u8(settings.dop.castom_mdoc4))
local castommdoc5 = new.char[12](u8(settings.dop.castom_mdoc5))
local castomomondoc = new.char[12](u8(settings.dop.castom_omondoc))
local castommsearch = new.char[12](u8(settings.dop.castom_msearch))
local castommcuff = new.char[12](u8(settings.dop.castom_mcuff))
local castommuncuff = new.char[12](u8(settings.dop.castom_muncuff))
local castommclear = new.char[12](u8(settings.dop.castom_mclear))
local castommsu = new.char[12](u8(settings.dop.castom_msu))
local castommarrest = new.char[12](u8(settings.dop.castom_marrest))
local castommpg = new.char[12](u8(settings.dop.castom_mpg))
local castommtakelic = new.char[12](u8(settings.dop.castom_mtakelic))
local castommputpl = new.char[12](u8(settings.dop.castom_mputpl))
local castommticket = new.char[12](u8(settings.dop.castom_mticket))
local castommescort = new.char[12](u8(settings.dop.castom_mescort))
local castommbreak_door = new.char[12](u8(settings.dop.castom_mbreak_door))
local castommattach = new.char[12](u8(settings.dop.castom_mattach))
local castommiranda = new.char[12](u8(settings.dop.castom_miranda))
local castomphoto = new.char[12](u8(settings.dop.castom_photo))
local castommcheckdocs = new.char[12](u8(settings.dop.castom_mcheckdocs))

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(525, 265), imgui.Cond.Always)
    imgui.Begin('MVDHelper | Settings', WinState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    if imgui.BeginChild('Menu', imgui.ImVec2(151, 231), true) then
    imgui.Image(imhandle, imgui.ImVec2(125, 60)) -- эта функция рендерит саму картинку
    if imgui.Button(faicons('house') .. ' Главная', imgui.ImVec2(145, 30)) then tab = 1 end
    if imgui.Button(faicons('list') .. ' Настройки', imgui.ImVec2(145, 30)) then tab = 2 end
    if imgui.Button(faicons('book') .. ' Команды', imgui.ImVec2(145, 30)) then tab = 3 end
    if imgui.Button(faicons('feather') .. ' Информация', imgui.ImVec2(145, 30)) then tab = 4 end
    imgui.EndChild()
end
    imgui.SameLine()
    if imgui.BeginChild('Function', imgui.ImVec2(380, 230), true) then
    if tab == 1 then
	imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Изменить команду | Настройки', u8'Menu', menu, 12) then end
	if imgui.Button(faicons('FLOPPY_DISK') ..' Сохранить команду', imgui.ImVec2(145, 30)) then
    settings.othersettings.menu = u8:decode(str(menu))
    ini.save(settings, 'MVDHelper.ini')
    thisScript():reload()
end
    imgui.Separator()
	imgui.Text('Громкость')
	if imgui.SliderInt("##volume", volume, 0, 10) then
	if music ~= nil then setAudioStreamVolume(music, volume.v / 10) end
	settings.othersettings.volume = volume[0]
	ini.save(settings, 'MVDHelper.ini')
end
	if imgui.Button(faicons('volume') ..' Проверка звука', imgui.ImVec2(137, 30)) then
	playRandomSound()
end
    if imgui.Checkbox('Включить звук', musicsettings) then
    settings.othersettings.music = musicsettings[0]
    ini.save(settings, 'MVDHelper.ini')
end
    imgui.Separator()
	imgui.Text('Интервал для setmark | msm')
	if imgui.SliderInt('', slider, 1, 5) then 
	settings.othersettings.slider = slider[0]
	ini.save(settings, 'MVDHelper.ini')
end
	imgui.Text('Интервал уведомлений')
	if imgui.SliderInt(' ', not_slider, 5, 10) then 
	settings.othersettings.not_slider = not_slider[0]
	ini.save(settings, 'MVDHelper.ini')
end
    imgui.Separator()
    imgui.Text('Остановка /msm')
    if HotkeyCFGMsm:ShowHotKey() then -- создаем условие, которое будет срабатывать при обновлении бинда пользователем
    settings.hotkey_cfg.bind = encodeJson(HotkeyCFGMsm:GetHotKey()) -- заносим в конфиг изменённую пользователем комбинацию клавиш
    ini.save(settings, 'MVDHelper.ini') -- не забываем конфиг сохранить
end
    imgui.Text('Открытие меню')
    if HotkeyCFGMenu:ShowHotKey() then -- создаем условие, которое будет срабатывать при обновлении бинда пользователем
    settings.hotkey_cfg.bind2 = encodeJson(HotkeyCFGMenu:GetHotKey()) -- заносим в конфиг изменённую пользователем комбинацию клавиш
    ini.save(settings, 'MVDHelper.ini') -- не забываем конфиг сохранить
end
    elseif tab == 2 then
    imgui.Text('Настройка для отыгровок')
    imgui.Separator() -- Разделяющая полоса
	imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Nick_Name', 'Имя Фамилия/Позывной', inputname, 256) then end
	imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Тэг', 'С', inputtag, 256) then end
    imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Звание', 'Сержант', inputrang, 256) then end
    imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Отдел', 'ДПС/ППС/ОМОН', inputdepartment, 256) then end
    if imgui.Button(faicons('FLOPPY_DISK') ..' Сохранить настройки', imgui.ImVec2(155, 30)) then
	settings.player.name = u8:decode(str(inputname))
	settings.player.tag = u8:decode(str(inputtag))
    settings.player.rang = u8:decode(str(inputrang))
	settings.player.department = u8:decode(str(inputdepartment))
	ini.save(settings, 'MVDHelper.ini')
    thisScript():reload()
end
    elseif tab == 3 then
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mhelp', 'Команду', castommhelp, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /msm', 'Команду', castommsm, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc', 'Команду', castommdoc, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc1', 'Команду', castommdoc1, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc2', 'Команду', castommdoc2, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc3', 'Команду', castommdoc3, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc4', 'Команду', castommdoc4, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mdoc5', 'Команду', castommdoc5, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /omondoc', 'Команду', castomomondoc, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /msearch', 'Команду', castommsearch, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mcuff', 'Команду', castommcuff, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /unmcuff', 'Команду', castommuncuff, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mclear', 'Команду', castommclear, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /msu', 'Команду', castommsu, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /marrest', 'Команду', castommarrest, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mpg', 'Команду', castommpg, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mtakelic', 'Команду', castommtakelic, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mputpl', 'Команду', castommputpl, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mticket', 'Команду', castommticket, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mescort', 'Команду', castommescort, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mbreak_door', 'Команду', castommbreak_door, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mattach', 'Команду', castommattach, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /miranda', 'Команду', castommiranda, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /photo', 'Команду', castomphoto, 12) then end
    imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Команда /mcheckdocs', 'Команду', castommcheckdocs, 12) then end
    if imgui.Button(faicons('FLOPPY_DISK') ..' Сохранить настройки', imgui.ImVec2(155, 30)) then
    settings.dop.castom_mhelp = u8:decode(str(castommhelp))
    settings.dop.castom_msm = u8:decode(str(castommsm))
    settings.dop.castom_mdoc = u8:decode(str(castommdoc))
    settings.dop.castom_mdoc1 = u8:decode(str(castommdoc1))
    settings.dop.castom_mdoc2 = u8:decode(str(castommdoc2))
    settings.dop.castom_mdoc3 = u8:decode(str(castommdoc3))
    settings.dop.castom_mdoc4 = u8:decode(str(castommdoc4))
    settings.dop.castom_mdoc5 = u8:decode(str(castommdoc5))
    settings.dop.castom_omondoc = u8:decode(str(castomomondoc))
    settings.dop.castom_msearch = u8:decode(str(castommsearch))
    settings.dop.castom_mcuff = u8:decode(str(castommcuff))
    settings.dop.castom_muncuff = u8:decode(str(castommuncuff))
    settings.dop.castom_mclear = u8:decode(str(castommclear))
    settings.dop.castom_msu = u8:decode(str(castommsu))
    settings.dop.castom_marrest = u8:decode(str(castommarrest))
    settings.dop.castom_mpg = u8:decode(str(castommpg))
    settings.dop.castom_mtakelic = u8:decode(str(castommtakelic))
    settings.dop.castom_mputpl = u8:decode(str(castommputpl))
    settings.dop.castom_mticket = u8:decode(str(castommticket))
    settings.dop.castom_mescort = u8:decode(str(castommescort))
    settings.dop.castom_mbreak_door = u8:decode(str(castommbreak_door))
    settings.dop.castom_mattach = u8:decode(str(castommattach))
    settings.dop.castom_miranda = u8:decode(str(castommiranda))
    settings.dop.castom_photo = u8:decode(str(castomphoto))
    settings.dop.castom_mcheckdocs = u8:decode(str(castommcheckdocs))
    ini.save(settings, 'MVDHelper.ini')
    thisScript():reload()
end
    elseif tab == 4 then
    imgui.Text('Версия AHK: ' ..script_version)
    imgui.Text('Последнее обновление: ' ..update_time)
    if imgui.Button(faicons('eject') .. ' Наш Discord', imgui.ImVec2(145, 30)) then -- размер указал потомучто так привычней
    os.execute("start https://discord.gg/5KDB5Nww3b")
end
    if imgui.Button(faicons('eject') .. ' Наш Boosty', imgui.ImVec2(145, 30)) then -- размер указал потомучто так привычней
    os.execute("start https://boosty.to/andergr0ynd")
        end
    if imgui.Button(faicons('rotate') .. ' Перезагрузить AHK', imgui.ImVec2(145, 30)) then -- размер указал потомучто так привычней
    thisScript():reload()
        end
    end
end
    imgui.End()
end)

function getTableUsersByUrl(url)
    local n_file, bool, users = os.getenv('TEMP')..os.time(), false, {}
    downloadUrlToFile(url, n_file, function(id, status)
        if status == 6 then bool = true end
    end)
    while not doesFileExist(n_file) do wait(0) end
    if bool then
        local file = io.open(n_file, 'r')
        for w in file:lines() do
            local n, d = w:match('(.*): (.*)')
            users[#users+1] = { name = n, date = d }
        end
        file:close()
        os.remove(n_file)
    end
    return users
end

function isAvailableUser(users, name)
    for i, k in pairs(users) do
        if k.name == name then
            local d, m, y = k.date:match('(%d+)%.(%d+)%.(%d+)')
            local time = {
                day = tonumber(d),
                isdst = true,
                wday = 0,
                yday = 0,
                year = tonumber(y),
                month = tonumber(m),
                hour = 0
            }
            if os.time(time) >= os.time() then return true end
        end
    end
    return false
end

site = 'https://raw.githubusercontent.com/Andergr0ynd/helperforradmir/refs/heads/main/users.txt'

local notifyPool = {}
local duration = 15
local quitReasons = {
    [0] = u8:decode"Краш / Тайм-аут",
    [1] = u8:decode"Вышел c сервера",
    [2] = u8:decode"Кикнут сервером"
}

function sampev.onPlayerQuit(playerId, reason)
    local result, playerChar = sampGetCharHandleBySampPlayerId(playerId)
    if not result then
        return nil
    end

    local px, py, pz = getCharCoordinates(playerChar)
    local mx, my, mz = getCharCoordinates(PLAYER_PED)

    if getDistanceBetweenCoords3d(px, py, pz, mx, my, mz) <= 50 then
        local nickname = sampGetPlayerNickname(playerId)
        local notifyMessage = table.concat({
            (u8:decode"Игрок %s(%d) покинул игру"):format(nickname, playerId),
            u8:decode"",
            quitReasons[reason] or u8:decode"Неизвестная причина",
            (u8:decode"Время: %s"):format(os.date("%H:%M:%S"))
        }, "\n")

        createQuitNotify(px, py, pz, notifyMessage)
    end
end

function sampev.onCreate3DText(id, ...)
    if notifyPool[id] ~= nil then
        notifyPool[id] = nil
    end
end

function sampev.onRemove3DTextLabel(id)
    if notifyPool[id] ~= nil then
        return false
    end
end

function createQuitNotify(x, y, z, text)
    local id = sampCreate3dText(text, 0xAAFFFFFF, x, y, z, 25, false, -1, -1)
    notifyPool[id] = os.clock() + duration

    lua_thread.create(function()
        while notifyPool[id] and os.clock() < notifyPool[id] do
            wait(0)
        end
        removeQuitNotify(id)
    end)
end

function removeQuitNotify(id)
    if notifyPool[id] == nil then
        return nil
    end

    if sampIs3dTextDefined(id) then
        sampDestroy3dText(id)
    end

    notifyPool[id] = nil
end

function onScriptTerminate(script, isQuit)
    if script == thisScript() then
        for id, time in pairs(notifyPool) do
            removeQuitNotify(id)
        end
    end
end

function main()
    while not isSampAvailable() do wait(0) end
    while sampGetCurrentServerName() == 'SA-MP' do wait(0) end
    local users = getTableUsersByUrl(site)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if not isAvailableUser(users, sampGetPlayerNickname(myid)) then
    sampAddChatMessage(tag.. u8:decode'{FF0000}AHK не активирован. Обратитесь в Support за активацией!', -1)
    print(u8:decode'AHK не активирован. Обратитесь в Support за активацией!')
    thisScript():unload()
end
    if isAvailableUser(users, sampGetPlayerNickname(myid)) then
    sampAddChatMessage(tag.. u8:decode'{32CD32}AHK успешно активирован! Можете им пользоваться!', -1)
    print(u8:decode'AHK успешно активирован! Можете им пользоваться!')
    if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    sampAddChatMessage(tag .. u8:decode'Все файлы успешно загружены и готовы к игре..', -1)
    sampAddChatMessage(tag .. u8:decode'Вы используете{FFFFFF} Helper For Radmir {969854}| {fff000} Radmir RP', -1)
    sampAddChatMessage(tag .. u8:decode'Используйте /'..settings.dop.castom_mhelp.. u8:decode' или меню на F9', -1)

    sampRegisterChatCommand(settings.dop.castom_mhelp, mhelp) 
    sampRegisterChatCommand(settings.dop.castom_msm, msm) 
    sampRegisterChatCommand(settings.dop.castom_mdoc, mdoc)
    sampRegisterChatCommand(settings.dop.castom_mdoc1, mdoc1)
    sampRegisterChatCommand(settings.dop.castom_mdoc2, mdoc2)
    sampRegisterChatCommand(settings.dop.castom_mdoc3, mdoc3)
    sampRegisterChatCommand(settings.dop.castom_mdoc4, mdoc4)
    sampRegisterChatCommand(settings.dop.castom_mdoc5, mdoc5)
    sampRegisterChatCommand(settings.dop.castom_omondoc, omondoc)
    sampRegisterChatCommand(settings.dop.castom_msearch, msearch)
    sampRegisterChatCommand(settings.dop.castom_mcuff, mcuff)
    sampRegisterChatCommand(settings.dop.castom_muncuff, muncuff)
    sampRegisterChatCommand(settings.dop.castom_mclear, mclear)
    sampRegisterChatCommand(settings.dop.castom_msu, msu)
    sampRegisterChatCommand(settings.dop.castom_marrest, marrest)
    sampRegisterChatCommand(settings.dop.castom_mpg, mpg)
    sampRegisterChatCommand(settings.dop.castom_mtakelic, mtakelic)
    sampRegisterChatCommand(settings.dop.castom_mputpl, mputpl)
    sampRegisterChatCommand(settings.dop.castom_mticket, mticket)
    sampRegisterChatCommand(settings.dop.castom_mescort, mescort)
    sampRegisterChatCommand(settings.dop.castom_mbreak_door, mbreak_door)
    sampRegisterChatCommand(settings.dop.castom_mattach, mattach)
    sampRegisterChatCommand(settings.dop.castom_miranda, miranda)
    sampRegisterChatCommand(settings.dop.castom_photo, photo)
    sampRegisterChatCommand(settings.dop.castom_mcheckdocs, mcheckdocs)
    sampRegisterChatCommand('koap1', koap1)
    sampRegisterChatCommand('koap2', koap2)
    sampRegisterChatCommand('koap3', koap3)
    sampRegisterChatCommand('koap4', koap4)
    sampRegisterChatCommand('koap5', koap5)
    sampRegisterChatCommand('koap6', koap6)
    sampRegisterChatCommand('koap7', koap7)
    sampRegisterChatCommand('koap7_2', koap7_2)
    sampRegisterChatCommand('koap8', koap8)
    sampRegisterChatCommand('koap9', koap9)
    sampRegisterChatCommand('koap10', koap10)
    sampRegisterChatCommand('koap11', koap11)
    sampRegisterChatCommand('koap12', koap12)
    sampRegisterChatCommand('koap13', koap13)
    sampRegisterChatCommand('koap14', koap14)
    sampRegisterChatCommand('koap15', koap15)
    sampRegisterChatCommand('koap16', koap16)
    sampRegisterChatCommand('koap17', koap17)
    sampRegisterChatCommand('koap18', koap18)
    sampRegisterChatCommand('koap19', koap19)
    sampRegisterChatCommand('koap20', koap20)
    sampRegisterChatCommand('koap21', koap21)
    sampRegisterChatCommand(settings.othersettings.menu, function() WinState[0] = not WinState[0] end)
    lua_thread.create(function()
    HotkeyCFGMsm = hotkey.RegisterHotKey('Hotkey CFG MSM', false, decodeJson(settings.hotkey_cfg.bind), function()
        needStop = true -- Устанавливаем флаг при нажатии клавиши
    end)
    while true do
        wait(0)
        if needStop then
            needStop = false -- Сбрасываем флаг
            if act then
                act = false
                sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка остановлена!', -1)
            end
            wait(500) -- Можно использовать wait здесь, так как это в основном потоке
        end
    end
end)

end
    if not doesDirectoryExist(getWorkingDirectory()..'\\sounds') then
    createDirectory(getWorkingDirectory()..'\\sounds')
end
    for i, v in ipairs(sounds) do
    if not doesFileExist(getWorkingDirectory()..'\\sounds\\'..v['file_name']) then
    print(u8:decode'Загружаю: ' .. v['file_name'], -1)
    downloadUrlToFile(v['url'], getWorkingDirectory()..'\\sounds\\'..v['file_name'])
end
    local stream = loadAudioStream(getWorkingDirectory()..'\\sounds\\'..v['file_name'])
    if stream then
    table.insert(sound_streams, stream)
    end
end
    lua_thread.create(function()
    HotkeyCFGMenu = hotkey.RegisterHotKey('Hotkey CFG Menu', false, decodeJson(settings.hotkey_cfg.bind2), function()
        needOpen = true -- Устанавливаем флаг при нажатии клавиши
    end)
while true do
    wait(0)
    if needOpen then
    needOpen = false
    sampShowDialog(6405, u8:decode"{006AFF}MVD Helper", u8:decode"\n \n 1 [MVD] Оследить преступника \n 2 [MVD] Представиться (Омон) \n 3 [MVD] Представиться \n 4 [MVD] Взял документы \n 5 [MVD] Взяь документы (В случае если отказывается) \n 6 [MVD] Надеть наручники \n 7 [MVD] Повести за собой \n 8 [MVD] Посадить преступника в авто \n 9 [MVD] Снять наручники \n 10 [MVD] Не вести за собой \n 11 [MVD] Высадить игрока из авто \n 12 [MVD] Посадить преступника в КПЗ \n 13 [MVD] Объявить преступника в розыск \n 14 [MVD] Выписать штраф \n 15 [MVD] Изъять права у нарушителя \n 16 [MVD] Изъять лицензию на оружие у нарушителя \n 17 [MVD] Вытащить из авто силой \n 18 [MVD] Мегафон \n 19 [MVD] Начать погоню \n 20 [MVD] Провести обыск \n 21 [MVD] Миранда \n 22 [MVD] Пробить по базе \n 23 [MVD] Эвакуатор \n \n", u8:decode("Закрыть"), nil, 2)
    while sampIsDialogActive(6405) do wait(100) end
    local _, button, list, _ = sampHasDialogRespond(6405)

    if list == 0 then
    sampAddChatMessage(tag .. u8:decode'Меню закрыто', -1)
    end      

    if list == 1 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    msm = input
    if act then
    act = false
    sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка окончена ID:'..input, -1) else
    if msm:match('%d+') then
    act = true
    sampAddChatMessage(tag.. u8:decode"{006AFF}MVD Helper: {FFFFFF}Начал отслеживать ID:" ..input, -1)
    lua_thread.create(function ()
    while act do
    wait(slider[0] * 1000)
    sampSendChat('/setmark '..input)
    end
end)
    lua_thread.create(function ()
    while act do
    wait(not_slider[0] * 1000)
    sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка идёт за: '..input, -1)
    end
end)
    else
    sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
                end
            end
        end
    end
end

    if list == 2 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'Работает сотрудник ОМОН | Позывной: '..settings.player.name..'.')
    wait(750)
    sampSendChat(u8:decode'Предьявите пожалуйста ваши документы, удостоверяющие вашу личность.')
    wait(750)
    sampSendChat(u8:decode'Если вы в течении 30 секунд не предъявите мне документы я сочту это за неподчинение!')
    wait(750)
    sampSendChat(u8:decode"/doc " ..input)
            end
        end
    end

    if list == 3 then 
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'Здравия желаю, Вас беспокоит '..settings.player.rang..' "'..settings.player.department..'" - '..settings.player.name..'.')
    wait(750)
    sampSendChat(u8:decode'/me отдал честь')
    wait(750)
    sampSendChat(u8:decode'/anim 1 7')
    wait(750)
    sampSendChat(u8:decode'/me достал из нагрудного кармана удостоверение и предъявил его')
    wait(750)
    sampSendChat(u8:decode"/doc " ..input)
    wait(750)
    sampSendChat(u8:decode'/anim 6 3')
    wait(750)
    sampSendChat(u8:decode'Будьте добры предъявить ваши документы.')
    wait(750)
    sampSendChat(u8:decode"/n /pass [id]")
           end
       end
    end
        
    if list == 4 then 
    sampSendChat(u8:decode'/me взял документы у человека напротив')
    wait(750)
    sampSendChat(u8:decode'/do Документы в руке.')
    wait(750)
    sampSendChat(u8:decode'/me осмотрел паспорт')
    wait(750)
    sampSendChat(u8:decode'/me закрыл документы')
    wait(750)
    sampSendChat(u8:decode'/do Документы закрыты.')
    wait(750)
    sampSendChat(u8:decode'/me вернул документы человеку напротив')
    wait(750)
    sampSendChat('/anim 6 3')
    end

    if list == 5 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me протянул руку затем провел по карманам легким движением руки')
    wait(700)
    sampSendChat(u8:decode'/do Проводит по карманам...')
    wait(700)
    sampSendChat(u8:decode'/me засунул руку в карман затем достал документы')
    wait(700)
    sampSendChat(u8:decode'/do Документы достаны.')
    wait(700)
    sampSendChat(u8:decode'/me взял открыл документ')
    wait(700)
    sampSendChat(u8:decode'/todo Изучает документ * Ну что ничего иного я и не ожидал наш клиент.')
    wait(700)
    sampSendChat(u8:decode'/me закрыл документ затем положил его обратно в карман')
    wait(700)
    sampSendChat(u8:decode'/do Документ в кармане. ')
    wait(700)
    sampSendChat('/checkdocs ' ..input)
           end
       end
    end

    if list == 6 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/do Наручники в руке.')
    wait(700)
    sampSendChat(u8:decode'/me надел наручники на человека напротив')
    wait(700)
    sampSendChat('/cuff ' ..input)
           end
       end
    end

    if list == 7 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me схватил задержанного за руки')
    wait(700)
    sampSendChat(u8:decode'/me заломал задержанного и повёл задержанного')
    wait(700)
    sampSendChat("/escort " ..input)
           end
       end
    end

    if list == 8 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me открыл дверь автомобиля')
    wait(700)
    sampSendChat(u8:decode'/do Дверь открыта.')
    wait(700)
    sampSendChat(u8:decode'/me посадил преступника в патрульный автомобиль')
    wait(700)
    sampSendChat("/putpl " ..input)
           end
       end
    end

    if list == 9 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me снял наручники с преступника')
    wait(700)
    sampSendChat(u8:decode'/me повесил наручники на пояс')
    wait(700)
    sampSendChat(u8:decode'/do Наручники на поясе.')
    wait(700)
    sampSendChat("/uncuff " ..input)
           end
       end
    end

    if list == 10 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me отпустил преступника')
    wait(700)
    sampSendChat(u8:decode'/do Человек свободен.')
    wait(700)
    sampSendChat("/escort " ..input)
           end
       end
    end

    if list == 11 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me открыл дверь авто')
    wait(700)
    sampSendChat(u8:decode'/me вытащил человека с авто')
    wait(700)
    sampSendChat("/ejectout " ..input)
           end
       end
    end

    if list == 12 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me открыл двери МВД')
    wait(700)
    sampSendChat(u8:decode'/do Двери открыты.')
    wait(700)
    sampSendChat(u8:decode'/me провел человека в участок')
    wait(700)
    sampSendChat(u8:decode'/do Человек в участке.')
    wait(700)
    sampSendChat("/arrest " ..input)
           end
       end
    end

    if list == 13 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me взял рацию в руки')
    wait(700)
    sampSendChat(u8:decode'/me сообщил данные о нарушителе диспетчеру')
    wait(700)
    sampSendChat(u8:decode'/do Данные сообщены.')
    wait(700)
    sampSendChat(u8:decode'/do Нарушитель объявлен в розыск.')
    wait(700)
    sampSendChat("/su " ..input)
           end
       end
    end

    if list == 14 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID, Сумму, Причину", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me достал планшет')
    wait(700)
    sampSendChat(u8:decode'/do Планшет в руке.')
    wait(700)
    sampSendChat(u8:decode'/me записал данные о нарушении и нарушителе')
    wait(700)
    sampSendChat(u8:decode'/do Данные заполнены.')
    wait(700)
    sampSendChat(u8:decode'/me отправил данные в базу данных')
    wait(700)
    sampSendChat(u8:decode'/do Данные отправлены.')
    wait(700)
    sampSendChat(u8:decode'/me убрал планшет')
    wait(700)
    sampSendChat("/ticket " ..input)
           end
       end
    end

    if list == 15 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID, Причину", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me взял права, затем переложил их в левую руку')
    wait(700)
    sampSendChat(u8:decode'/me взял блокнот и ручку в правую руку')
    wait(700)
    sampSendChat(u8:decode'/do Блокнот и ручка в руке.')
    wait(700)
    sampSendChat(u8:decode'/me записал данные о нарушении и нарушителе в блокнот')
    wait(700)
    sampSendChat(u8:decode'/do Данные заполнены.')
    wait(700)
    sampSendChat(u8:decode'/me забрал водительские права')
    wait(700)
    sampSendChat(u8:decode'/do Водительские права изъяты.')
    wait(700)
    sampSendChat("/takelic " ..input)
           end
       end
    end

    if list == 16 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me взял лицензию на оружие, затем переложил их в левую руку')
    wait(700)
    sampSendChat(u8:decode'/me взял блокнот и ручку в правую руку')
    wait(700)
    sampSendChat(u8:decode'/do Блокнот и ручка в руке.')
    wait(700)
    sampSendChat(u8:decode'/me записал данные о нарушении и нарушителе в блокнот')
    wait(700)
    sampSendChat(u8:decode'/do Данные заполнены.')
    wait(700)
    sampSendChat(u8:decode'/me забрал лицензию на оружие')
    wait(700)
    sampSendChat(u8:decode'/do Лицензия на оружие изъята.')
    wait(700)
    sampSendChat("/takelic " ..input)
           end
       end
    end

    if list == 17 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me ударил прикладом АК-47 по стеклу автомобиля')
    wait(700)
    sampSendChat(u8:decode'/do Стекло разбито.')
    wait(700)
    sampSendChat(u8:decode'/me схватил человека напротив')
    wait(700)
    sampSendChat(u8:decode'/me вытащил человека и повалил на землю')
    wait(700)
    sampSendChat("/ejectout " ..input)
                   end
                end
            end
   
    if list == 18 then
    sampSendChat(u8:decode'/me взял с плеча рацию в руки')
    wait(700)
    sampSendChat(u8:decode'/me зажал кнопку разговора на рации')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Водитель прижмитесь к обочине')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Или мы вынужденны будем открыть огонь на поражение')
    end


    if list == 19 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/me взял рацию в руки')
    wait(700)
    sampSendChat(u8:decode'/do Рация в руках.')
    wait(700)
    sampSendChat(u8:decode'/me сообщил диспетчеру, что начал погоню за нарушителем')
    wait(700)
    sampSendChat("/pg " ..input)
                    end
                end
            end

    if list == 20 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/do Перчатки с надписью "МВД" на руках.')
    wait(900)
    sampSendChat(u8:decode'/me начал ощупывать человека напротив')
    wait(900)
    sampSendChat('/anim 5 1')
    wait(900)
    sampSendChat(u8:decode'/do Верхняя часть осмотрена.')
    wait(900)
    sampSendChat(u8:decode'/me начал щупать в области ног')
    wait(900)
    sampSendChat('/anim 6 1')
    wait(900)
    sampSendChat(u8:decode'/do Нижняя часть осмотрена.')
    wait(900)
    sampSendChat(u8:decode'/me усмехнулся')
    wait(900)
    sampSendChat("/search " ..input)
                    end
                end
            end

    if list == 21 then
    sampSendChat(u8:decode'Гражданин, Вы будете задержаны до выяснения обстоятельств.')
    wait(900)
    sampSendChat(u8:decode'Если вы не согласны с задержанием, то Вы можете обратиться в суд.')
    wait(900)
    sampSendChat(u8:decode'Вы имеете право на адвоката.')
    wait(900)
    sampSendChat(u8:decode'/n ->>> /adlist')
    wait(900)
    sampSendChat(u8:decode'Советуем хранить молчание.')
    wait(900)
    sampSendChat(u8:decode'Так как все Ваши слова будут использованы против Вас.')
    end

    if list == 22 then
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'/do На человеке надеты вещи.')
    wait(900)
    sampSendChat(u8:decode'/me сорвал все лишнее, что мешает для опознания по лицу')
    wait(900)
    sampSendChat(u8:decode'/do Вещи упали на землю.')
    wait(900)
    sampSendChat(u8:decode'/do КПК в руках.')
    wait(900)
    sampSendChat(u8:decode'/me зашел в приложение МВД')
    wait(900)
    sampSendChat(u8:decode'/police_tablet ')
    wait(900)
    sampSendChat(u8:decode'/me сфотографировав человека, загрузил фото в приложении')
    wait(900)
    sampSendChat(u8:decode'/do Поиск по фото.')
    wait(900)
    sampSendChat(u8:decode'/do Человек распознан')
    wait(900)
    sampSendChat("/id "..input)
                    end
                end
            end

    if list == 23 then
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(1500)
    sampSendChat(u8:decode'/me включил бортовой компьютер Дорожно-Патрульной Службы')
    wait(1500)
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы включён.')
    wait(1500)
    sampSendChat(u8:decode'/me нажал на кнопку "Фотография" и сделал фотографию')
    wait(1500)
    sampSendChat(u8:decode'/do Фотография сохранена на базе данных Дорожно-Патрульной Службы.')
    wait(1500)
    sampSendChat(u8:decode'/me нажал на кнопку выключения бортового компьютера Дорожно-Патрульной Службы')
    wait(1500)
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(1500)
    sampSendChat(u8:decode'/me поставил эвакуатор на ручник')
    wait(1500)
    sampSendChat(u8:decode'/do Эвакуатор стоит на ручнике.')
    wait(1500)
    sampSendChat(u8:decode'/me отпустил кран эвакуатора')
    wait(1500)
    sampSendChat(u8:decode'/do Кран эвакуатора отпущен.')
    wait(1500)
    sampSendChat(u8:decode'/me зацепил транспортное средство')
    wait(1500)
    sampSendChat(u8:decode'/do Транспортное средство зацеплено.')
    wait(1500)
    sampSendChat(u8:decode'/me поднимает кран эвакуатора')
    wait(1500)
    sampSendChat(u8:decode'/do Кран эвакуатора поднят.')
    wait(1500)
    sampSendChat(u8:decode'/me эвакуирует транспортное средство')
    wait(1500)
    sampSendChat(u8:decode'/do Эвакуатор готов к движению.')
    wait(1500)
    sampSendChat(u8:decode'/me отпустил ручник на эвакуаторе')
    wait(1500)
    sampSendChat('/attach')
    wait(1000)
    sampSendChat('/c 060')
                    end
                end
            end
        end)
    while not isSampAvailable() do
    wait(100)
    end
end

function playRandomSound()
    if #sound_streams > 0 then
        local random_index = math.random(1, #sound_streams)
        local stream = sound_streams[random_index]
        setAudioStreamState(stream, as_action.PLAY)
        setAudioStreamVolume(stream, settings.othersettings.volume)
    else
        sampAddChatMessage(u8:decode'Нет доступных звуков для воспроизведения.', -1)
    end
end

function sampev.onServerMessage(color, text)
    if settings.othersettings.music then
    if text:find(u8:decode'(%w+_%w+) был доставлен в тюрьму для отбывания наказания') then
        playRandomSound()
        end
    end
end


function mhelp()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}Список команд', u8:decode' \n {FFFFFF}/mhelp - Список команд \n /mcheckdocs - В случае отказана показать документы \n /omondoc - Представиться (Омон) \n /koap1 - /koap21 - КоАП серверов \n {fe0000}(Примечание. У /koap7 есть вторая страница /koap7_2)\n {FFFFFF}/msm - Начать/Закончить слежку \n /mdoc - Показать удостоверение \n /mdoc1 - Попросить документы \n /mdoc2 - Проверка документов \n /mdoc3 - При успешной проверке документов | Отпустить \n /mdoc4 - Проверка документов на транспорт \n /mdoc5 - В случае если человек в розыске \n /msearch - Провести обыск \n /mcuff - Надеть наручники \n /muncuff - Снять наручники \n /mclear - Снять розыск \n {fe0000}Необходима опра на снятие \n {FFFFFF}/msu - Выдать звёзды \n /marrest - Арестовать преступника \n /mpg - Начать погоню \n /mtakelic - Забрать лицензии \n /mputpl - Посадить преступника в машину \n /mticket - Выдать штраф \n /mescort - Повести преступника за собой \n /mbreak_door - Выбить дверь \n /mattach - Эвакуировать транспорт на ШС \n', u8:decode'Закрыть')
    end)
end

 function msm(arg)
    msm = arg
    if act then
        act = false
        sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка окончена ID: '..msm, -1)
    else
            if msm:match('%d+') then
                act = true
        sampAddChatMessage(tag.. u8:decode"{006AFF}MVD Helper: {FFFFFF}Начал отслеживать ID: " ..msm, -1)
               
                lua_thread.create(function ()
                    while act do
                        wait(slider[0] * 1000)
                        sampSendChat('/setmark '..msm)
                    end
                end)
                lua_thread.create(function ()
                    while act do
                        wait(not_slider[0] * 1000)
                        sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка идёт за: '..msm, -1)
                    end
                end)
            else
        sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
            end
        end
    end

function omondoc(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'Работает сотрудник ОМОН | Позывной: '..settings.player.name..'.')
    wait(750)
    sampSendChat(u8:decode'Предьявите пожалуйста ваши документы, удостоверяющие вашу личность.')
    wait(750)
    sampSendChat(u8:decode'Если вы в течении 30 секунд не предъявите мне документы я сочту это за неподчинение!')
    wait(750)
    sampSendChat(u8:decode"/doc " ..id)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mdoc(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'Здравия желаю,вас беспокоит '..settings.player.rang..' '..settings.player.department..' - '..settings.player.name..'.')
    wait(900)
    sampSendChat(u8:decode'/me отдал честь')
    wait(900)
    sampSendChat(u8:decode'/anim 1 7')
    wait(900)
    sampSendChat(u8:decode'/me достал из нагрудного кармана удостоверение и предъявил его')
    wait(900)
    sampSendChat(u8:decode'/anim 6 3')
    wait(900)
    sampSendChat("/doc "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mdoc1()
    lua_thread.create(function()
    sampSendChat(u8:decode'Предъявите документы, а также отстегните ремень безопасности.')
    wait(900)
    sampSendChat(u8:decode'/n /pass [id]; /rem; /carpass [id]')
    wait(900)
    sampSendChat(u8:decode'/me достал ориентировку и сравнил ее с лицом гражданина')
    wait(900)
    sampSendChat(u8:decode'/todo Процесс проверки*При необходимости, мы задержим вас на неопределенное время.')
        end)
    end

function mdoc2()
    lua_thread.create(function()
    sampSendChat(u8:decode'/me взял документы у человека напротив')
    wait(900)
    sampSendChat(u8:decode'/do Документы в руке.')
    wait(900)
    sampSendChat(u8:decode'/me осмотрел паспорт')
    wait(900)
    sampSendChat(u8:decode'/me закрыл документы')
    wait(900)
    sampSendChat(u8:decode'/do Документы закрыты.')
    wait(900)
    sampSendChat(u8:decode'/me вернул документы человеку напротив')
    wait(900)
    sampSendChat('/anim 6 3')
        end)
    end

function mdoc3()
    lua_thread.create(function()
    sampSendChat(u8:decode'Спасибо за предоставление документов, можете быть свободны.')
        end)
    end

function mdoc4()
    lua_thread.create(function()
    sampSendChat(u8:decode'/me взял правой рукой паспорт транспортного средства.')
    wait(900)
    sampSendChat(u8:decode'/do Паспорт транспортного средства в руках.')
    wait(900)
    sampSendChat(u8:decode'/me открыл документ')
    wait(900)
    sampSendChat(u8:decode'/me посмотрел всю нужную информацию')
    wait(900)
    sampSendChat(u8:decode'/me закрыл паспорт транспортного средства')
    wait(900)
    sampSendChat(u8:decode'/me передал паспорт транспортного средства человеку напротив')
        end)
    end

function mdoc5()
    lua_thread.create(function()
    sampSendChat(u8:decode'Уважаемый гражданин, вы находитесь в федеральном розыске.')
    wait(900)
    sampSendChat(u8:decode'Не пытайтесь оказать сопроиивление, иначе это расценится как Неподчинение сотруднику МВД')
        end)
    end

function msearch(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Перчатки с надписью "МВД" на руках.')
    wait(900)
    sampSendChat(u8:decode'/me начал ощупывать человека напротив')
    wait(900)
    sampSendChat('/anim 5 1')
    wait(900)
    sampSendChat(u8:decode'/do Верхняя часть осмотрена.')
    wait(900)
    sampSendChat(u8:decode'/me начал щупать в области ног')
    wait(900)
    sampSendChat('/anim 6 1')
    wait(900)
    sampSendChat(u8:decode'/do Нижняя часть осмотрена.')
    wait(900)
    sampSendChat(u8:decode'/me усмехнулся')
    wait(900)
    sampSendChat("/search "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mcuff(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Наручники на поясе.')
    wait(900)
    sampSendChat(u8:decode'/me снял наручники с пояса')
    wait(900)
    sampSendChat(u8:decode'/do Наручники в руке.')
    wait(900)
    sampSendChat(u8:decode'/me схватил руки человека')
    wait(900)
    sampSendChat(u8:decode'/do Руки схвачены.')
    wait(900)
    sampSendChat(u8:decode'/me надел наручники на человека напротив')
    wait(900)
    sampSendChat(u8:decode'/do Наручники надеты.')
    wait(900)
    sampSendChat("/cuff "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function muncuff(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Наручники на руках у человека.')
    wait(900)
    sampSendChat(u8:decode'/me снял наручники с рук подозреваемого')
    wait(900)
    sampSendChat(u8:decode'/do Наручники сняты.')
    wait(900)
    sampSendChat(u8:decode'/me повесил наручники на пояс')
    wait(900)
    sampSendChat(u8:decode'/do Наручники на поясе.')
    wait(900)
    sampSendChat("/uncuff "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mclear(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me взял рацию в руки, затем зажал кнопку')
    wait(900)
    sampSendChat(u8:decode'/do Кнопка зажата.')
    wait(900)
    sampSendChat(u8:decode'/me сообщил данные подозреваемого диспетчеру')
    wait(900)
    sampSendChat(u8:decode'/do Данные сообщены диспетчеру.')
    wait(900)
    sampSendChat(u8:decode'/do Диспетчер: С подозреваемого снят розыск.')
    wait(900)
    sampSendChat("/clear "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function marrest(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me открыл двери МВД')
    wait(900)
    sampSendChat(u8:decode'/do Двери открыты.')
    wait(900)
    sampSendChat(u8:decode'/me провел человека в участок')
    wait(900)
    sampSendChat(u8:decode'/do Человек в участке.')
    wait(900)
    sampSendChat("/arrest "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function msu(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me взял рацию в руки, затем зажал кнопку')
    wait(900)
    sampSendChat(u8:decode'/do Кнопка зажата.')
    wait(900)
    sampSendChat(u8:decode'/me сообщил данные нарушителя диспетчеру')
    wait(900)
    sampSendChat(u8:decode'/do Нарушитель объявлен в розыск.')
    wait(900)
    sampSendChat("/su "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mpg(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Рация на поясе.')
    wait(900)
    sampSendChat(u8:decode'/me достал рацию')
    wait(900)
    sampSendChat(u8:decode'/todo Зажав кнопку*Преследую преступника, прием.')
    wait(900)
    sampSendChat("/pg "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mtakelic(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me взял планшет')
    wait(900)
    sampSendChat(u8:decode'/do Планшет в руке.')
    wait(900)
    sampSendChat(u8:decode'/me записал данные о нарушении и нарушителе')
    wait(900)
    sampSendChat(u8:decode'/do Данные обновлены.')
    wait(900)
    sampSendChat(u8:decode'/me забрал водительские удостоверение')
    wait(900)
    sampSendChat(u8:decode'/do Водительское удостоверение забрано.')
    wait(900)
    sampSendChat("/takelic "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mputpl(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me открыл дверь машины')
    wait(900)
    sampSendChat(u8:decode'/me затащил преступника в машину')
    wait(900)
    sampSendChat(u8:decode'/me закрыл дверь')
    wait(900)
    sampSendChat(u8:decode'/do Дверь закрыта.')
    wait(900)
    sampSendChat("/putpl "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mticket(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me достал планшет')
    wait(900)
    sampSendChat(u8:decode'/do Планшет в руке.')
    wait(900)
    sampSendChat(u8:decode'/me записал данные о нарушении и нарушителе')
    wait(900)
    sampSendChat(u8:decode'/do Данные заполнены.')
    wait(900)
    sampSendChat(u8:decode'/me отправил данные в базу данных')
    wait(900)
    sampSendChat(u8:decode'/do Данные отправлены.')
    wait(900)
    sampSendChat(u8:decode'/me убрал планшет')
    wait(900)
    sampSendChat("/ticket "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mescort(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me схватил задержанного за руки')
    wait(900)
    sampSendChat(u8:decode'/me заломал задержанного и повёл задержанного')
    wait(900)
    sampSendChat("/escort "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mbreak_door()
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Дверь перед "Имя"ом закрыта.')
    wait(900)
    sampSendChat(u8:decode'/me импульсивным движением ноги начал выбивать дверь')
    wait(900)
    sampSendChat(u8:decode'/do Через какой-то промежуток времени "Имя" выбыл дверь.')
    wait(900)
    sampSendChat('/break_door')
        end)
    end

function mattach()
    lua_thread.create(function()
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(1500)
    sampSendChat(u8:decode'/me включил бортовой компьютер Дорожно-Патрульной Службы')
    wait(1500)
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы включён.')
    wait(1500)
    sampSendChat(u8:decode'/me нажал на кнопку "Фотография" и сделал фотографию')
    wait(1500)
    sampSendChat(u8:decode'/do Фотография сохранена на базе данных Дорожно-Патрульной Службы.')
    wait(1500)
    sampSendChat(u8:decode'/me нажал на кнопку выключения бортового компьютера Дорожно-Патрульной Службы')
    wait(1500)
    sampSendChat(u8:decode'/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(1500)
    sampSendChat(u8:decode'/me поставил эвакуатор на ручник')
    wait(1500)
    sampSendChat(u8:decode'/do Эвакуатор стоит на ручнике.')
    wait(1500)
    sampSendChat(u8:decode'/me отпустил кран эвакуатора')
    wait(1500)
    sampSendChat(u8:decode'/do Кран эвакуатора отпущен.')
    wait(1500)
    sampSendChat(u8:decode'/me зацепил транспортное средство')
    wait(1500)
    sampSendChat(u8:decode'/do Транспортное средство зацеплено.')
    wait(1500)
    sampSendChat(u8:decode'/me поднимает кран эвакуатора')
    wait(1500)
    sampSendChat(u8:decode'/do Кран эвакуатора поднят.')
    wait(1500)
    sampSendChat(u8:decode'/me эвакуирует транспортное средство')
    wait(1500)
    sampSendChat(u8:decode'/do Эвакуатор готов к движению.')
    wait(1500)
    sampSendChat(u8:decode'/me отпустил ручник на эвакуаторе')
    wait(1500)
    sampSendChat('/attach')
    wait(1000)
    sampSendChat('/c 060')
        end)
    end


function miranda()
    lua_thread.create(function()
    sampSendChat(u8:decode'Гражданин, Вы будете задержаны до выяснения обстоятельств.')
    wait(900)
    sampSendChat(u8:decode'Если вы не согласны с задержанием, то Вы можете обратиться в суд.')
    wait(900)
    sampSendChat(u8:decode'Вы имеете право на адвоката.')
    wait(900)
    sampSendChat(u8:decode'/n ->>> /adlist')
    wait(900)
    sampSendChat(u8:decode'Советуем хранить молчание.')
    wait(900)
    sampSendChat(u8:decode'Так как все Ваши слова будут использованы против Вас.')
        end)
    end

function photo(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/do На человеке надеты вещи.')
    wait(900)
    sampSendChat(u8:decode'/me сорвал все лишнее, что мешает для опознания по лицу')
    wait(900)
    sampSendChat(u8:decode'/do Вещи упали на землю.')
    wait(900)
    sampSendChat(u8:decode'/do КПК в руках.')
    wait(900)
    sampSendChat(u8:decode'/me зашел в приложение МВД')
    wait(900)
    sampSendChat(u8:decode'/police_tablet ')
    wait(900)
    sampSendChat(u8:decode'/me сфотографировав человека, загрузил фото в приложении')
    wait(900)
    sampSendChat(u8:decode'/do Поиск по фото.')
    wait(900)
    sampSendChat(u8:decode'/do Человек распознан')
    wait(900)
    sampSendChat("/id "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mcheckdocs(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat(u8:decode'/me протянул руку затем провел по карманам легким движением руки')
    wait(900)
    sampSendChat(u8:decode'/do Проводит по карманам...')
    wait(900)
    sampSendChat(u8:decode'/me засунул руку в карман затем достал документы')
    wait(900)
    sampSendChat(u8:decode'/do Документы достаны.')
    wait(900)
    sampSendChat(u8:decode'/me взял открыл документ')
    wait(900)
    sampSendChat(u8:decode'/todo Изучает документ * Ну что ничего иного я и не ожидал наш клиент.')
    wait(900)
    sampSendChat(u8:decode'/me закрыл документ затем положил его обратно в карман')
    wait(900)
    sampSendChat(u8:decode'/do Документ в кармане.')
    wait(900)
    sampSendChat("/checkdocs "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function koap1()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap01.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 01', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap2()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap02.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 02', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap3()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap03.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 03', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap4()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap04.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 04', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap5()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap05.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 05', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap6()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap06.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 06', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap7()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap07.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 07', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap7_2()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap07_2.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 07', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap8()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap08.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 08', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap9()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap09.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 09', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap10()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap10.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 10', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap11()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap11.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 11', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap12()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap12.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 12', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap13()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap13.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 13', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap14()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap14.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 14', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap15()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap15.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 15', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap16()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap16.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 16', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap17()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap17.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 17', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap18()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap18.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 18', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap19()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap19.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 19', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap20()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap20.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 20', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function koap21()
    lua_thread.create(function()
        wait(100)
        local file = io.open(getWorkingDirectory() .. '\\sounds\\koap21.txt', 'r')
        local contents = file:read('*a')
        file:close()
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 21', u8:decode(contents), u8:decode'Закрыть', nil)
    end) -- Тут наш поток умирает :(
end

function theme()
imgui.SwitchContext()
local ImVec4 = imgui.ImVec4
imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
imgui.GetStyle().IndentSpacing = 0
imgui.GetStyle().ScrollbarSize = 10
imgui.GetStyle().GrabMinSize = 10
imgui.GetStyle().WindowBorderSize = 1
imgui.GetStyle().ChildBorderSize = 1

imgui.GetStyle().PopupBorderSize = 1
imgui.GetStyle().FrameBorderSize = 1
imgui.GetStyle().TabBorderSize = 1
imgui.GetStyle().WindowRounding = 8
imgui.GetStyle().ChildRounding = 8
imgui.GetStyle().FrameRounding = 8
imgui.GetStyle().PopupRounding = 8
imgui.GetStyle().ScrollbarRounding = 8
imgui.GetStyle().GrabRounding = 8
imgui.GetStyle().TabRounding = 8

imgui.GetStyle().Colors[imgui.Col.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00);
imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = ImVec4(1.00, 1.00, 1.00, 0.43);
imgui.GetStyle().Colors[imgui.Col.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.90);
imgui.GetStyle().Colors[imgui.Col.ChildBg]                = ImVec4(1.00, 1.00, 1.00, 0.07);
imgui.GetStyle().Colors[imgui.Col.PopupBg]                = ImVec4(0.00, 0.00, 0.00, 0.94);
imgui.GetStyle().Colors[imgui.Col.Border]                 = ImVec4(1.00, 1.00, 1.00, 0.00);
imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = ImVec4(0.00, 0.00, 1.00, 0.32);
imgui.GetStyle().Colors[imgui.Col.FrameBg]                = ImVec4(1.00, 1.00, 1.00, 0.09);
imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = ImVec4(1.00, 1.00, 1.00, 0.17);
imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = ImVec4(1.00, 1.00, 1.00, 0.26);
imgui.GetStyle().Colors[imgui.Col.TitleBg]                = ImVec4(0.00, 0.00, 0.19, 1.00);
imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = ImVec4(0.00, 0.00, 0.46, 1.00);
imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.20, 1.00);
imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = ImVec4(0.14, 0.03, 0.03, 1.00);
imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.19, 0.53);
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = ImVec4(1.00, 1.00, 1.00, 0.11);
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = ImVec4(1.00, 1.00, 1.00, 0.24);
imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = ImVec4(1.00, 1.00, 1.00, 0.35);
imgui.GetStyle().Colors[imgui.Col.CheckMark]              = ImVec4(1.00, 1.00, 1.00, 1.00);
imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = ImVec4(0.00, 0.00, 1.00, 0.34);
imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = ImVec4(0.00, 0.00, 1.00, 0.51);
imgui.GetStyle().Colors[imgui.Col.Button]                 = ImVec4(0.00, 0.00, 1.00, 0.19);
imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = ImVec4(0.00, 0.00, 1.00, 0.31);
imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = ImVec4(0.00, 0.00, 1.00, 0.46);
imgui.GetStyle().Colors[imgui.Col.Header]                 = ImVec4(0.00, 0.00, 1.00, 0.19);
imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = ImVec4(0.00, 0.00, 1.00, 0.30);
imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = ImVec4(0.00, 0.00, 1.00, 0.50);
imgui.GetStyle().Colors[imgui.Col.Separator]              = ImVec4(0.00, 0.00, 1.00, 0.41);
imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.78);
imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 1.00);
imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = ImVec4(0.00, 0.00, 0.19, 0.53);
imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = ImVec4(0.00, 0.00, 0.43, 0.75);
imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = ImVec4(0.00, 0.00, 0.53, 0.95);
imgui.GetStyle().Colors[imgui.Col.Tab]                    = ImVec4(0.00, 0.00, 1.00, 0.27);
imgui.GetStyle().Colors[imgui.Col.TabHovered]             = ImVec4(0.00, 0.00, 1.00, 0.48);
imgui.GetStyle().Colors[imgui.Col.TabActive]              = ImVec4(0.00, 0.00, 1.00, 0.60);
imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = ImVec4(0.00, 0.00, 1.00, 0.27);
imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = ImVec4(0.00, 0.00, 1.00, 0.54);
imgui.GetStyle().Colors[imgui.Col.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = ImVec4(0.00, 0.43, 1.00, 1.00);
imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = ImVec4(0.00, 0.70, 0.90, 1.00);
imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = ImVec4(0.00, 0.60, 1.00, 1.00);
imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = ImVec4(1.00, 1.00, 1.00, 0.35);
imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = ImVec4(1.00, 1.00, 0.00, 0.90);
imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = ImVec4(0.26, 0.59, 0.98, 1.00);
imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = ImVec4(1.00, 1.00, 1.00, 0.70);
imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = ImVec4(0.80, 0.80, 0.80, 0.20);
imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]      = ImVec4(0.80, 0.80, 0.80, 0.35);
end

imgui.OnInitialize(function()
    theme()
    imgui.GetIO().IniFilename = nil
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
    if doesFileExist(getWorkingDirectory()..'\\sounds\\logo.png') then -- находим необходимую картинку с названием example.png в папке moonloader/resource/
        imhandle = imgui.CreateTextureFromFile(getWorkingDirectory() .. '\\sounds\\logo.png') -- если найдена, то записываем в переменную хендл картинки
    end
end)
