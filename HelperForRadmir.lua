script_name("HelperForRadmir")
script_version("v2.5")

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

local script_version = "2.11"
local update_time = "18.02.2025 18:00"

local tab = 1
local WinState = new.bool()

local msm = ''
local act = false

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
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/arrest1.mp3',
        file_name = 'arrest1.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/arrest2.mp3',
        file_name = 'arrest2.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/arrest3.mp3',
        file_name = 'arrest3.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/arrest4.mp3',
        file_name = 'arrest4.mp3',
    },
    {
        url = 'https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/arrest5.mp3',
        file_name = 'arrest5.mp3',
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
    },
}, 'MVDHelper.ini')

local inputname = new.char[256](u8(settings.player.name))
local inputtag = new.char[256](u8(settings.player.tag))
local inputrang = new.char[256](u8(settings.player.rang))
local inputdepartment = new.char[256](u8(settings.player.department))
local menu = new.char[12](u8(settings.othersettings.menu))
local musicsettings = new.bool(settings.othersettings.music)
local volume = imgui.new.int(settings.othersettings.volume)
local slider = imgui.new.int(settings.othersettings.slider)

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

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(525, 265), imgui.Cond.Always)
    imgui.Begin('MVDHelper | Settings', WinState, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
    if imgui.BeginChild('Menu', imgui.ImVec2(151, 231), true) then
    if imgui.Button('Главная') then tab = 1 end
    if imgui.Button('Настройки') then tab = 2 end
    if imgui.Button('Команды') then tab = 3 end
    if imgui.Button('Информация') then tab = 4 end
    imgui.EndChild()
end
    imgui.SameLine()
    if imgui.BeginChild('Function', imgui.ImVec2(380, 230), true) then
    if tab == 1 then
	imgui.SetNextItemWidth(144)if imgui.InputTextWithHint('Изменить команду | Настройки', u8'Menu', menu, 12) then end
	if imgui.Button('Сохранить команду', imgui.ImVec2(137, 30)) then
    settings.othersettings.menu = u8:decode(str(menu))
    ini.save(settings, 'MVDHelper.ini')
    thisScript():reload()
end
	imgui.Text('Громкость')
	if imgui.SliderInt("##volume", volume, 0, 10) then
	if music ~= nil then setAudioStreamVolume(music, volume.v / 10) end
	settings.othersettings.volume = volume[0]
	ini.save(settings, 'MVDHelper.ini')
end
	if imgui.Button('Проверка звука', imgui.ImVec2(137, 30)) then
	playRandomSound()
end
    if imgui.Checkbox('Включить звук', musicsettings) then
    settings.othersettings.music = musicsettings[0]
    ini.save(settings, 'MVDHelper.ini')
end
	imgui.Text('Интервал для setmark | msm')
	if imgui.SliderInt('', slider, 1, 5) then 
	settings.othersettings.slider = slider[0]
	ini.save(settings, 'MVDHelper.ini')
end
    elseif tab == 2 then
    imgui.Text('Настройка для отыгровок')
    imgui.Separator() -- Разделяющая полоса
	imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Nick_Name', 'Имя Фамилия/Позывной', inputname, 256) then end
	imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Тэг', 'С', inputtag, 256) then end
    imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Звание', 'Сержант', inputrang, 256) then end
    imgui.SetNextItemWidth(234)if imgui.InputTextWithHint('Отдел', 'ДПС/ППС/ОМОН', inputdepartment, 256) then end
    if imgui.Button('Сохранить настройки', imgui.ImVec2(137, 30)) then
	settings.player.name = u8:decode(str(inputname))
	settings.player.tag = u8:decode(str(inputtag))
    settings.player.rang = u8:decode(str(inputrang))
	settings.player.department = u8:decode(str(inputdepartment))
	ini.save(settings, 'MVDHelper.ini')
    for _,vv in pairs(script.list()) do
    if vv.filename:find('HelperForRadmirMenu.lua') then
    vv:reload()
	thisScript():reload()
                end
            end
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
    if imgui.Button('Сохранить настройки', imgui.ImVec2(137, 30)) then
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
    ini.save(settings, 'MVDHelper.ini')
    thisScript():reload()
end
    elseif tab == 4 then
    imgui.Text('Версия AHK: ' ..script_version)
    imgui.Text('Последнее обновление: ' ..update_time)
    if imgui.Button('Наш Discord', imgui.ImVec2(137, 30)) then -- размер указал потомучто так привычней
    os.execute("start https://discord.gg/5KDB5Nww3b")
end
    if imgui.Button('Наш Boosty', imgui.ImVec2(137, 30)) then -- размер указал потомучто так привычней
    os.execute("start https://boosty.to/andergr0ynd")
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
end
    if not doesDirectoryExist(getWorkingDirectory()..'\\sounds') then
    createDirectory(getWorkingDirectory()..'\\sounds')
end
    for i, v in ipairs(sounds) do
    if not doesFileExist(getWorkingDirectory()..'\\sounds\\'..v['file_name']) then
    sampAddChatMessage(u8:decode'Загружаю: ' .. v['file_name'], -1)
    downloadUrlToFile(v['url'], getWorkingDirectory()..'\\sounds\\'..v['file_name'])
end
    local stream = loadAudioStream(getWorkingDirectory()..'\\sounds\\'..v['file_name'])
    if stream then
    table.insert(sound_streams, stream)
    end
end
while true do
        wait(0)
        if isKeyDown(VK_F3) then 
    sampShowDialog(6405, u8:decode"{006AFF}MVD Helper", u8:decode"\n \n 1 [MVD] Оследить преступника \n 2 [MVD] Представиться (Омон) \n 3 [MVD] Представиться \n 4 [MVD] Взял документы \n 5 [MVD] Надеть наручники \n 6 [MVD] Повести за собой \n 7 [MVD] Посадить преступника в авто \n 8 [MVD] Снять наручники \n 9 [MVD] Не вести за собой \n 10  [MVD] Высадить игрока из авто \n 11 [MVD] Посадить преступника в КПЗ \n 12 [MVD] Объявить преступника в розыск \n 13 [MVD] Выписать штраф \n 14 [MVD] Изъять права у нарушителя \n 15 [MVD] Изъять лицензию на оружие у нарушителя \n 16 [MVD] Вытащить из авто силой \n 17 [MVD] Мегафон \n 18 [MVD] Начать погоню \n 19 [MVD] Провести обыск \n 20 [MVD] Миранда \n 21 [MVD] Пробить по базе \n 22 [MVD] Эвакуатор \n \n", u8:decode("Закрыть"), nil, 2)
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
        sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка окончена ID:'..input, -1)
    else
            if msm:match('%d+') then
                act = true
        sampAddChatMessage(tag.. u8:decode"{006AFF}MVD Helper: {FFFFFF}Начал отслеживать ID:" ..input, -1)
               
                lua_thread.create(function ()
                    while act do
                        wait(slider[0] * 1000)
                        sampSendChat('/setmark '..input)
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
    sampSendChat(u8:decode'/do Наручники в руке.')
    wait(700)
    sampSendChat(u8:decode'/me надел наручники на человека напротив')
    wait(700)
    sampSendChat('/cuff ' ..input)
           end
       end
    end

    if list == 6 then
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

    if list == 7 then
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

    if list == 8 then
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

    if list == 9 then
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

    if list == 10 then
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

    if list == 11 then
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

    if list == 12 then
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

    if list == 13 then
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

    if list == 14 then
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

    if list == 15 then
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

    if list == 16 then
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
   
    if list == 17 then
    sampSendChat(u8:decode'/me взял с плеча рацию в руки')
    wait(700)
    sampSendChat(u8:decode'/me зажал кнопку разговора на рации')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Водитель прижмитесь к обочине')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Или мы вынужденны будем открыть огонь на поражение')
    end


    if list == 18 then
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

    if list == 19 then
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

    if list == 20 then
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

    if list == 21 then
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

    if list == 22 then
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
    while not isSampAvailable() do
    wait(100)
end
    if autoupdate_loaded and enable_autoupdate and Update then
    pcall(Update.check, Update.json_url, Update.prefix, Update.url)
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
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}Список команд', u8:decode' \n {FFFFFF}/mhelp - Список команд \n /omondoc - Представиться (Омон) \n /koap1 - /koap21 - КоАП серверов \n {fe0000}(Примечание. У /koap7 есть вторая страница /koap7_2)\n {FFFFFF}/msm - Начать/Закончить слежку \n /mdoc - Показать удостоверение \n /mdoc1 - Попросить документы \n /mdoc2 - Проверка документов \n /mdoc3 - При успешной проверке документов | Отпустить \n /mdoc4 - Проверка документов на транспорт \n /mdoc5 - В случае если человек в розыске \n /msearch - Провести обыск \n /mcuff - Надеть наручники \n /muncuff - Снять наручники \n /mclear - Снять розыск \n {fe0000}Необходима опра на снятие \n {FFFFFF}/msu - Выдать звёзды \n /marrest - Арестовать преступника \n /mpg - Начать погоню \n /mtakelic - Забрать лицензии \n /mputpl - Посадить преступника в машину \n /mticket - Выдать штраф \n /mescort - Повести преступника за собой \n /mbreak_door - Выбить дверь \n /mattach - Эвакуировать транспорт на ШС \n', u8:decode'Закрыть')
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

