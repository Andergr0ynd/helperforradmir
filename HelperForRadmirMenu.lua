script_name("HelperForRadmirMenu")
script_version("v0.983")

local name = "[Helper] " -- Тэг
local color1 = "{00ffc8}" -- Серо-белый цвет
local color2 = "{f20081}" -- Красный цвет для тэга
local tag = color1 .. name .. color2 -- Готовый тэг
local inicfg = require 'inicfg'
local key = require 'vkeys'
local vkeys = require 'vkeys'
local sampev = require 'lib.samp.events'
local encoding = require "encoding"
require 'lib.sampfuncs'
require 'lib.moonloader'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local u8 = encoding.UTF8

-- Автообновление скрипта
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, u8:decode[[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/version2.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Andergr0ynd/helperforradmir/tree/main"
        end
    end
end
-- Автообновление скрипта

-- inicfg
local inicfg = require('inicfg');
local IniFilename = 'setting.ini'
local ini = inicfg.load({
    player = {
        name = 'Иван Иванов',
        tag = 'Р',
        rang = 'Рядовой',
        department = 'ДПС'
    }
}, IniFilename);
inicfg.save(ini, IniFilename);

function main()
    repeat wait(0) until isSampAvailable()
    while true do
        wait(0)
        -- Отвечает за автообновление
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
-- Отвечает за автообновление
        if isKeyDown(18) and isKeyJustPressed(49) then -- ALT + 1
            sampShowDialog(6405, "{006AFF}MVD Helper", u8:decode"\n 1 [MVD] Представиться \n 2. [MVD] Взял документы \n 3. [MVD] Надеть наручники \n 4. [MVD] Вести за собой", "Закрыть", nil, 2)
            while sampIsDialogActive(6405) do wait(100) end
            local _, button, list, _ = sampHasDialogRespond(6405)
            if list == 0 then
                sampShowDialog(111, "заголовок", "введите ид", "кнопка 1", "кнопка 2", 1)
                while sampIsDialogActive(111) do wait(0) end
                local result, button, list, input = sampHasDialogRespond(111)
                if result then
                    local id = tonumber(input)
                    if id ~= nil then
                        sampSendChat('Здравия желаю, Вас беспокоит "" - .')
                        wait(750)
                        sampSendChat('/me отдал честь')
                        wait(750)
                        sampSendChat('/anim 1 7')
                        wait(750)
                        sampSendChat('/me достал из нагрудного кармана удостоверение и предъявил его')
                        wait(750)
                        sampSendChat('/pass ' .. id)
                        wait(750)
                        sampSendChat('/anim 6 3')
                        wait(750)
                        sampSendChat('Будьте добры предъявить ваши документы.')
                        wait(750)
                        sampSendChat("/n /pass [id]")
                    end
                end
            end
            if list == 1 then
                sampSendChat('/me взял документы у человека напротив')
                wait(750)
                sampSendChat('/do Документы в руке.')
                wait(750)
                sampSendChat('/me осмотрел паспорт')
                wait(750)
                sampSendChat('/me закрыл документы')
                wait(750)
                sampSendChat('/do Документы закрыты.')
                wait(750)
                sampSendChat('/me вернул документы человеку напротив')
                wait(750)
                sampSendChat('/anim 6 3')
            end
            if list == 2 then
                sampShowDialog(111, "заголовок", "введите ид", "кнопка 1", "кнопка 2", 1)
                while sampIsDialogActive(111) do wait(0) end
                local result, button, list, input = sampHasDialogRespond(111)
                if result then
                    local id = tonumber(input)
                    if id ~= nil then
                        sampSendChat('/do Наручники в руке.')
                        wait(700)
                        sampSendChat('/me надел наручники на человека напротив')
                        wait(700)
                        sampSendChat('/cuff ' .. id)
                    end
                end
            end
        end
    end
end