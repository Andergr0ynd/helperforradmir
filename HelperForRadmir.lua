script_name("HelperForRadmir")
script_version("v0.986")

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
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/Andergr0ynd/helperforradmir/raw/refs/heads/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/Andergr0ynd/helperforradmir/tree/main"
        end
    end
end
-- Автообновление скрипта

-- Скачивание звуков для ареста
local sounds = {
    {
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588963987750912/arrest1.mp3?ex=6769257d&is=6767d3fd&hm=a135a5e5acef4e1ffb28884d05bceb8d2220eb289978c515b5a324ef81fa3558&',
        file_name = 'arrest1.mp3',
    },
    {
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588964390141982/arrest2.mp3?ex=6769257d&is=6767d3fd&hm=b7fd7d6161dbaccb8a6cac25bff74196af46b40e3ffb917f1f58f8f07d1275e2&',
        file_name = 'arrest2.mp3',
    },
    {
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588964780478474/arrest3.mp3?ex=6769257d&is=6767d3fd&hm=15e7b423717020562f4e16f0752e882564c7da668404559b79e54f23f3be8551&',
        file_name = 'arrest3.mp3',
    },
}

local as_action = require('moonloader').audiostream_state
local sampev = require 'lib.samp.events'

local sound_streams = {}
-- Скачивание звуков для ареста

local imgui = require 'imgui'
local mm = imgui.ImBool(false)
local key = require 'vkeys'

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

-- буферы
local namebuffer = imgui.ImBuffer(256)
local tagbuffer = imgui.ImBuffer(256)
local rangbuffer = imgui.ImBuffer(256)
local departmentbuffer = imgui.ImBuffer(256)

-- одно из основных отличий от оригинального апи
-- все переменные, значения которых записываются в ImGui по указателю, могут использоваться только через специальные типы
function imgui.OnDrawFrame()
    imgui.SetNextWindowSize(imgui.ImVec2(600, 300), imgui.Cond.FirstUseEver) -- меняем размер
    -- но для передачи значения по указателю - обязательно напрямую
    -- тут main_window_state передаётся функции imgui.Begin, чтобы можно было отследить закрытие окна нажатием на крестик
    imgui.Begin('MVD-Helper | Settings', main_window_state)
  if imgui.InputText('Имя Фамилия', namebuffer) then
    ini.player.name = u8:decode(namebuffer.v)
    inicfg.save(ini, IniFilename)
    end

      if imgui.InputText('Тэг', tagbuffer) then
    ini.player.tag = u8:decode(tagbuffer.v)
    inicfg.save(ini, IniFilename)
    end

      if imgui.InputText('Звание', rangbuffer) then
    ini.player.rang = u8:decode(rangbuffer.v)
    inicfg.save(ini, IniFilename)
    end

      if imgui.InputText('Отдел', departmentbuffer) then
    ini.player.department = u8:decode(departmentbuffer.v)
    inicfg.save(ini, IniFilename)
    end
    imgui.End()
end


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    sampAddChatMessage(tag .. u8:decode'Все файлы успешно загружены и готовы к игре..', -1)
    sampAddChatMessage(tag .. u8:decode'Вы используете{FFFFFF} Helper For Radmir {969854}| {fff000} Radmir RP', -1)
    
-- Команды
    sampRegisterChatCommand('mhelp', mhelp)
    sampRegisterChatCommand('msm', msm)
    sampRegisterChatCommand('mdoc', mdoc)
    sampRegisterChatCommand('mdoc1', mdoc1)
    sampRegisterChatCommand('mdoc2', mdoc2)
    sampRegisterChatCommand('mdoc3', mdoc3)
    sampRegisterChatCommand('mdoc4', mdoc4)
    sampRegisterChatCommand('mdoc5', mdoc5)
    sampRegisterChatCommand('msearch', msearch)
    sampRegisterChatCommand('mcuff', mcuff)
    sampRegisterChatCommand('muncuff', muncuff)
    sampRegisterChatCommand('mclear', mclear)
    sampRegisterChatCommand('msu', msu)
    sampRegisterChatCommand('marrest', marrest)
    sampRegisterChatCommand('mpg', mpg)
    sampRegisterChatCommand('mtakelic', mtakelic)
    sampRegisterChatCommand('mputpl', mputpl)
    sampRegisterChatCommand('mticket', mticket)
    sampRegisterChatCommand('mescort', mescort)
    sampRegisterChatCommand('mbreak_door', mbreak_door)
    sampRegisterChatCommand('mattach', mattach)
    sampRegisterChatCommand('mvd', function()
    mm.v = not mm.v
    imgui.Process =mm.v
  end)