function koap1()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 01', u8:decode' \n  \n{FFFFFF} 1.1. Управление транспортным средством без государственного регистрационного знака {B4452D} [Штраф: 5.000]\n{fbec5d}Пробег которого составляет более 150 км.\n{FFFFFF} 1.2. Отсутствие у водителя транспортного средства документов на право вождения им. {B4452D} [Штраф: 10.000]\n{FFFFFF} 1.3. Отказ предоставить сотруднику МВД водительское удостоверение. {B4452D} [Штраф: 15.000]\n{FFFFFF} 3.1. Выезд на полосу встречного движения {B4452D} [Штраф: 10.000]\n{fbec5d}Равно пересечение сплошной или двойной сплошной линии разметки.\n{FFFFFF} 3.2. Движение по полосе, предназначенной для встречного движения. {B4452D} [Штраф: 15.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 3.3. Совершение административного правонарушения {B4452D} [Штраф: 25.000, компенсация нанесенного ущерба, лишение водительского удостоверения.]\n{fbec5d}Предусмотренного частью 1 и 2 настоящей статьи, последствия которого привели к ДТП.\n{FFFFFF} 3.4. Несоблюдение требований, предписанных дорожными знаками или разметкой. {B4452D} [Штраф: 15.000]\n{FFFFFF} 4.1. Управление транспортным средством, с неисправными фарами. {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.2. Управление транспортным средством, с неисправным двигателем без аварийной сигнализации. {B4452D} [Штраф: 5.500]\n{FFFFFF} 4.3. Управление транспортным средством, с неисправными колёсами. {B4452D} [Штраф: 6.000]\n{FFFFFF} 5.1. Проезд на красный сигнал светофора. {B4452D} [Штраф: 5.000]\n{FFFFFF} 6.1. Парковка транспортного средства в неположенном месте. {B4452D} [Штраф: 7.000; эвакуация транспортного средства на штрафстоянку.]\n{FFFFFF} 6.2. Парковка транспортного средства в неположенном месте, повлекшая создание аварийной ситуации или препятствий для движения транспортных средств. \n{B4452D} [Штраф: 15.000; эвакуация транспортного средства на штрафстоянку.]\n{FFFFFF} 7.1. Движение по пешеходным дорожкам, тротуарам, газонам. {B4452D} [Штраф: 7.000]\n{FFFFFF} 7.3. Агрессивное вождение, дрифт или другие проявления опасного поведения на проезжей части. {B4452D} [Штраф: 15.000, лишение водительского удостоверения.]\n{FFFFFF} 7.5. Езда на мото-транспорте без защитного шлема. {B4452D} [Штраф: 3.000]\n{FFFFFF} 7.6. Езда на транспортном средстве с выключенным ближним светом в любое время суток. {B4452D} [Штраф: 2.500]\n{FFFFFF} 7.8. Езда на транспортном средстве с установленной плёнкой на окнах, светопропускаемость которых ниже 70%. {B4452D} [Штраф: 10.000]\n{FFFFFF} 8.2. Невыполнение законного требования сотрудника полиции об остановке транспортного средства. {B4452D} [Штраф: 25.000, лишение водительского удостоверения.]\n{FFFFFF} 10.1. Оскорбление гражданского лица. {B4452D} [Штраф: 10.000]\n{FFFFFF} 10.2. Использование нецензурной лексики в общественных местах. {B4452D} [Штраф: 5.000]\n{FFFFFF} 10.3. Хулиганство. {B4452D} [Штраф: 20.000, ст. 10 УК.]\n{FFFFFF} 10.4. Отсутствие у гражданина документов, удостоверяющих личность. {B4452D} [Штраф: 10.000]\n{FFFFFF} 11.1. Оскорбление сотрудника правоохранительных органов при исполнении. {B4452D} [Штраф: 15.000, ст. 21 УК.]\n{FFFFFF} 11.3. Неповиновение законному требования сотрудника правоохранительных органов. {B4452D} [Штраф:  20.000, ст. 23 УК.]\n', u8:decode'Закрыть')
    end) -- Тут наш поток умирает :(
end

function koap2()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 02', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.3 За разворот через сплошную линию. {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 3.1 За проезд на красный сигнал светофора. {B4452D} [Штраф: 5.000 +  Лишение водительского удостоверения]\n{FFFFFF} 4.1 За парковку ТС в неположенном месте {B4452D} [Штраф: 7.000]\n{FFFFFF} 5.1 За движение на ТС по тротуару, газону, пешеходным дорожкам и прочих, не проезжей части дорог. {B4452D} [Штраф: 7.000]\n{FFFFFF} 6.1 За игнорирование сирен спец. служб {B4452D} [Штраф: 7.000]\n{FFFFFF} 6.3 За игнорирование инспектора МВД {B4452D} [Штраф: 7.000]\n{FFFFFF} 7.1 За затруднение движения транспортным средством {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.3 За езду на ТС в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d} (Неисправное состояние - это когда машина дымится и движется без авариек)\n{FFFFFF} 8.1 За использование ненормативной лексики {B4452D} [Штраф: 8.000]\n{FFFFFF} 8.2 За оскорбление граждан {B4452D} [Штраф: 8.000]\n{FFFFFF} 8.3 За оскорбление сотрудника МВД при исполнении {B4452D} [Штраф: 15.000\n{FFFFFF} 9.1 За передвижение на ТС без регистрационного знака {B4452D} [Штраф: 5.000]\n{FFFFFF} 10.1 За агрессивное поведение на дороге, находясь в ТС, на водительском месте {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения]\n{FFFFFF} 11.1 За непристегнутый ремень безопасности во время движения на ТС {B4452D} [Штраф: 1.000]\n{FFFFFF} 11.2 За езду без шлема {B4452D} [Штраф: 3.000]\n{FFFFFF} 12.1 За движение на транспортном средстве, в котором степень светопропускания ниже 70%  {B4452D} [Штраф: 10.000]\n{FFFFFF} 13.1 За движение на ТС, без водительского удостоверения {B4452D} [Штраф: 10.000]\n{fbec5d} (C учетом того, что гражданин забыл их дома)\n{FFFFFF} 13.2 За передвижение гражданина по территории Нижегородской области без паспорта {B4452D} [Штраф: 10.000]\n{fbec5d} (C учетом того, что гражданин забыл их дома)\n{FFFFFF} 13.3 За отказ от предъявления водительского удостоверения/паспорта сотруднику МВД {B4452D} [Штраф: 15.000]\n{fbec5d} *Примечание к пунктам №13.1 - 13.3: \n{fbec5d} Сотрудник МВД обязан отыграть, что пробивает игрока через планшет\n{fbec5d} а именно: отыгрывает как он фотографирует игрока, пробивает игрока по базе и т.д.\n{FFFFFF} 17.1 За движение на ТС с выключенными фарами {B4452D} [Штраф: 2.500]\n', u8:decode'Закрыть')
    end)
end

