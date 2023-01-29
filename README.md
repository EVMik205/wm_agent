# Утилита мониторинга состояния системы WM Agent
Предназначена для отправки данных о состоянии системы (аптайм, загрузка процессора, состояние памяти)
по протоколу MQTT.

## Установка и запуск
Скачиваем образ Docker: `docker pull evmik205/wm_agent:0.1` и
запускаем его `docker run --rm -it evmik205/wm_agent:0.1`.
В консоли хоста выполняем `mosquitto_sub -h test.mosquitto.org -p 1883 -t "wm2022"`
для просмотра сообщений.
В консоли докера запускаем агент `wm_agent`. Период сообщений по умолчанию 3 секунды.

## Конфигурация
Настройки хранятся в uci: `/etc/config/wm2022`
Параметры:
* period - период отправки сообщений в секундах;
* server - имя MQTT сервера;
* port - порт для подключения;
* topic - MQTT топик, в который отправляются сообщения;
* user - имя пользователя (если используется авторизация);
* password - пароль (если используется авторизация);
* use_tls - использовать TLS (1 - да, 0 - нет);
* enabled - отправлять сообщения или нет (1 - да, 0 - нет).
Пример файла:
```
config settings 'wm_agent'
        option topic 'wm2022'
        option period '3'
        option server 'test.mosquitto.org'
        option user ''
        option password ''
        option use_tls '0'
        option port '1883'
        option enabled '1'
```

Установка параметров осуществляется либо правкой конфига, либо через ubus, например:
```
ubus call wm_agent set_period '{"period": "10"}'
```

## Работа с MQTT сервером
Используется библиотека libmosquitto и lua обёртка к ней. Работа проверялась на тестовом сервере test.mosquitto.org
(настройки по умолчанию), а также с облачным сервисом HiveMQ. Последний требует использования авторизации и TLS,
для перенастройки агента могут быть использованы следующие команды:
```
ubus call wm_agent enable '{"flag": "0"}'
ubus call wm_agent set_server '{"server": "c17b8a5b51664f3c856d90418a2bdacf.s2.eu.hivemq.cloud"}'
ubus call wm_agent set_user '{"user": "wmagent"}'
ubus call wm_agent set_password '{"password": "wmpassword"}'
ubus call wm_agent use_tls '{"flag": "1"}'
ubus call wm_agent set_port '{"port": "8883"}'
ubus call wm_agent enable '{"flag": "1"}'

```
После этого можно просматривать сообщения от агента либо через веб-консоль https://console.hivemq.cloud
(требует регистрации), либо используя клиент командной строки
 `mosquitto_sub -h c17b8a5b51664f3c856d90418a2bdacf.s2.eu.hivemq.cloud -p 8883 -u wmagent -t "wm2022" -P wmpassword`.

## Файлы
* src - исходный код и конфиг;
* Dockerfile - докер файл для создания контейнера;
* Makefile - мейкфайл для сборки ipk;
* wm_agent_0.0.1-1_x86_64.ipk - готовый пакет для установки.

## To-do
Что ещё можно доделать (в порядке приоритета):
* на время бездействия останавливать таймер отправки, после включения перезапускать;
* добавить опции командной строки (lua-argparse);
* вывод отладочных сообщений (дебаг);
* добавить уход в фон (daemonize);
* журналирование;
* доработать статистику о системе.
