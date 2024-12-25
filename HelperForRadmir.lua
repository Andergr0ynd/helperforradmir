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
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588963987750912/arrest1.mp3?ex=676c713d&is=676b1fbd&hm=447872b289c48850da15735bbc05260b469791e8c91ff98687a9506967e2996a&',
        file_name = 'arrest1.mp3',
    },
    {
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588964390141982/arrest2.mp3?ex=676c713d&is=676b1fbd&hm=a9575c014677b81f2891bddab67156679d3ae77f83430503e7656c93364ea867&',
        file_name = 'arrest2.mp3',
    },
    {
        url = 'https://cdn.discordapp.com/attachments/1319588899185754172/1319588964780478474/arrest3.mp3?ex=676c713d&is=676b1fbd&hm=e5dfd5320e604a11e082fd6323a18d17dfca7b43a33584b865ad1e1b140de728&',
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
    sampRegisterChatCommand('miranda', miranda)
    sampRegisterChatCommand('photo', photo)
    sampRegisterChatCommand('koap1', koap1)
    sampRegisterChatCommand('koap2', koap2)
    sampRegisterChatCommand('koap3', koap3)
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


-- Начало команд 
-- /mhelp | Полный список команд
function mhelp()
    lua_thread.create(function() -- Создаем новый поток
        wait(100) -- Ждём 5 секунд
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}Список команд', u8:decode' \n {FFFFFF}/mhelp - Просмотр списка существующих команд \n /msm - Начать отслеживать преступников \n /mdoc - Показать удостоверение \n /mdoc1 - Попросить документы \n /mdoc2 - Проверка документов \n /mdoc3 - При успешной проверке документов | Отпустить \n /mdoc4 - Проверка документов на транспорт \n /mdoc5 - В случае если человек в розыске \n /msearch - Провести обыск \n /mcuff - Надеть наручники \n /muncuff - Снять наручники \n /mclear - Снять розыск | Необходима опра на снятие \n /msu - Выдать звёзды \n /marrest - Арестовать преступника \n /mpg - Начать погоню \n /mtakelic - Забрать лицензии \n /mputpl - Посадить преступника в машину \n /mticket - Выдать штраф \n /mescort - Повести преступника за собой \n /mbreak_door - Выбить дверь \n /mattach - Эвакуировать транспорт на ШС \n', u8:decode'Закрыть')
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
    lua_thread.create(function() -- Создаем новый поток
        wait(100) -- Ждём 5 секунд
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 01', u8:decode' \n  \n{FFFFFF} 1.1. Управление транспортным средством без государственного регистрационного знака {B4452D} [Штраф: 5.000]\n{fbec5d}Пробег которого составляет более 150 км.\n{FFFFFF} 1.2. Отсутствие у водителя транспортного средства документов на право вождения им. {B4452D} [Штраф: 10.000]\n{FFFFFF} 1.3. Отказ предоставить сотруднику МВД водительское удостоверение. {B4452D} [Штраф: 15.000]\n{FFFFFF} 3.1. Выезд на полосу встречного движения {B4452D} [Штраф: 10.000]\n{fbec5d}Равно пересечение сплошной или двойной сплошной линии разметки.\n{FFFFFF} 3.2. Движение по полосе, предназначенной для встречного движения. {B4452D} [Штраф: 15.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 3.3. Совершение административного правонарушения {B4452D} [Штраф: 25.000, компенсация нанесенного ущерба, лишение водительского удостоверения.]\n{fbec5d}Предусмотренного частью 1 и 2 настоящей статьи, последствия которого привели к ДТП.\n{FFFFFF} 3.4. Несоблюдение требований, предписанных дорожными знаками или разметкой. {B4452D} [Штраф: 15.000]\n{FFFFFF} 4.1. Управление транспортным средством, с неисправными фарами. {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.2. Управление транспортным средством, с неисправным двигателем без аварийной сигнализации. {B4452D} [Штраф: 5.500]\n{FFFFFF} 4.3. Управление транспортным средством, с неисправными колёсами. {B4452D} [Штраф: 6.000]\n{FFFFFF} 5.1. Проезд на красный сигнал светофора. {B4452D} [Штраф: 5.000]\n{FFFFFF} 6.1. Парковка транспортного средства в неположенном месте. {B4452D} [Штраф: 7.000; эвакуация транспортного средства на штрафстоянку.]\n{FFFFFF} 6.2. Парковка транспортного средства в неположенном месте, повлекшая создание аварийной ситуации или препятствий для движения транспортных средств. \n{B4452D} [Штраф: 15.000; эвакуация транспортного средства на штрафстоянку.]\n{FFFFFF} 7.1. Движение по пешеходным дорожкам, тротуарам, газонам. {B4452D} [Штраф: 7.000]\n{FFFFFF} 7.3. Агрессивное вождение, дрифт или другие проявления опасного поведения на проезжей части. {B4452D} [Штраф: 15.000, лишение водительского удостоверения.]\n{FFFFFF} 7.5. Езда на мото-транспорте без защитного шлема. {B4452D} [Штраф: 3.000]\n{FFFFFF} 7.6. Езда на транспортном средстве с выключенным ближним светом в любое время суток. {B4452D} [Штраф: 2.500]\n{FFFFFF} 7.8. Езда на транспортном средстве с установленной плёнкой на окнах, светопропускаемость которых ниже 70%. {B4452D} [Штраф: 10.000]\n{FFFFFF} 8.2. Невыполнение законного требования сотрудника полиции об остановке транспортного средства. {B4452D} [Штраф: 25.000, лишение водительского удостоверения.]\n{FFFFFF} 10.1. Оскорбление гражданского лица. {B4452D} [Штраф: 10.000]\n{FFFFFF} 10.2. Использование нецензурной лексики в общественных местах. {B4452D} [Штраф: 5.000]\n{FFFFFF} 10.3. Хулиганство. {B4452D} [Штраф: 20.000, ст. 10 УК.]\n{FFFFFF} 10.4. Отсутствие у гражданина документов, удостоверяющих личность. {B4452D} [Штраф: 10.000]\n{FFFFFF} 11.1. Оскорбление сотрудника правоохранительных органов при исполнении. {B4452D} [Штраф: 15.000, ст. 21 УК.]\n{FFFFFF} 11.3. Неповиновение законному требования сотрудника правоохранительных органов. {B4452D} [Штраф:  20.000, ст. 23 УК.]\n', u8:decode'Закрыть')
    end) -- Тут наш поток умирает :(
end

function koap2()
    lua_thread.create(function() -- Создаем новый поток
        wait(100) -- Ждём 5 секунд
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 02', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 15.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.3 За разворот через сплошную линию. {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 3.1 За проезд на красный сигнал светофора. {B4452D} [Штраф: 5.000 +  Лишение водительского удостоверения]\n{FFFFFF} 4.1 За парковку ТС в неположенном месте {B4452D} [Штраф: 7.000]\n{FFFFFF} 5.1 За движение на ТС по тротуару, газону, пешеходным дорожкам и прочих, не проезжей части дорог. {B4452D} [Штраф: 7.000]\n{FFFFFF} 6.1 За игнорирование сирен спец. служб {B4452D} [Штраф: 7.000]\n{FFFFFF} 6.3 За игнорирование инспектора МВД {B4452D} [Штраф: 7.000]\n{FFFFFF} 7.1 За затруднение движения транспортным средством {B4452D} [Штраф: 5.000]\n{FFFFFF} 7.3 За езду на ТС в неисправном состоянии {B4452D} [Штраф: 8.000]\n{fbec5d} (Неисправное состояние - это когда машина дымится и движется без авариек)\n{FFFFFF} 8.1 За использование ненормативной лексики {B4452D} [Штраф: 8.000]\n{FFFFFF} 8.2 За оскорбление граждан {B4452D} [Штраф: 8.000]\n{FFFFFF} 8.3 За оскорбление сотрудника МВД при исполнении {B4452D} [Штраф: 15.000\n{FFFFFF} 9.1 За передвижение на ТС без регистрационного знака {B4452D} [Штраф: 5.000]\n{FFFFFF} 10.1 За агрессивное поведение на дороге, находясь в ТС, на водительском месте {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения]\n{FFFFFF} 11.1 За непристегнутый ремень безопасности во время движения на ТС {B4452D} [Штраф: 1.000]\n{FFFFFF} 11.2 За езду без шлема {B4452D} [Штраф: 3.000]\n{FFFFFF} 12.1 За движение на транспортном средстве, в котором степень светопропускания ниже 70%  {B4452D} [Штраф: 10.000]\n{FFFFFF} 13.1 За движение на ТС, без водительского удостоверения {B4452D} [Штраф: 10.000]\n{fbec5d} (C учетом того, что гражданин забыл их дома)\n{FFFFFF} 13.2 За передвижение гражданина по территории Нижегородской области без паспорта {B4452D} [Штраф: 10.000]\n{fbec5d} (C учетом того, что гражданин забыл их дома)\n{FFFFFF} 13.3 За отказ от предъявления водительского удостоверения/паспорта сотруднику МВД {B4452D} [Штраф: 15.000]\n{fbec5d} *Примечание к пунктам №13.1 - 13.3: \n{fbec5d} Сотрудник МВД обязан отыграть, что пробивает игрока через планшет\n{fbec5d} а именно: отыгрывает как он фотографирует игрока, пробивает игрока по базе и т.д.\n{FFFFFF} 17.1 За движение на ТС с выключенными фарами {B4452D} [Штраф: 2.500]\n', u8:decode'Закрыть')
    end) -- Тут наш поток умирает :(
end

function koap3()
    lua_thread.create(function() -- Создаем новый поток
        wait(100) -- Ждём 5 секунд
        sampShowDialog(1, u8:decode'{006AFF}MVD Helper: {FFFFFF}КоАП 03', u8:decode' \n \n{FFFFFF} 2.1 За езду по встречной полосе {B4452D} [Штраф: 5.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 2.3 Пересечение двойной сплошной {B4452D} [Штраф: 8.000]\n{FFFFFF} 2.4 Разворот через двойную сплошную {B4452D} [Штраф: 10.000]\n{FFFFFF} 3.1 За проезд красного сигнала светофора {B4452D} [Штраф: 3.000]\n{FFFFFF} 4.1. За парковку ТС в неположенном месте {B4452D} [Штраф: 15.000]\n{FFFFFF} 5.1. За движение ТС по тротуару, газону, пешеходным дорожкам и прочих не проезжей части дорог {B4452D} [Штраф: 57.000]\n{FFFFFF} 6.1. За игнорирование сирен спец. служб {B4452D} [Штраф: 4.000]\n{FFFFFF} 7.1. За создание аварийной ситуации, в т.ч. передвижению по проезжей части пешеходом {B4452D} [Штраф: 4.000]\n{fbec5d}Пример ситуаций к 7.1 :\n{fbec5d}превышение скорости;\n{fbec5d}нарушение требований знаков и разметки;\n{fbec5d}проезд на красный сигнал светофора;\n{fbec5d}нарушение правил перевозки грузов, буксировки транспортных средств;\n{fbec5d}нарушение правил остановки, стоянки;\n{fbec5d}нарушение правил проезда пешеходных переходов;\n{fbec5d}нарушение правил проезда перекрестков;\n{fbec5d}нарушение правил обгона и встречного разъезда;\n{fbec5d}нарушение правил учебной езды;\n{fbec5d}непредоставление преимущества в движении полиции, скорой или пожарным\n{FFFFFF} 7.2. За езду на ТС в неисправном состоянии {B4452D} [Штраф: 3.000 +  Лишение водительского удостоверения.]\n{fbec5d} (Неисправное состояние - это когда машина дымится и движется без авариек)\n{FFFFFF} 9.1. За агрессивное поведение на дороге будучи находясь в ТС на водительском месте {B4452D} [Штраф: 10.000 +  Лишение водительского удостоверения.]\n{FFFFFF} 10.1. За езду без номеров {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.1. За езду без пристёгнутого ремня безопасности {B4452D} [Штраф: 5.000]\n{FFFFFF} 12.2 За езду без одетого на голову мотошлема {B4452D} [Штраф: 5.000]\n{FFFFFF} 13.1 За оскорбление сотрудника правоохранительных органов {B4452D} [Штраф: 25.000]\n{fbec5d}(Пример: Мусора)\n{FFFFFF} 14.1 За езду на авто с нанесенной пленкой светопропускаемость которой ниже 50%  {B4452D} [Штраф: 15.000]\n{FFFFFF} 20.1. Оскорбление, то есть унижение чести и достоинства другого лица, выраженное в неприличной форме {B4452D} [Штраф: от 3.000 до 9.000]\n{FFFFFF} 20.3. Нанесение побоев или совершение иных насильственных действий  {B4452D} [Штраф: от 5.000 до 30.000]\n{FFFFFF} 20.5. Потребление наркотических средств или психотропных веществ без назначения врача {B4452D} [Штраф: от 5.000 до 10.000]\n{FFFFFF} 30.2. Нарушение правил перевозки, транспортирования оружия и патронов к нему {B4452D} [Штраф: от 1.000 до 2.000]\n', u8:decode'Закрыть')
    end) -- Тут наш поток умирает :(
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