function koap3()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 03', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 5.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.3 Пересечение двойной сплошной {B4452D} [Штраф: 8.000]\n{FFFFFF} 2.4 Разворот через двойную сплошную {B4452D} [Штраф: 10.000]\n{FFFFFF} 3.1 За проезд красного сигнала светофора {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.1. За парковку ТС в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1. За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 57.000]\n{FFFFFF} 6.1. За игнорирование сирен спец. служб {B4452D} [Штраф: 4.000]\n{FFFFFF} 7.1. За создание аварийной ситуации, в т.ч. передвижению по проезжей части пешеходом {B4452D} [Штраф: 4.000]\n{fbec5d}Пример ситуаций к 7.1 :\n{fbec5d}превышение скорости;\n{fbec5d}нарушение требований знаков и разметки;\n{fbec5d}проезд на красный сигнал светофора;\n{fbec5d}нарушение правил перевозки грузов, буксировки транспортных средств;\n{fbec5d}нарушение правил остановки, стоянки;\n{fbec5d}нарушение правил проезда пешеходных переходов;\n{fbec5d}нарушение правил проезда перекрестков;\n{fbec5d}нарушение правил обгона и встречного разъезда;\n{fbec5d}нарушение правил учебной езды;\n{fbec5d}непредоставление преимущества в движении полиции, скорой или пожарным\n{FFFFFF} 7.2. За езду на ТС в неисправном состоянии {B4452D} [Штраф: 3.000 +  Лишение водительского удостоверения.]\n{fbec5d} (Неисправное состояние - это когда машина дымится и движется без авариек)\n{FFFFFF} 9.1. За агрессивное поведение на дороге будучи находясь в ТС на водительском месте {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 10.1. За езду без номеров {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.1. За езду без пристёгнутого ремня безопасности {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.2 За езду без одетого на голову мотошлема {B4452D} [Штраф: 5.000]\n{FFFFFF} 13.1 За оскорбление сотрудника правоохранительных органов {B4452D} [Штраф: 25.000]\n{fbec5d}(Пример: Мусора)\n{FFFFFF} 14.1 За езду на авто с нанесенной пленкой светопропускаемость которой ниже 50%  {B4452D} [Штраф: 15.000]\n{FFFFFF} 20.1. Оскорбление, то есть унижение чести и достоинства другого лица, выраженное в неприличной форме {B4452D} [Штраф: от 3.000 до 9.000]\n{FFFFFF} 20.3. Нанесение побоев или совершение иных насильственных действий  {B4452D} [Штраф: от 5.000 до 30.000]\n{FFFFFF} 20.5. Потребление наркотических средств или психотропных веществ без назначения врача {B4452D} [Штраф: от 5.000 до 10.000]\n{FFFFFF} 30.2. Нарушение правил перевозки, транспортирования оружия и патронов к нему {B4452D} [Штраф: от 1.000 до 2.000]\n', u8:decode'Закрыть')
    end)
end

function koap4()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 04', u8:decode' \n\n{FFFFFF} 1.1 Нарушение правил остановки или стоянки транспортных {B4452D} [Штраф: 500]\n{FFFFFF} 1.4 Парковка ТС в неположенном месте {B4452D} [Штраф: 5.000]\n{FFFFFF} 1.5 Парковка ТС на прилегающей территории ( газон ) {B4452D} [Эвакуация транспортного средства]\n{FFFFFF} 2.1 Управление транспортным средством, не зарегистрированным в установленном порядке {B4452D} [Штраф: 5.000]\n{FFFFFF} 2.6 За агрессивное поведение на дороге находясь на водительском месте {B4452D} [Штраф: 10.000 + Лишение водительского удостоверения.]\n{FFFFFF} 3.1 Нарушение правил установки на транспортном средстве устройств для подачи специальных световых или звуковых сигналов {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.1. За езду по встречной полосе {B4452D} [Штраф: 10.000 + Лишение водительского удостоверения.]\n{FFFFFF} 5.1 За проезд красного сигнала светофора {B4452D} [Штраф: 3.000]\n{FFFFFF} 6.1. За игнорирование сирен спец. служб  {B4452D} [Штраф: 5.000]\n{FFFFFF} 8.3. За управление ТС без включенного ближнего света фар {B4452D} [Штраф: 3.000]\n{FFFFFF} 8.4. За езду на ТС в неисправном состоянии {B4452D} [Штраф: 3.000]\n{FFFFFF} 9.2 За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 10.000]\n{FFFFFF} 9.3 За езду без пристёгнутого ремня безопасности {B4452D} [Штраф: 5.000]\n{FFFFFF} 9.4 Разворот/поворот через сплошную линию разметки {B4452D} [Штраф: 15.000]\n{FFFFFF} 9.5 Разворот/поворот через двойную сплошную линию разметки {B4452D} [Штраф: 25.000]\n{FFFFFF} 9.6 Движение по прерывистым линиям разметки {B4452D} [Штраф: 15.000]\n{FFFFFF} 11.1 Управление транспортным средством, на котором установлены стекла (в том числе покрытые цветными пленками)\n{FFFFFF} светопропускание которых ниже 50% {B4452D} [Штраф: 1.000]\n{FFFFFF} 11.5. За использование нецензурной лексики/оскорблений в сторону сотрудников МВД при исполнении {B4452D} [Штраф: 5.000]\n', u8:decode'Закрыть')
    end)
end

function koap5()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 05', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.3 За разворот через сплошную линию {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.5 За проезд знака "Стоп" без полной остановки {B4452D} [Штраф: 5.000]\n{FFFFFF} 4.1 За парковку Т/С в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1 За движение Т/С по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог, {B4452D} [Штраф: 10.000]\n{FFFFFF} 6.1 За игнорирование сирен спец. служб {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.1 За затруднение движения транспортным средством {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.2 За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d}(неисправное состояние - это когда машина дымится и движется без аварийных сигналов).\n{FFFFFF} 8.1 Передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 10.000]\n{fbec5d}*Примечание: номерной знак должен быть установлен в течение 7 дней с момента приобретения Т/С.\n{FFFFFF} 8.2 За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 2.000]\n{FFFFFF} 8.3 За езду без шлема {B4452D} [Штраф: 2.000]\n{FFFFFF} 9.1 За агрессивное поведение на дороге, находясь в Т/С на водительском месте {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 10.1 За управление транспортным средством с лобовым стеклом, светопропускание которого ниже 75% {B4452D} [Штраф: 7.000]\n{FFFFFF} 10.2 За управление транспортным средством с передними боковыми стеклами, светопропускание которых ниже 70% {B4452D} [Штраф: 7.000]\n{FFFFFF} 11.1 За использование летних шин в зимний период {B4452D} [Штраф: 5.000]\n{fbec5d}[с 1 декабря по 28 (29) февраля] \n{FFFFFF} 13.1 За использование ненормативной лексики {B4452D} [Штраф: 3.000]\n{FFFFFF} 13.3 За оскорбление сотрудника МВД при исполнении {B4452D} [Штраф: 20.000]\n', u8:decode'Закрыть')
    end)
end

function koap6()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 06', u8:decode' \n \n{FFFFFF} 2.1. За езду по встречной полосе {B4452D} [Штраф: 5.000 + Лишение водительского удостоверения.]\n{FFFFFF} 3.1 За проезд красного сигнала светофора  {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.1. За парковку ТС в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1. За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог  {B4452D} [Штраф: 5.000 + Лишение водительского удостоверения.]\n{FFFFFF} 6.1. За игнорирование сирен спец. служб  {B4452D} [Штраф: 4.000]\n{FFFFFF} 7.3. За управление ТС без включенного ближнего света фар{B4452D} [Штраф: 3.000]\n{fbec5d}(В случае если игрок НЕ с hassle, перед тем как выдать штраф полицейский прописывает \n{fbec5d}/id и смотрит с чего игрок играет. Штраф выдается в случае если игрок ТОЛЬКО с RADMIR)\n{FFFFFF} 7.4. За езду на ТС в неисправном состоянии {B4452D} [Штраф: 3.000 + Лишение водительского удостоверения.]\n{FFFFFF} 9.1. За агрессивное поведение на дороге будучи находясь в ТС на водительском месте{B4452D} [Штраф: 10.000 + Лишение водительского удостоверения.]\n{FFFFFF} 10.1. За езду без номеров в течении 3-х дней {B4452D} [Штраф: 5.000]\n{fbec5d}Повторное нарушение карается лишением водительских прав.\n{FFFFFF} 11.1. За езду без пристёгнутого ремня безопасности {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.1 За езду на авто с нанесенной пленкой светопропускаемость которой ниже 50% {B4452D} [Штраф: 15.000]\n{fbec5d}Примечания: Задние стекла могут быть затонированы на все 100%\n{FFFFFF}20.1. Оскорбление, то есть унижение чести и достоинства другого лица, выраженное в неприличной форме {B4452D} [Штраф: от 1.000 до 3.000]\n{FFFFFF}20.3. Нанесение побоев или совершение иных насильственных действий, причинивших физическую боль{B4452D} [Штраф: от 5.000 до 30.000]\n{FFFFFF}20.5. Потребление наркотических средств или психотропных веществ без назначения врача {B4452D} [Штраф: от 5.000 до 10.000]\n{FFFFFF}30.2. Нарушение правил перевозки, транспортирования оружия и патронов к нему {B4452D} [Штраф: от 1.000 до 2.000]\n', u8:decode'Закрыть')
    end)
end

function koap7()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 07', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 2.3 За разворот через сплошную линию {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 2.4 За пересечение сплошной линии {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С. ]\n{fbec5d}*Примечание:\n{fbec5d}В случае аварийной ситуации на дороге, разрешается объехать ее по встречной полосе движения или развернуться \n{fbec5d}через сплошную, принудительно снизив скорость и убедиться что не создается помеха.\n{FFFFFF} 3.1 За проезд на запрещающий сигнал светофора {B4452D} [Штраф: 5.000]\n{FFFFFF} 4.1 За парковку Т/С в неположенном месте {B4452D} [Штраф: 7.500]\n{fbec5d}*Примечание:\n{fbec5d}Газоны(не считая территории частного дома)\n{fbec5d}Тротуары\n{fbec5d}Вход/выход из здания\n{fbec5d}Полоса встречного движения\n{fbec5d}Парковка на сплошной линии\n{fbec5d}Парковка авто на обочине скоростной трассы без аварийных сигналов\n{FFFFFF} 4.2 За парковку Т/С на скоростных трассах, без аварийных сигналов(обочина скоростной трассы) {B4452D} [Штраф: 10.000, а так-же эвакуация автомобиля, на штраф стоянку.]\n{FFFFFF} 5.1 За движение Т/С по тротуару, газону, пешеходных дорожкам и прочих не проезжих части дорог {B4452D} [Штраф: 10.000]\n{FFFFFF} 6.1 За игнорирование сирен/маячков спец. служб {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.1 За затруднение движения транспортным средством {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.2 За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d}*Примечание:\n{fbec5d}Езда на авто с дымящим двигателем без аварийных сигналов\n{fbec5d}Езда на авто с пробитыми колесами без аварийных сигналов\n{fbec5d}Езда на авто с разбитыми фарами без аварийных сигналов(действует с 20:00 по 5:00 по серверному времени)\n{FFFFFF} 7.3 Тонировка свето-пропускаемости менее 35% переднего(лобового стекла) {B4452D} [Штраф: 20.000]\n{FFFFFF} 7.4 Тонировка свето-пропускаемости менее 50% двух передних окон(пассажирское и водительское) {B4452D} [Штраф: 10.000]\n{fbec5d}*Примечание:\n{fbec5d}Заднее стекло разрешается тонировать в самый низкий порог свето-пропускаемости.\n{FFFFFF} 8.1 За использование не нормативной лексики {B4452D} [Штраф: 6.000]\n{FFFFFF} 8.2 За оскорбление гражданского лица {B4452D} [Штраф: 5.000]\n', u8:decode'Закрыть')
    end)