-- Отвечает за работу звуков
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
-- Отвечает за работу звуков

    while not isSampAvailable() do
        wait(100)
    end

-- Отвечает за автообновление
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
-- Отвечает за автообновление
end

-- Функция для воспроизведения случайного звука
function playRandomSound()
    if #sound_streams > 0 then
        local random_index = math.random(1, #sound_streams)
        local stream = sound_streams[random_index]
        setAudioStreamState(stream, as_action.PLAY)
        setAudioStreamVolume(stream, 70)
    else
        sampAddChatMessage(u8:decode'Нет доступных звуков для воспроизведения.', -1)
    end
end

function sampev.onServerMessage(color, text)
    if text:find(u8:decode'передаёт преступника') then
        playRandomSound()
    end
end
-- Функция для воспроизведения случайного звука


-- Начало команд 
-- /mhelp | Полный список команд
function mhelp()
    lua_thread.create(function() -- Создаем новый поток
        wait(100) -- Ждём 5 секунд
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}Список КоАП', u8:decode' \n {FFFFFF}/mhelp - Просмотр списка существующих команд \n /msm - Начать отслеживать преступников \n /mdoc - Показать удостоверение \n /mdoc1 - Попросить документы \n /mdoc2 - Проверка документов \n /mdoc3 - При успешной проверке документов | Отпустить \n /mdoc4 - Проверка документов на транспорт \n /mdoc5 - В случае если человек в розыске \n /msearch - Провести обыск \n /mcuff - Надеть наручники \n /muncuff - Снять наручники \n /mclear - Снять розыск | Необходима опра на снятие \n /msu - Выдать звёзды \n /marrest - Арестовать преступника \n /mpg - Начать погоню \n /mtakelic - Забрать лицензии \n /mputpl - Посадить преступника в машину \n /mticket - Выдать штраф \n /mescort - Повести преступника за собой \n /mbreak_door - Выбить дверь \n /mattach - Эвакуировать транспорт на ШС \n', u8:decode'Закрыть')
    end) -- Тут наш поток умирает :(
end

 function msm(arg)
    msm = arg
    if act then
        act = false
        sampAddChatMessage(tag.. u8:decode'{006AFF}MVD Helper: {FFFFFF}Слежка окончена ID:'..msm, -1)
    else
            if msm:match('%d+') then
                act = true
        sampAddChatMessage(tag.. u8:decode"{006AFF}MVD Helper: {FFFFFF}Начал отслеживать ID:" ..msm, -1)
               
                lua_thread.create(function ()
                    while act do
                        wait(5000)
                        sampSendChat('/setmark '..msm)
                    end
                end)
            else
        sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
            end
        end
    end

function mdoc(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('Здравия желаю,вас беспокоит '..ini.player.rang..''..ini.player.department..' - '..ini.player.name..'.')
    wait(750)
    sampSendChat('/me отдал честь')
    wait(750)
    sampSendChat('/anim 1 7')
    wait(750)
    sampSendChat('/me достал из нагрудного кармана удостоверение и предъявил его')
    wait(750)
    sampSendChat('/anim 6 3')
    wait(750)
    sampSendChat("/doc "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mdoc1()
    lua_thread.create(function()
    sampSendChat('Предъявите документы, а также отстегните ремень безопасности.')
    wait(750)
    sampSendChat('/n /pass [id]; /rem; /carpass [id]')
    wait(750)
    sampSendChat('/me достал ориентировку и сравнил ее с лицом гражданина')
    wait(750)
    sampSendChat('/todo Процесс проверки*При необходимости, мы задержим вас на неопределенное время.')
        end)
    end

function mdoc2()
    lua_thread.create(function()
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
        end)
    end

function mdoc3()
    lua_thread.create(function()
    sampSendChat('Спасибо за предоставление документов, можете быть свободны.')
        end)
    end

function mdoc4()
    lua_thread.create(function()
    sampSendChat('/me взял правой рукой паспорт транспортного средства.')
    wait(750)
    sampSendChat('/do Паспорт транспортного средства в руках.')
    wait(750)
    sampSendChat('/me открыл документ')
    wait(750)
    sampSendChat('/me посмотрел всю нужную информацию')
    wait(750)
    sampSendChat('/me закрыл паспорт транспортного средства')
    wait(750)
    sampSendChat('/me передал паспорт транспортного средства человеку напротив')
        end)
    end

function mdoc5()
    lua_thread.create(function()
    sampSendChat('Уважаемый гражданин, вы находитесь в федеральном розыске.')
    wait(750)
    sampSendChat('Не пытайтесь оказать сопроиивление, иначе это расценится как Неподчинение сотруднику МВД')
        end)
    end

function msearch(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/do Перчатки с надписью "МВД" на руках.')
    wait(750)
    sampSendChat('/me начал ощупывать человека напротив')
    wait(750)
    sampSendChat('/anim 5 1')
    wait(750)
    sampSendChat('/do Верхняя часть осмотрена.')
    wait(750)
    sampSendChat('/me начал щупать в области ног')
    wait(750)
    sampSendChat('/anim 6 1')
    wait(750)
    sampSendChat('/do Нижняя часть осмотрена.')
    wait(750)
    sampSendChat('/me усмехнулся')
    wait(750)
    sampSendChat("/search "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mcuff(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/do Наручники на поясе.')
    wait(750)
    sampSendChat('/me снял наручники с пояса')
    wait(750)
    sampSendChat('/do Наручники в руке.')
    wait(750)
    sampSendChat('/me схватил руки человека')
    wait(750)
    sampSendChat('/do Руки схвачены.')
    wait(750)
    sampSendChat('/me надел наручники на человека напротив')
    wait(750)
    sampSendChat('/do Наручники надеты.')
    wait(750)
    sampSendChat("/cuff "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function muncuff(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/do Наручники на руках у человека.')
    wait(750)
    sampSendChat('/me снял наручники с рук подозреваемого')
    wait(750)
    sampSendChat('/do Наручники сняты.')
    wait(750)
    sampSendChat('/me повесил наручники на пояс')
    wait(750)
    sampSendChat('/do Наручники на поясе.')
    wait(750)
    sampSendChat("/uncuff "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mclear(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me взял рацию в руки, затем зажал кнопку')
    wait(750)
    sampSendChat('/do Кнопка зажата.')
    wait(750)
    sampSendChat('/me сообщил данные подозреваемого диспетчеру')
    wait(750)
    sampSendChat('/do Данные сообщены диспетчеру.')
    wait(750)
    sampSendChat('/do Диспетчер: С подозреваемого снят розыск.')
    wait(750)
    sampSendChat("/clear "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function marrest(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me открыл двери МВД')
    wait(750)
    sampSendChat('/do Двери открыты.')
    wait(750)
    sampSendChat('/me провел человека в участок')
    wait(750)
    sampSendChat('/do Человек в участке.')
    wait(750)
    sampSendChat("/arrest "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function msu(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me взял рацию в руки, затем зажал кнопку')
    wait(750)
    sampSendChat('/do Кнопка зажата.')
    wait(750)
    sampSendChat('/me сообщил данные нарушителя диспетчеру')
    wait(750)
    sampSendChat('/do Нарушитель объявлен в розыск.')
    wait(750)
    sampSendChat("/su "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mpg(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/do Рация на поясе.')
    wait(750)
    sampSendChat('/me достал рацию')
    wait(750)
    sampSendChat('/todo Зажав кнопку*Преследую преступника, прием.')
    wait(750)
    sampSendChat("/pg "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mtakelic(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me взял планшет')
    wait(750)
    sampSendChat('/do Планшет в руке.')
    wait(750)
    sampSendChat('/me записал данные о нарушении и нарушителе')
    wait(750)
    sampSendChat('/do Данные обновлены.')
    wait(750)
    sampSendChat('/me забрал водительские удостоверение')
    wait(750)
    sampSendChat('/do Водительское удостоверение забрано.')
    wait(750)
    sampSendChat("/takelic "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mputpl(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me открыл дверь машины')
    wait(750)
    sampSendChat('/me затащил преступника в машину')
    wait(750)
    sampSendChat('/me закрыл дверь')
    wait(750)
    sampSendChat('/do Дверь закрыта.')
    wait(750)
    sampSendChat("/putpl "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mticket(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me достал планшет')
    wait(750)
    sampSendChat('/do Планшет в руке.')
    wait(750)
    sampSendChat('/me записал данные о нарушении и нарушителе')
    wait(750)
    sampSendChat('/do Данные заполнены.')
    wait(750)
    sampSendChat('/me отправил данные в базу данных')
    wait(750)
    sampSendChat('/do Данные отправлены.')
    wait(750)
    sampSendChat('/me убрал планшет')
    wait(750)
    sampSendChat("/ticket "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mescort(arg)
    if arg:find('(%d+)') then
    lua_thread.create(function()
    sampSendChat('/me схватил задержанного за руки')
    wait(750)
    sampSendChat('/me заломал задержанного и повёл задержанного')
    wait(750)
    sampSendChat("/escort "..arg)
        end)
            else
            sampAddChatMessage(tag .. u8:decode'{006AFF}MVD Helper: {FFFFFF}Похоже, ты не ввел ID...', -1)
        end
    end

function mbreak_door()
    lua_thread.create(function()
    sampSendChat('/do Дверь перед "Имя"ом закрыта.')
    wait(750)
    sampSendChat('/me импульсивным движением ноги начал выбивать дверь')
    wait(750)
    sampSendChat('/do Через какой-то промежуток времени "Имя" выбыл дверь.')
    wait(750)
    sampSendChat('/break_door')
        end)
    end

function mattach()
    lua_thread.create(function()
    sampSendChat('/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(750)
    sampSendChat('/me включил бортовой компьютер Дорожно-Патрульной Службы')
    wait(750)
    sampSendChat('/do Бортовой компьютер Дорожно-Патрульной Службы включён.')
    wait(750)
    sampSendChat('/me нажал на кнопку "Фотография" и сделал фотографию')
    wait(750)
    sampSendChat('/do Фотография сохранена на базе данных Дорожно-Патрульной Службы.')
    wait(750)
    sampSendChat('/me нажал на кнопку выключения бортового компьютера Дорожно-Патрульной Службы')
    wait(750)
    sampSendChat('/do Бортовой компьютер Дорожно-Патрульной Службы выключен.')
    wait(750)
    sampSendChat('/me поставил эвакуатор на ручник')
    wait(750)
    sampSendChat('/do Эвакуатор стоит на ручнике.')
    wait(750)
    sampSendChat('/me отпустил кран эвакуатора')
    wait(750)
    sampSendChat('/do Кран эвакуатора отпущен.')
    wait(750)
    sampSendChat('/me зацепил транспортное средство')
    wait(750)
    sampSendChat('/do Транспортное средство зацеплено.')
    wait(750)
    sampSendChat('/me поднимает кран эвакуатора')
    wait(750)
    sampSendChat('/do Кран эвакуатора поднят.')
    wait(750)
    sampSendChat('/me эвакуирует транспортное средство')
    wait(750)
    sampSendChat('/do Эвакуатор готов к движению.')
    wait(750)
    sampSendChat('/me отпустил ручник на эвакуаторе')
    wait(750)
    sampSendChat('/attach')
    wait(750)
    sampSendChat('/n [Пр]: Докладывает: "Звание , Фамилия". Начинаю эвакуацию ТС на ШС.')
    wait(750)
    sampSendChat('/c 060')
        end)
    end

    local imgui = require 'imgui'
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()
