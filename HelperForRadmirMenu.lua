script_name("HelperForRadmirMenu")
script_version("v0.999")

local name = "[Helper] "
local color1 = "{FFD700}" 
local color2 = "{7FFFD4}" 
local tag = color1 .. name .. color2 
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

local inicfg = require('inicfg');
local IniFilename = 'settings.ini'
local ini = inicfg.load({
    player = {
        name = 'Иван Иванов',
        tag = 'Р',
        rang = 'Рядовой',
        department = 'ДПС'
    }
}, IniFilename);
inicfg.save(ini, IniFilename);

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
            Update.json_url = "https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/version2.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Andergr0ynd/helperforradmir/tree/main"
        end
    end
end

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
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    while sampGetCurrentServerName() == 'SA-MP' do wait(0) end
    local users = getTableUsersByUrl(site)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if not isAvailableUser(users, sampGetPlayerNickname(myid)) then
    sampAddChatMessage(tag.. u8:decode'{FF0000}Меню так-же не активировано!', -1)
    thisScript():unload()
    end
    if isAvailableUser(users, sampGetPlayerNickname(myid)) then
    sampAddChatMessage(tag.. u8:decode'{32CD32}Меню активировано!', -1)
    end
    end
    while true do
    wait(0)

    if isKeyDown(VK_F3) then 
    sampShowDialog(6405, u8:decode"{006AFF}MVD Helper", u8:decode"\n \n 1 [MVD] Представиться (Омон) \n 2 [MVD] Представиться \n 3 [MVD] Взял документы \n 4 [MVD] Надеть наручники \n 5 [MVD] Повести за собой \n 6 [MVD] Посадить преступника в авто \n 7 [MVD] Снять наручники \n 8 [MVD] Не вести за собой \n 9  [MVD] Высадить игрока из авто \n 10 [MVD] Посадить преступника в КПЗ \n 11 [MVD] Объявить преступника в розыск \n 12 [MVD] Выписать штраф \n 13 [MVD] Изъять права у нарушителя \n 14 [MVD] Изъять лицензию на оружие у нарушителя \n 15 [MVD] Вытащить из авто силой \n 16 [MVD] Мегафон \n 17 [MVD] Начать погоню \n 18 [MVD] Провести обыск \n 19 [MVD] Миранда \n 20 [MVD] Пробить по базе \n 21 [MVD] Эвакуатор", u8:decode("Закрыть"), nil, 2)
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
    sampSendChat(u8:decode'Работает сотрудник ОМОН | Позывной: '..ini.player.name..'.')
    wait(750)
    sampSendChat(u8:decode'Предьявите пожалуйста ваши документы, удостоверяющие вашу личность.')
    wait(750)
    sampSendChat(u8:decode'Если вы в течении 30 секунд не предъявите мне документы я сочту это за неподчинение!')
    wait(750)
    sampSendChat(u8:decode"/doc " ..input)
            end
        end
    end

    -- /doc
    if list == 2 then 
    sampShowDialog(100, u8:decode"MVD Helper", u8:decode"Введите ID", u8:decode"Готово", nil, 1)
    while sampIsDialogActive(100) do wait(0) end
    local result, button, list, input = sampHasDialogRespond(100)
    if result then
    if input ~= nil then
    sampSendChat(u8:decode'Здравия желаю, Вас беспокоит '..ini.player.rang..' "'..ini.player.department..'" - '..ini.player.name..'.')
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
        
    if list == 3 then 
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

    -- /cuff
    if list == 4 then
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

    -- /escort
    if list == 5 then
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

    -- /putpl
    if list == 6 then
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

    -- /uncuff
    if list == 7 then
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

    -- /escort
    if list == 8 then
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

    -- /ejectout
    if list == 9 then
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

    -- /arrest
    if list == 10 then
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

    -- /su
    if list == 11 then
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

    -- /ticket
    if list == 12 then
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

    -- /takelic car
    if list == 13 then
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

    -- /takelic gun
    if list == 14 then
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

    -- /ejectout
    if list == 15 then
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
   
  -- 
    if list == 16 then
    sampSendChat(u8:decode'/me взял с плеча рацию в руки')
    wait(700)
    sampSendChat(u8:decode'/me зажал кнопку разговора на рации')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Водитель прижмитесь к обочине')
    wait(700)
    sampSendChat(u8:decode'/m [МВД] Или мы вынужденны будем открыть огонь на поражение')
    end


    if list == 17 then
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

    if list == 18 then
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

    if list == 19 then
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

    if list == 20 then
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

    if list == 21 then
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
end