end

function koap7_2()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 07', u8:decode' \n \n{FFFFFF} 8.4 За оскорбление сотрудника при исполнении служебных обязанностей {B4452D} [Штраф: 15.000]\n{fbec5d}*Дополнение: За многократное и грубое оскорбление сотрудников, возможно лишение свободы сроком на 1 год.\n{FFFFFF} 9.1 Передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 10.000]\n{fbec5d}*Примечание:\n{fbec5d}Должны пройти сутки с момента покупки авто\n{FFFFFF} 9.2 За передвижение на любом виде авто, без документов {B4452D} [Штраф: 5.000]\n{fbec5d}*Примечание:\n{fbec5d}Если авто является личным, банды, доверенный автомобиль.\n{FFFFFF} 10.1 За агрессивное поведение на дороге будучи находясь в Т/С на водительском месте {B4452D} [Штраф: 5.000, а так-же эвакуация автомобиля, на штраф стоянку.]\n{FFFFFF} 11.1 За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 2.000]\n{FFFFFF} 11.2 За езду без шлема последует штраф {B4452D} [Штраф: 2.000]\n{FFFFFF} 13.1 За езду без включённых фар {B4452D} [Штраф: 2.500]\n{fbec5d}*Примечание:\n{fbec5d}Данный пункт действует с 20:00 вечера до 5:00 утра по серверному времени\n{FFFFFF} 14.1 При проверке сотрудник МВД может произвести обыск у гражданина, если у гражданина находят патроны и у него отсутствует лицензия(на оружие) {B4452D} [Штраф: 15.000]\n{FFFFFF} 15.1 За ношение оружия в общественных местах (зонах ZZ) {B4452D} [Штраф: 20.000]\n{fbec5d}За использование оружия в общественных местах (зонах ZZ), \n{fbec5d}включая стрельбу в воздух без причины, стрельбу по зданиям, транспортным средствам и другим объектам, следует лишение лицензии на оружие (при её наличии).\n{FFFFFF} 16.2 За оскорбление сотрудника правоохранительных органов {B4452D} [Штраф: 5.000]\n{FFFFFF} 22.1 За использование зимних шин в весенне-осенний период {B4452D} [Штраф: 8.000]\n{fbec5d}*Примечание: с 1 марта по 30 ноября.\n{FFFFFF} 22.2 За использование летних шин в зимний период {B4452D} [Штраф: 16.000]\n{fbec5d}*Примечание: с 1 декабря по 28(29) февраля.\n{FFFFFF} 23.1 За угрозы причинения вреда здоровью/смертью/убийству {B4452D} [Штраф: 25.000]\n{fbec5d}Дополнение: возможно лишение свободы, сроком на 1 год.\n{fbec5d}!ВАЖНО!\n{fbec5d}Выдача штрафа или арест, напрямую зависит от контекста сказанного.\n', u8:decode'Закрыть')
    end)
end

function koap8()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 08', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 2.3 За разворот через сплошную линию {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 3.1. За проезд красного сигнала светофора {B4452D} [Штраф: 5.000]\n{FFFFFF} 4.1 За парковку Т/С в неположенном месте {B4452D} [Штраф: 7.500]\n{FFFFFF} 4.2 За парковку Т/С на скоростных трассах, без аварийных сигналов(обочина скоростной трассы) {B4452D} [Штраф: 10.000]\n{FFFFFF} 5.2. За игнорирование сирен спец. служб {B4452D} [Штраф: 5.000]\n{FFFFFF} 5.4. За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d}(неисправное состояние - это когда машина дымится и движется без аварийных сигналов).\n{FFFFFF} 6.1. Передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 10.000]\n{FFFFFF} 7.1. За агрессивное поведение на дороге будучи находясь в Т/С на водительском месте {B4452D} [Штраф: 5.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 8.1. За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 2.000]\n{FFFFFF} 8.2. За езду без шлема {B4452D} [Штраф: 2.000]\n{FFFFFF} 9.1. За езду без включённых фар (с 20:00 - 07:00) {B4452D} [Штраф: 2.500]\n{FFFFFF} 9.2. За езду с повреждёнными фарами {B4452D} [Штраф: 3.000]\n{FFFFFF} 11.1. За езду на транспортном средстве, стекла которого имеют светопропускаемость менее чем 80%, {B4452D} [Штраф: 10.000]\n', u8:decode'Закрыть')
    end)
end

function koap9()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 09', u8:decode' \n \n{FFFFFF} 1.1. Езда на ТС без установленных на нём государственных регистрационных знаков. {B4452D} [Штраф: 8.000]\n{FFFFFF} 1.3 Игнорирование требований сотрудников ГИБДД. {B4452D} [Штраф: 15.000]\n{FFFFFF} 1.4 Передвижение на ТС, не имея при себе водительского удостоверения или отказ от его предоставления. {B4452D} [Штраф: 15.000]\n{FFFFFF} 2.1. Езда по полосе встречного движения. {B4452D} [Штраф: 10.000]\n{FFFFFF} 3.1. Проезд на запрещающий сигнал светофора. {B4452D} [Штраф: 7.000]\n{FFFFFF} 4.1. Парковка ТС на газонах, тротуарах, а также в иных не предназначенных для этого местах. {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.4 Парковка ТС в местах, прилегающих к зданиям государственных организаций, где транспортное средство закроет проезд или создаст помеху сотрудникам. {B4452D} [Штраф: 7.000]\n{FFFFFF} 5.1. Движение ТС по тротуару, газону, пешеходным дорожкам, а также в иных не предназначенных для этого местах. {B4452D} [Штраф: 10.000]\n{FFFFFF} 5.2. Разворот ТС на пешеходных переходах и ближе 10 метров от них с обеих сторон; на мостах, путепроводах, эстакадах и под ними; \n{FFFFFF}на железнодорожных переездах; в местах расположения остановочных пунктов маршрутных транспортных средств. {B4452D} [Штраф: 15.000]\n{FFFFFF} 6.1. Игнорирование видимых и звуковых сигналов спец.служб {B4452D} [Штраф: 20.000]\n{FFFFFF} 6.2. Намеренное создание препятствий в работе спец.служб {B4452D} [Штраф: 20.000 и лишение В.У.]\n{FFFFFF} 7.3. Управление ТС без включенного ближнего света фар. {B4452D} [Штраф: 2.500]\n{FFFFFF} 7.4. Езда на неисправном ТС. {B4452D} [Штраф: 4.000]\n{FFFFFF} 7.5. Агрессивная езда, опасная для других участников движения. {B4452D} [Штраф: 20.000 и лишение В.У]\n{fbec5d}(*Лишение Водительского Удостоверения на усмотрение инспектора ГИБДД)\n{FFFFFF} 9.1. Разворот/поворот через сплошную линию разметки {B4452D} [Штраф: 8.000]\n{FFFFFF} 9.2. Разворот/поворот через двойную сплошную линию разметки. {B4452D} [Штраф: 15.000]\n{FFFFFF} 9.3. Движение по прерывистым линиям разметки {B4452D} [Штраф: 4.000]\n{FFFFFF} 10.6 Езда с не пристегнутыми ремнями безопасности/без использования шлемов на мото-вело-транспорте. {B4452D} [Штраф: 3.000]\n{FFFFFF} 10.7 Если видимость через тонировку достигает 50% {B4452D} [Штраф: 5.000]\n', u8:decode'Закрыть')
    end)
