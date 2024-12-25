script_name("HelperForRadmir")
script_version("v0.984")

local name = "[Helper] " -- Тэг
local color1 = "{fff000}" -- Серо-белый цвет
local color2 = "{969854}" -- Красный цвет для тэга
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

-- для msm / setmark
local msm = ''
local act = false

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

function main()
    repeat wait(0) until isSampAvailable()
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    while true do
    wait(0)

    if isKeyDown(VK_F3) then -- ALT + 1
    sampShowDialog(6405, "{006AFF}MVD Helper", "\n 1 [MVD] Представиться \n 2. [MVD] Взял документы \n 3. [MVD] Надеть наручники \n 4. [MVD] Повести за собой \n 5. [MVD] Посадить преступника в авто \n 6. [MVD] Снять наручники \n 7. [MVD] Не вести за собой \n 8. [MVD] Высадить игрока из авто \n 9. [MVD] Посадить преступника в КПЗ \n 10. [MVD] Объявить преступника в розыск \n 11. [MVD] Выписать штраф \n 12. [MVD] Изъять права у нарушителя \n 13. [MVD] Изъять лицензию на оружие у нарушителя \n 14. [MVD] Вытащить из авто силой \n 15. [MVD] Мегафон \n 16. [MVD] Начать погоню \n ", "Закрыть", nil, 2)
    while sampIsDialogActive(6405) do wait(100) end
    local _, button, list, _ = sampHasDialogRespond(6405)

    -- /doc
    if list == 0 then -- и для остальных результатов соответственно
    sampShowDialog(100, "MVD Helper", "Введите ID", "Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('Здравия желаю__, Вас беспокоит '..ini.player.rang..' "'..ini.player.department..'" - '..ini.player.name..'.')
    wait(750)
    sampSendChat('/me отдал честь')
    wait(750)
    sampSendChat('/anim 1 7')
    wait(750)
    sampSendChat('/me достал из нагрудного кармана удостоверение и предъявил его')
    wait(750)
    sampSendChat("/doc " .. id)
    wait(750)
    sampSendChat('/anim 6 3')
    wait(750)
    sampSendChat('Будьте добры предъявить ваши документы.')
    wait(750)
    sampSendChat("/n /pass [id]")
           end
       end
    end
        
    if list == 1 then -- и для остальных результатов соответственно
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

    -- /cuff
    if list == 2 then
    sampShowDialog(200, "MVD Helper", "Введите ID", "Готово", nil, 1)
    while sampIsDialogActive(200) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(200)
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

    -- /escort
    if list == 3 then
    sampShowDialog(300, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(300) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(300)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me схватил задержанного за руки')
    wait(700)
    sampSendChat('/me заломал задержанного и повёл задержанного')
    wait(700)
    sampSendChat("/escort " ..id)
           end
       end
    end

    -- /putpl
    if list == 4 then
    sampShowDialog(400, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(400) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(400)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me открыл дверь автомобиля')
    wait(700)
    sampSendChat('/do Дверь открыта.')
    wait(700)
    sampSendChat('/me посадил преступника в патрульный автомобиль')
    wait(700)
    sampSendChat("/putpl " ..id)
           end
       end
    end

    -- /uncuff
    if list == 5 then
    sampShowDialog(500, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(500) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(500)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me снял наручники с преступника')
    wait(700)
    sampSendChat('/me повесил наручники на пояс')
    wait(700)
    sampSendChat('/do Наручники на поясе.')
    wait(700)
    sampSendChat("/uncuff " ..id)
           end
       end
    end

    -- /escort
    if list == 6 then
    sampShowDialog(600, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(600) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(600)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me отпустил преступника')
    wait(700)
    sampSendChat('/do Человек свободен.')
    wait(700)
    sampSendChat("/escort " ..id)
           end
       end
    end

    -- /ejectout
    if list == 7 then
    sampShowDialog(700, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(700) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(700)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me открыл дверь авто')
    wait(700)
    sampSendChat('/me вытащил человека с авто')
    wait(700)
    sampSendChat("/ejectout " ..id)
           end
       end
    end

    -- /arrest
    if list == 8 then
    sampShowDialog(800, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(800) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(800)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me открыл двери МВД')
    wait(700)
    sampSendChat('/do Двери открыты.')
    wait(700)
    sampSendChat('/me провел человека в участок')
    wait(700)
    sampSendChat('/do Человек в участке.')
    wait(700)
    sampSendChat("/arrest " ..id)
           end
       end
    end

    -- /su
    if list == 9 then
    sampShowDialog(900, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(900) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(900)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me взял рацию в руки')
    wait(700)
    sampSendChat('/me сообщил данные о нарушителе диспетчеру')
    wait(700)
    sampSendChat('/do Данные сообщены.')
    wait(700)
    sampSendChat('/do Нарушитель объявлен в розыск.')
    wait(700)
    sampSendChat("/su " ..id)
           end
       end
    end

    -- /ticket
    if list == 10 then
    sampShowDialog(1000, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(1000) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(1000)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me достал планшет')
    wait(700)
    sampSendChat('/do Планшет в руке.')
    wait(700)
    sampSendChat('/me записал данные о нарушении и нарушителе')
    wait(700)
    sampSendChat('/do Данные заполнены.')
    wait(700)
    sampSendChat('/me отправил данные в базу данных')
    wait(700)
    sampSendChat('/do Данные отправлены.')
    wait(700)
    sampSendChat('/me убрал планшет')
    wait(700)
    sampSendChat("/ticket " ..id)
           end
       end
    end

    -- /takelic car
    if list == 11 then
    sampShowDialog(1100, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(1100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(1100)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me взял права, затем переложил их в левую руку')
    wait(700)
    sampSendChat('/me взял блокнот и ручку в правую руку')
    wait(700)
    sampSendChat('/do Блокнот и ручка в руке.')
    wait(700)
    sampSendChat('/me записал данные о нарушении и нарушителе в блокнот')
    wait(700)
    sampSendChat('/do Данные заполнены.')
    wait(700)
    sampSendChat('/me забрал водительские права')
    wait(700)
    sampSendChat('/do Водительские права изъяты.')
    wait(700)
    sampSendChat("/takelic " ..id)
           end
       end
    end

    -- /takelic gun
    if list == 12 then
    sampShowDialog(1200, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(1200) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(1200)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me взял лицензию на оружие, затем переложил их в левую руку')
    wait(700)
    sampSendChat('/me взял блокнот и ручку в правую руку')
    wait(700)
    sampSendChat('/do Блокнот и ручка в руке.')
    wait(700)
    sampSendChat('/me записал данные о нарушении и нарушителе в блокнот')
    wait(700)
    sampSendChat('/do Данные заполнены.')
    wait(700)
    sampSendChat('/me забрал лицензию на оружие')
    wait(700)
    sampSendChat('/do Лицензия на оружие изъята.')
    wait(700)
    sampSendChat("/takelic " ..id)
           end
       end
    end

    -- /ejectout
    if list == 13 then
    sampShowDialog(1300, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(1300) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(1300)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me ударил прикладом АК-47 по стеклу автомобиля')
    wait(700)
    sampSendChat('/do Стекло разбито.')
    wait(700)
    sampSendChat('/me схватил человека напротив')
    wait(700)
    sampSendChat('/me вытащил человека и повалил на землю')
    wait(700)
    sampSendChat("/ejectout " ..id)
                   end
                end
            end
   
  -- 
    if list == 14 then
    sampSendChat('/me взял с плеча рацию в руки')
    wait(700)
    sampSendChat('/me зажал кнопку разговора на рации')
    wait(700)
    sampSendChat('/m [МВД] Водитель прижмитесь к обочине')
    wait(700)
    sampSendChat('/m [МВД] Или мы вынужденны будем открыть огонь на поражение')
    end


    if list == 15 then
    sampShowDialog(1400, "MVD Helper", "Введите ид", "Готово", nil, 1)
    while sampIsDialogActive(1400) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(1400)
    if result then
    local id = tonumber(input)
    if id ~= nil then
    sampSendChat('/me взял рацию в руки')
    wait(700)
    sampSendChat('/do Рация в руках.')
    wait(700)
    sampSendChat('/me сообщил диспетчеру, что начал погоню за нарушителем')
    wait(700)
    sampSendChat("/pg " ..id)
                    end
                end
            end
        end
    end
end