end

function koap10()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 10', u8:decode' \n \n{FFFFFF} 2.1. Езда по встречной полосе. {B4452D} [Штраф: 5.000, лишение водительского удостоверения.]\n{FFFFFF} 3.1. Проезд красного сигнала светофора. {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.1. Парковка транспортного средства в неположенном месте. {B4452D} [Штраф: 5.000, эвакуация транспортного средства на штрафстоянку.]\n{FFFFFF} 5.1. Движение транспортного средства по тротуару, газону, \n{FFFFFF} пешеходным дорожкам и прочим местам, неположенным для движения автомобилей. {B4452D} [Штраф: 5.000, лишение водительского удостоверения.]\n{FFFFFF} 6.1. Игнорирование сирен спец. служб. {B4452D} [Штраф: 4.000]\n{FFFFFF} 6.3. За игнорирование требований инспектора ДПС. {B4452D} [Штраф: 15.000]\n{FFFFFF} 7.3. Управление транспортным средством без включенного ближнего света фар {B4452D} [Штраф: 3.000, за повторное нарушение штраф 6.000 рублей.]\n{FFFFFF} 7.4. Управление транспортным средством в неисправном состоянии. {B4452D} [Штраф: 3.000, за повторное нарушение штраф 6.000 рублей.]\n{FFFFFF} 5.2. Разворот ТС на пешеходных переходах и ближе 10 метров от них с обеих сторон; на мостах, путепроводах, эстакадах и под ними; \n{FFFFFF}на железнодорожных переездах; в местах расположения остановочных пунктов маршрутных транспортных средств. {B4452D} [Штраф: 15.000]\n{FFFFFF} 8.3. Оскорбление сотрудника при исполнении. {B4452D} [Штраф: 15.000]\n{FFFFFF} 9.1. Агрессивное вождение, которое может привести к ДТП. {B4452D} [Штраф: 10.000, лишение водительского удостоверения.]\n{FFFFFF} 10.1. Передвижение на транспортном средстве без регистрационного знака. {B4452D} [Штраф: 5.000, повторное нарушение - лишение водительского удостоверения.]\n{FFFFFF} 12.1. Езда на транспортном средстве без ремня безопасности. {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.2. Езда без защитного шлема на мототранспорте. {B4452D} [Штраф: 5.000]\n{FFFFFF} 13.1. Езда на транспортном средстве, стекла которого имеют степень светопропускания менее 70%. {B4452D}\n{FFFFFF} 14.1. Отказ/Нежелание гражданина предоставить сотруднику правоохранительных органов удостоверения личности\n{B4452D}Наказание: штраф 15.000, доставка в отдел для уточнения личности.\n{FFFFFF} 14.2. Отказ/Нежелание гражданина предоставить сотруднику правоохранительных органов документов на транспорт.\n{B4452D}Наказание: штраф 15.000, доставка в отдел для уточнения данных об авто.\n', u8:decode'Закрыть')
    end)
end

function koap11()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 11', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 20.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 2.3. За проезд/пересечение/разворот через сплошную линию {B4452D} [Штраф: 15.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 3.1. За проезд красного сигнала светофора {B4452D} [Штраф: 10.000]\n{FFFFFF} 4.1. За парковку Т/С в неположенном месте {B4452D} [Штраф: 11.500]\n{FFFFFF} 4.2. За движение Т/С по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.2 За игнорирование сирен спец. служб  {B4452D} [Штраф: 10.000]\n{FFFFFF} 5.3. За игнорирование сирен спец. служб, в следствии чего произошло ДТП {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С.]\n{FFFFFF} 5.4. За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 12.000]\n{fbec5d}неисправное состояние - это когда машина дымится и движется без аварийных сигналов).\n{FFFFFF} 6.1. Передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 15.000]\n{fbec5d}( Если у машины пробег меньше 20 км или с момента ее покупки не прошло 24ч, то штраф не выдается. )\n{FFFFFF} 6.2. При повтором передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 25.000]\n{FFFFFF} 7.1. За агрессивное поведение на дороге будучи находясь в Т/С на водительском месте {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С.\n{FFFFFF} 8.1. За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 7.000]\n{FFFFFF} 8.2. За езду без шлема  {B4452D} [Штраф: 7.000]\n{FFFFFF} 10.1. За езду без включённых фар ночью (22:00 - 6:00) {B4452D} [Штраф: 10.000]\n{FFFFFF} 11.1. Непредоставление преимущества в движении транспортному средству спец. служб \n{FFFFFF}с одновременно включенными проблесковым маячком синего цвета и специальным звуковым сигналом {B4452D} [Штраф: 8.000]\n{FFFFFF} 13.1. Передвижение на Т/C с износам шин 0% {B4452D} [Штраф: 10.000]\n{fbec5d}(Проверить шины нужно через Аппарат для диагностики.)\n{FFFFFF} 13.2. При повторном передвижение на Т/C с износам шин 0% {B4452D} [Штраф: 15.000]\n{FFFFFF} 14.1. Если на Т/C светопропускаемость лобового или передних стекол ниже 50% {B4452D} [Штраф: 15.000]\n{FFFFFF} 14.2. За повторное нарушение пункт 1 {B4452D} [Штраф: 25.000]\n', u8:decode'Закрыть')
    end)
end

function koap12()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 12', u8:decode' \n \n{FFFFFF} Часть 1 статья 1. Езда на ТС без установленных на нём государственных регистрационных знаков \n{FFFFFF}( номеров ) в случае, если пробег автомобиля составляет более 100 километров {B4452D} [Штраф: 10.000 и лишение ВУ.]\n{FFFFFF} Часть 1 статья 3. Передвижение на ТС, не имея при себе водительского удостоверения или отказ от его предоставления {B4452D} [Штраф: 15.000]\n{FFFFFF} Часть 2 статья 1. Отсутствие надетого ремня безопасности {B4452D} [Штраф: 6.000]\n{FFFFFF} Часть 2 статья 3. Отсутствие надетого ремня безопасности у пассажира {B4452D} [Штраф: 3.000]\n{fbec5d}Штраф выписывается водителю.\n{FFFFFF} Часть 2 статья 4. Отсутствие шлема у водителя мототранспорта {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 2 статья 5. Отсутствие шлема у пассажира мототранспорта  {B4452D} [Штраф: 10.000 - Водитель | 5.000 - Пассажир]\n{fbec5d}Штраф выписывается водителю и пассажиру.\n{FFFFFF} Часть 3 статья 5. Игнорирование видимых и звуковых сигналов спецслужб {B4452D} [Штраф: 20.000 и лишение ВУ.]\n{FFFFFF} Часть 4 статья 3. За разворот/поворот через сплошную линию  {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 4 статья 4. За разворот/поворот через двойную сплошную линию {B4452D} [Штраф: 10.000]\n{FFFFFF} Часть 5 статья 1. За парковку транспортного средства в неположенном месте {B4452D} [Штраф: 5.000]\n{fbec5d}( (в случае отсутствия водителя буксировка ТС на штрафстоянку). )\n{FFFFFF} Часть 5 статья 2. За парковку транспортного средства на газоне, тротуаре (Без включенной аварийной сигнализации) {B4452D} [Штраф: 7.000 или буксировка ТС на штрафстоянку]\n{FFFFFF} Часть 5 статья 5. Парковка близ госучреждений, вне парковочных мест {B4452D} [Штраф: 10.000 или буксировка на штрафстоянку]\n{FFFFFF} Часть 6 статья 1. Намеренное движение ТС по встречной полосе движения {B4452D} [Штраф: 20.000]\n{FFFFFF} Часть 7 статья 1. Проезд на запрещающий сигнал светофора {B4452D} [Штраф: 15.000]\n{FFFFFF} Часть 7 статья 3. Начало движения на предупреждающий (жёлтый цвет) светофора {B4452D} [Штраф: 10.000]\n{FFFFFF} Часть 7 статья 5. Объезд светофора путём пересечения сплошной/двойной сплошной линии по встречной полосе {B4452D} [Штраф: 25.000 и лишение ВУ.]\n{FFFFFF} Часть 11 статья 1. Использование тонировки 50% видимости и менее {B4452D} [Штраф: 1.000]\n{FFFFFF} Часть 11 статья 2. Использование тонировки 51% видимости и более {B4452D} [Штраф: 3.000]\n', u8:decode'Закрыть')
    end)
end

function koap13()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 13', u8:decode' \n \n{FFFFFF} Часть 2 статья 1. За езду по встречной полосе {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 2 статья 3. Остановка на встречной полосе. {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 3 статья 1. За проезд на запрещающий сигнал светофора {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 4 статья 2. За парковку транспортного средства на газоне,тротуаре (Без включенных аварийных сигналов) {B4452D} [Штраф: 10.000]\n{B4452D}[Или эвакуация транспортного средства на Штраф стоянку и штраф в размере 15.000 Рублей]\n{FFFFFF} Часть 5 статья 1. За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог. {B4452D} [Штраф: 5.000  и лишение В.У.]\n{FFFFFF} Часть 6 статья 1. Игнорирование видимых и звуковых сигналов спец.служб. {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 7 статья 3. Управление ТС без включенного ближнего света фар {B4452D} [Штраф: 3.000]\n{FFFFFF} Часть 7 статья 4. Езда на неисправном ТС {B4452D} [Штраф: 3.000]\n{FFFFFF} Часть 8 статья 1. За пересечение сплошной линии. {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 8 статья 2. За пересечение двойной сплошной линии {B4452D} [Штраф: 10.000]\n{FFFFFF} Часть 8 статья 5. За разворот/поворот через сплошную линию. {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 8 статья 6. За разворот/поворот через двойную сплошную линию. {B4452D} [Штраф: 10.000]\n{FFFFFF} Часть 9 статья 1. За агрессивное поведение на дороге будучи находясь в ТС наводительском месте {B4452D} [Штраф: 10.000 и лишение ВУ.]\n{FFFFFF} Часть 10 статья 1. Езда на ТС без установленных на нём государственных регистрационных знаков. {B4452D} [Штраф: 5.000]\n{B4452D}(Исключение: На Т/С пробег менее 30км.)\n{FFFFFF} Часть 12 статья 6. Езда с непристегнутыми ремнями безопасности/без использования шлемов на мото-вело-транспорте. {B4452D} [Штраф: 3.000]\n{FFFFFF} Часть 14 статья 1. За езду на транспортном средстве, в котором степень светопропускания ниже 70% {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 15 статья 1. Передвижение на ТС, без водительского удостоверения с учётом того, что гражданин забыл их дома {B4452D} [Штраф: 5.000]\n{FFFFFF} Часть 15 статья 2. Отказ от предъявления водительского удостоверения/паспорта сотруднику МВД наказуем статьей 8.1 УК , а так же {B4452D} [Штраф: 10.000]\n{fbec5d}Примечание:\n{fbec5d}Сотрудник МВД обязан отыграть, что пробивает игрока через планшет, а именно отыгрывает как он фоткает игрока и/или пробивает игрока по базе и т.д.\n{fbec5d}Если подобной отыгровки не будет – штраф будет считаться неверно выданным.\n{FFFFFF} Часть 17 статья 1. За езду с шинами не по сезону (весной/летом/осенью с зимними шинами, зимой с летними) {B4452D} [Штраф: 3.000]\n', u8:decode'Закрыть')
    end)
end

function koap14()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 14', u8:decode' \n \n{FFFFFF}​Статья 5.1. Оскорбление \n{FFFFFF}1. За оскорбление, которое проявляется в неприличной или несогласованной с общепринятыми моральными нормами форме {B4452D} [Штраф: 5.000]\n{FFFFFF}2. За оскорбление, содержащееся в публичном выступлении или демонстрируемое средствами массовой информации {B4452D} [Штраф: 10.000]\n{FFFFFF}3. За оскорбление, совершенное государственным служащим в связи с исполнением его обязанностей {B4452D} [Штраф: 25.000]\n{FFFFFF}Статья 8.1. Управление транспортным средством с нарушением правил установки на нем государственных регистрационных знаков\n{FFFFFF}Использование транспортного средства без установленных на предусмотренных для этого местах \n{FFFFFF}государственных регистрационных знаков в течение более 3 суток влечет {B4452D} [Штраф: 5.000]\n{FFFFFF}Статья 8.2. Управление транспортным средством водителем, не имеющим при себе документов\n{FFFFFF}Управление транспортным средством водителем без наличия при себе регистрационных документов {B4452D} [Штраф: 500]\n{FFFFFF}Статья 8.3. Нарушение правил применения ремней безопасности или мотошлемов\n{FFFFFF}Управление транспортным средством водителем или перевозка пассажиров без пристегнутых ремней безопасности, \n{FFFFFF}если транспортное средство оснащено такими ремнями, а также управление мотоциклом или мопедом или перевозка на мотоцикле пассажиров без мотошлемов {B4452D} [Штраф: 1.000]\n{FFFFFF}Статья 8.6. Проезд на запрещающий сигнал светофора\n{FFFFFF}Проезд на запрещающий сигнал светофора {B4452D} [Штраф: 1.000]\n{FFFFFF}Статья 8.8. Непредоставление преимущества в движении транспортному средству с включенными специальными световыми и звуковыми сигналами\n{FFFFFF}Непредоставление преимущества в движении транспортному средству с одновременно включенными проблесковым \n{FFFFFF}маячком синего цвета и специальным звуковым сигналом {B4452D} [Штраф: 5.000]\n{FFFFFF}Статья 8.10. Нарушение правил остановки или стоянки транспортных средств\n{FFFFFF}1. Нарушение правил остановки или стоянки транспортных средств  {B4452D} [Штраф: 500]\n{FFFFFF}2. Нарушение правил остановки или стоянки транспортных средств на проезжей части, если это приводит к созданию препятствий \n{FFFFFF}для движения других транспортных средств, за исключением вынужденной остановки {B4452D} [Штраф: 1.000]\n{FFFFFF}Статья 8.12. Управление транспортным средством с тонировкой\n{FFFFFF}Управление транспортным средством, на котором установлены стекла, светопропускание которых составляет менее 70% {B4452D} [Штраф: 1.000]\n{FFFFFF}Статья 10.1. Неповиновение законному распоряжению сотрудников полиции и военнослужащих\n{FFFFFF}Неповиновение законному распоряжению или требованию сотрудника полиции, военнослужащего в связи с исполнением ими обязанностей по охране \n{FFFFFF}общественного порядка и обеспечению безопасности, а также воспрепятствование исполнению ими служебных обязанностей {B4452D} [Штраф: 10.000]\n', u8:decode'Закрыть')
    end) 
end

function koap15()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 15', u8:decode' \n \n{FFFFFF}2.1 За езду по встречной полосе {B4452D} [Штраф: 20.000, лишение водительского удостоверения.]\n{FFFFFF}2.3 За разворот через сплошную линию {B4452D} [Штраф: 10.000, лишение водительского удостоверения.]\n{FFFFFF}2.4 За проезд через сплошную линию {B4452D} [Штраф: 5.000, лишение водительского удостоверения.]\n{FFFFFF}3.1 За проезд красного сигнала светофора {B4452D} [Штраф: 15.000]\n{FFFFFF}4.1 За парковку ТС в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF}5.1 За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 10.000]\n{FFFFFF}6.1 За игнорирование сирен спец. служб {B4452D} [Штраф: 25.000]\n{FFFFFF}6.3 За игнорирование требования сотрудника правоохранительных органов {B4452D} [Штраф: 25.000]\n{FFFFFF}7.3 За езду на ТС в неисправном состоянии {B4452D} [Штраф: 5.000]\n{FFFFFF}(неисправное состояние - это когда машина дымится и движется без авариек)\n{FFFFFF}8.1 За использование ненормативной лексики {B4452D} [Штраф: 5.000]\n{FFFFFF}8.2 За оскорбления сотрудников при исполнении {B4452D} [Штраф: 5.000]\n{FFFFFF}9.1 Передвижение на ТС без регистрационного знака {B4452D} [Штраф: 20.000]\n{fbec5d}(выдавать штраф можно если автомобиль проехал больше 55 км)\n{FFFFFF}10.1 За агрессивное поведение на дороге водитель транспортного средства {B4452D} [Штраф: 15.000, лишение водительского удостоверения.]\n{FFFFFF}11.1 За не пристегнутый ремень безопасности во время движения на ТС {B4452D} [Штраф: 1.000]\n{FFFFFF}11.2 За езду без шлема последует {B4452D} [Штраф: 1.500]\n{FFFFFF}11.3 За езду с выключенными фарами в любое время суток {B4452D} [Штраф: 2.000]\n{fbec5d}(Исключение: если машина сломана или серьезно повреждена штраф не выдаётся.)\n{FFFFFF}13.1 Управление транспортным средством, на котором установлены стекла (в том числе покрытые прозрачными цветными пленками), \n{FFFFFF}светопропускание которых не соответствует требованиям технического регламента о безопасности колесных транспортных средств (менее 70%) {B4452D} [Штраф: 5.000]\n{FFFFFF}14.1 Передвижение на ТС, без водительского удостоверения с учётом того, что гражданин забыл {B4452D} [Штраф: 10.000]\n{FFFFFF}14.2 Передвижение гражданина по территории Нижегородской области без паспорта с учётом того, что гражданин забыл документы {B4452D} [Штраф: 10.000]\n{FFFFFF}14.3 Отказ от предъявления водительского удостоверения/паспорта сотруднику МВД наказуем статьей 8.1 УК РФ, а так же штрафом {B4452D} [Штраф: 15.000]\n{FFFFFF}Примечание к пункту 14.2, 14.3 и 14.1: Сотрудник МВД обязан отыграть, что пробивает игрока через планшет, \n{FFFFFF}а именно отыгрывает как он фоткает игрока, пробивает игрока по базе и.т.д. Если подобной отыгровки не будет - штраф будет считаться неверно выданным.\n', u8:decode'Закрыть')
    end)
end

function koap16()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 16', u8:decode' \n \n{FFFFFF} 1.1 Езда на ТС без установленных на нём государственных регистрационных знаков. {B4452D} [Штраф: 8.000]\n{FFFFFF} 1.2 Езда на ТС в состоянии алкогольного опьянения. {B4452D} [Штраф: 20.000 и лишение ВУ]\n{FFFFFF} 1.3 Игнорирование требований сотрудников ГИБДД. {B4452D} [Штраф: 15.000]\n{FFFFFF} 1.4 Передвижение на ТС, не имея при себе водительского удостоверения или отказ от его предоставления. {B4452D} [Штраф: 15.000]\n{FFFFFF} 2.1 Езда по полосе встречного движения. {B4452D} [Штраф: 10.000]\n{FFFFFF} 3.1 Проезд на запрещающий сигнал светофора. {B4452D} [Штраф: 7.000]\n{FFFFFF} 4.1 Парковка ТС на газонах, тротуарах, а также в иных не предназначенных для этого местах. {B4452D} [Штраф: 3.000]\n{FFFFFF} 5.1 Движение ТС по тротуару, газону, пешеходным дорожкам, а также в иных не предназначенных для этого местах. {B4452D} [Штраф: 10.000]\n{FFFFFF} 6.1 Игнорирование видимых и звуковых сигналов спец.служб. {B4452D} [Штраф: 20.000]\n{FFFFFF} 6.3 Игнорирование видимых и звуковых сигналов спец. служб, в следствии чего произошло ДТП. {B4452D} [Штраф: 20.000 и лишение ВУ]\n{FFFFFF} 7.3 Управление ТС без включенного ближнего света фар. {B4452D} [Штраф: 2.500]\n{FFFFFF} 7.4 Езда на неисправном ТС. {B4452D} [Штраф: 4.000]\n{FFFFFF} 7.5 Агрессивная езда, опасная для других участников движения. {B4452D} [Штраф: 20.000 и лишение В.У*]\n{fbec5d}(*Лишение Водительского Удостоверения на усмотрение инспектора ГИБДД)\n{FFFFFF} 9.1 Разворот/поворот через сплошную линию разметки. {B4452D} [Штраф: 8.000]\n{FFFFFF} 9.2 Разворот/поворот через двойную сплошную линию разметки. {B4452D} [Штраф: 15.000]\n{FFFFFF} 9.3 Движение по прерывистым линиям разметки. {B4452D} [Штраф: 4.000]\n{FFFFFF} 10.6 Езда с не пристегнутыми ремнями безопасности/без использования шлемов на мото-вело-транспорте. {B4452D} [Штраф: 3.000]\n{FFFFFF} 10.7 Езда с тонировкой, несоответствующей установленным требованиям, а именно в 50 и менее процентов светопропускания. {B4452D} [Штраф: 4.000]\n{FFFFFF} 11.1 Оскорбление гражданского во время разговора или криками на всю улицу/помещение. {B4452D} [Штраф: 3.000]\n{FFFFFF} 11.2 Оскорбление сотрудника правоохранительных органов. {B4452D} [Штраф: 5.000]\n{fbec5d} При повторном оскорблении: {B4452D} [Штраф: 15.000]\n', u8:decode'Закрыть')
    end)
end

function koap17()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 17', u8:decode' \n \n{FFFFFF}  2.1 За езду по встречной полосе {B4452D} [Штраф: 20.000]\n{FFFFFF}  2.3 За разворот через сплошную линию {B4452D} [Штраф: 15.000, а так же лишение водительских прав]\n{FFFFFF}  3.1 За парковку Т/С в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF}  3.2 За движение Т/С по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 10.000]\n{FFFFFF}  4.2 За игнорирование сирен спец. служб  {B4452D} [Штраф: 15.000]\n{FFFFFF}  4.4 За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d} (неисправное состояние - это когда машина дымится и движется без аварийных сигналов).\n{FFFFFF}  5.1 Езда на ТС без установленных на нём государственных регистрационных знаков ( номеров ) в случае, \n{FFFFFF}если пробег автомобиля составляет более 100 километров {B4452D} [Штраф: 25.000]\n{FFFFFF}  6.1 За агрессивное поведение на дороге будучи находясь в Т/С на водительском месте{B4452D} [Штраф: 15.000, а так же лишение водительских прав]\n{fbec5d} ( уточнение : сильное столкновение = таран, неоднократный подрез. Езда с выездом на встречную полосу.)\n{FFFFFF}  7.1 За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 2.000]\n{FFFFFF}  7.2 За езду без шлема {B4452D} [Штраф: 2.000]\n{FFFFFF}  9.1 Непредоставление преимущества в движении транспортному средству спец. служб с одновременно включенными проблесковым маячком \n{FFFFFF} синего цвета и специальным звуковым сигналом {B4452D} [Штраф: 3.000]\n{FFFFFF}  10.1 Оскорбление гражданского во время разговора или криками на всю улицу/помещение {B4452D} [Штраф: 10.000]\n{FFFFFF}  10.2 Оскорбление сотрудника правоохранительных органов {B4452D} [Штраф: 10.000]\n{fbec5d} ( например "дурак, идиот, тупой и т.д." не считается грубым)\n{fbec5d} При повторном оскорблении в грубой форме: лишение свободы сроком на 1 год.\n{FFFFFF}  11.1 Использование тонировки на передних стеклах или лобовом стекле, светопропускаемостью от 50% (включительно) до 80% (не включительно) {B4452D} [Штраф: 1.000]\n{FFFFFF}  11.2 Использование тонировки на передних стеклах или лобовом стекле, светопропускаемостью ниже 50% (не включительно). {B4452D} [Штраф: 3.000]\n', u8:decode'Закрыть')
    end)
end

function koap18()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 18', u8:decode' \n \n{FFFFFF} 2.1. Езда по встречной полосе. {B4452D} [Штраф: 10.000]\n{FFFFFF} 3.1. Проезд красного сигнала светофора. {B4452D} [Штраф: 15.000]\n{FFFFFF} 4.1. Парковка транспортного средства в неположенном месте. {B4452D} [Штраф: Эвакуация транспортного средства на штрафстоянку]\n{FFFFFF} 5.1. Движение транспортного средства по тротуару, газону, пешеходным дорожкам и прочим местам, неположенным для движения автомобилей. {B4452D} [Штраф: 20.000]\n{FFFFFF} 6.1. Игнорирование сирен спец. служб. {B4452D} [Штраф: 25.000]\n{FFFFFF} 6.3. За игнорирование требований инспектора ДПС. {B4452D} [Штраф: 15.000]\n{FFFFFF} 7.3. Управление транспортным средством без включенного ближнего света фар. {B4452D} [Штраф: 7.500]\n{FFFFFF} 7.4. Управление транспортным средством в неисправном состоянии. {B4452D} [Штраф: 7.500]\n{FFFFFF} 8.1 Использование ненормативной лексики, оскорбление в легкой форме. {B4452D} [Штраф: 5.000]\n{FFFFFF} 8.3. Оскорбление сотрудника в легкой форме при исполнении. {B4452D} [Штраф: 20.000]\n{FFFFFF} 9.1. Агрессивное вождение, которое может привести к ДТП. {B4452D} [Штраф: 20.000]\n{FFFFFF} 10.1. Передвижение на транспортном средстве без регистрационного знака. {B4452D} [Штраф: 25.000]\n{fbec5d} Исключение: Транспортное средство приобретено в день проверки.\n{FFFFFF} 12.1. Езда на транспортном средстве без ремня безопасности. {B4452D} [Штраф: 5.500]\n{FFFFFF} 12.2. Езда без защитного шлема на мототранспорте. {B4452D} [Штраф: 5.500]\n{FFFFFF} 13.1. Езда на транспортном средстве, стекла которого имеют степень светопропускания менее 70%. {B4452D} [Штраф: 10.000]\n', u8:decode'Закрыть')
    end)
end

function koap19()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 19', u8:decode' \n \n{FFFFFF} 1.1. Оскорбление, то есть унижение чести и достоинства другого лица, выраженное в неприличной форме {B4452D} [Штраф: от 10.000 до 15.000]\n{FFFFFF} 3.1. За езду по встречной полосе последует {B4452D} [Штраф: 25.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 4.1 За проезд красного сигнала светофора {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1. За парковку, остановку, стоянку ТС в неположенном месте (тротуар, газон, жд пути, служебные парковки гос. орг) {B4452D} [Штраф: 15.000 или Эвакуация ТС]\n{FFFFFF} 5.2 Совершение нарушения правил остановки, стоянки или парковки ТС на проезжей части, что приводит к созданию препятствий для движения других автомобилей влечет наложение административного штрафа в размере 25.000 рублей/эвакуация.\n{FFFFFF} 6.1. За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 20.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 7.1 Игнорирование законной просьбы сотрудника полиции о прекращении движения транспортного средства. {B4452D} [Штраф: 50.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 8.3. За управление ТС без включенного ближнего света фар {B4452D} [Штраф: 5.000]\n{FFFFFF} 9.1. За неуплату штрафов за нарушение КоАП или за датчики фиксации в простонародье радаров {B4452D} [Штраф: 15.000]\n{FFFFFF} 10.1. За агрессивное поведение на дороге будучи находясь в ТС на водительском месте {B4452D} [Штраф: 25.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 10.2. Дрифт на проезжей части и прилегающей территории. {B4452D} [Штраф: 50.000]\n{FFFFFF} 11.1. Управление транспортным средством, которое не прошло регистрационные процедуры в соответствии с установленными правилами. \n{FFFFFF} Управление ТС без номерных знаков разрешено, если ТС имеет не более 40 км пробега. {B4452D} [Штраф: 20.000]\n{FFFFFF} 13.1. За езду без пристёгнутого ремня безопасности {B4452D} [Штраф: 10.000]\n{FFFFFF} 14.1 За езду на авто с нанесенной пленкой светопропускаемость которой ниже 50% {B4452D} [Штраф: 25.000]\n{FFFFFF} 15.1. Непредоставление преимущества в движении маршрутному транспортному средству. {B4452D} [Штраф: 15.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 15.2. Непредоставление преимущества в движении ТС с одновременно включенными проблесковым маячком синего цвета и специальным звуковым сигналом. \n{B4452D}[Штраф: 25.000, а так же лишение лицензии на управление ТС]\n{FFFFFF} 17.1. Потребление наркотических средств или психотропных веществ без назначения врача либо новых потенциально опасных псих-активных веществ\n{FFFFFF} за исключением случаев, случаев указанных в УК {B4452D} [Штраф: 25.000 - 30.000]\n{FFFFFF} 18.5. Неповиновение законному распоряжению сотрудника полиции. {B4452D} [Штраф: 25.000]\n', u8:decode'Закрыть')
    end)
end

function koap20()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 20', u8:decode' \n \n{FFFFFF} Статья 4.1 Водители транспортного средства с маячком синего или красного цвета и включенной сиреной могут отступать от требований Дорожного кодекса\n{FFFFFF} при условии обеспечения безопасности движения и нанесении минимального урона окружению {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 6.3 Двигаться по полосе встречного движения. {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 6.1.5 Двигаться на красный сигнал светофора. {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 6.1.7 Двигаться тротуарам, газонам и прочим местам, неположенным для движения. {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 6.1.8 Агрессивное вождение, которое может привести ДТП. {B4452D} [Штраф: 10.000, изъятие лицензии на вождение.]\n{FFFFFF} Статья 6.3. Водителю запрещено пересекать и занимать место в организованных колоннах или кортежах. {B4452D} [Штраф: 10.000]\n{FFFFFF} Статья 6.4. Водителю запрещено совершать опасное вождение, которое выражается в:\n{fbec5d} - невыполнение требования уступить дорогу во время перестроения (подрезание);\n{fbec5d} - несоблюдении безопасной дистанции;\n{fbec5d} - резком торможении, если такое торможение не требуется для предотвращения аварии;\n{fbec5d} - препятствовании обгону;\n{fbec5d} - нарушении сразу двух и более статей Дорожного кодекса.\n{B4452D} [Штраф: 10.000]\n{FFFFFF} Статья 7.1 Водителю запрещено движение на ТС в неисправном состоянии. {B4452D} [Штраф: 3.000, повторно 6.000]\n{FFFFFF} Статья 7.2 Водителю запрещено движение на ТС без включенного света фар в ночное время суток, с 21:00 до 6:00. {B4452D} [Штраф: 3.000, повторно 6.000]\n{FFFFFF} Статья 7.3 Водителю запрещено движение на ТС без регистрационного знака. {B4452D} [Штраф: 10.000, повторно изъятие лицензии на вождение.]\n{fbec5d} Примечание: Действует на ТС с пробегом более 100 километров.\n{FFFFFF} Статья 7.4 Водителю запрещено движение на ТС без пристёгнутого ремня безопасности. {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 7.5 Водителю запрещено движение на мототранспорте без надетого защитного шлема. {B4452D} [Штраф: 5.000]\n{FFFFFF} Статья 7.6 Водителю запрещено движение на ТС, лобовое и передние боковые стекла которого имеют степень светопропускания менее 70%. {B4452D} [Штраф: 5.000]\n{fbec5d} Примечание: Проверка светопропускания проводится тауметром, другие способы проверки запрещены.\n{FFFFFF} Статья 9.3 Остановка запрещается:\n{fbec5d} - на пешеходных переходах и тротуарах;\n{fbec5d} - на остановках общественного транспорта;\n{fbec5d} - на ж/д переездах, мостах;\n{fbec5d} - в тоннелях;\n{fbec5d} - на траве, газонах;\n{fbec5d} - на перекрестках;\n{fbec5d} - на служебных стоянках государственных учреждений.\n{B4452D} [Штраф: 5.000, эвакуация транспортного средства.]\n{fbec5d} Исключение: транспортные средства, прибывающие с целью выгрузки товара.\n{FFFFFF} Статья 9.5 Парковка транспортного средства на частной территории другого гражданина. {B4452D} [Штраф: 5.000, эвакуация транспортного средства.]\n', u8:decode'Закрыть')
    end)
end

function koap21()
    lua_thread.create(function()
        wait(100)
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 21', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000, а так же лишение лицензии на управление Т/С.\n{FFFFFF} 2.3 За разворот через сплошную линию {B4452D} [Штраф: 10.000, а так же лишение лицензии на управление Т/С.\n{FFFFFF} 3.1 За проезд на красный сигнала светофора {B4452D} [Штраф: 5.000]\n{FFFFFF} 4.1 За парковку Т/С в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1 За движение Т/С по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 10.000]\n{FFFFFF} 6.1 За игнорирование сирен спец. служб {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.2 За езду на Т/С в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d} (неисправное состояние - это когда машина дымится и движется без аварийных сигналов)\n{FFFFFF} 8.1 Передвижение на Т/С без регистрационного знака {B4452D} [Штраф: 10.000]\n{fbec5d} *Примечание: номерной знак должен быть установлен в течение 7 дней с момента приобретения Т/С.\n{FFFFFF} 8.2 За не пристегнутый ремень безопасности во время движения на Т/С {B4452D} [Штраф: 2.000]\n{FFFFFF} 8.3 За езду без шлема {B4452D} [Штраф: 2.000]\n{FFFFFF} 8.4. За езду с выключенными фарами {B4452D} [Штраф: 5.000]\n{FFFFFF} 9.1 За агрессивное поведение на дороге, находясь в Т/С на водительском месте{B4452D} [Штраф: 10.000 и лишение лицензии на управление Т/С.\n{FFFFFF} 10.1 За управление транспортным средством с лобовым стеклом, светопропускание которого ниже 75% {B4452D} [Штраф: 7.000]\n{FFFFFF} 10.2 За управление транспортным средством с передними боковыми стеклами, светопропускание которых ниже 70% {B4452D} [Штраф: 7.000]\n{FFFFFF} 11.1 За использование летних шин в зимний период [с 1 декабря по 28 (29) февраля] {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.1 В случае лишения водителя лицензий на управление Т/С за нарушение одного из пунктов КоАП, автомобиль\n{FFFFFF} на котором передвигался нарушитель, после составления протокола подлежит доставке на штрафстоянку.\n{FFFFFF} 13.1 За использование ненормативной лексики {B4452D} [Штраф: 3.000]\n{FFFFFF} 13.2 За оскорбление граждан {B4452D} [Штраф: 15.000]\n{FFFFFF} 13.3 За оскорбление сотрудника МВД при исполнении {B4452D} [Штраф: 20.000]\n', u8:decode'Закрыть')
    end)
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
end)
