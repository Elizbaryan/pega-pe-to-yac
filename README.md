# PegPE on YandexCloud

В этом репозитории реализован пайплайн для автоматизации создания виртуалки в Yandex Compute Cloud и запуске на ней Pega PE.

## Как воспользоваться
Сделать форк, настроить переменные, запустить

### переменные
| Переменная   | Описание                                                      |
|--------------|---------------------------------------------------------------|
| LINK_DUMP1   | Ссылка на первую половину дампа                               |
| LINK_DUMP2   | Ссылка на вторую половину дампа                               |
| LINK_DUMP3   | Ссылка на файл - контрольную сумму (пока что не используется) |
| LINK_HELP    | Ссылка на prhelp.war                                          |
| LINK_PG      | Ссылка на JDBC драйвер Postgres                               |
| LINK_WEB     | Ссылка на prweb.war                                           |
| YC_CLOUD_ID  | идентификатор облака                                          |
| YC_FOLDER_ID | идентификатор папки облака                                    |
| YC_TOKEN     | токен доступа                                                 |
| YC_ZONE      | название зоны размещения                                      |

Все ссылки подразумеваются ссылками на облако mail.ru (полученные через встроенный механизм шаринга по ссылке).
Про параметры подключения к Yandex Cloud можно почитать тут https://cloud.yandex.ru/docs/compute/quickstart/quick-create-linux.

## Как работает

При каждом запуске пайплайна, а точнее каждого из его стейджей запускается докер docker контейнер, на котором происходит выполнение.

Пайплайн содержит два стейджа
* **newvm** - создание виртуалки
* **vmconfig** - настройка созданной виртуалки.

Для удобства объявлен кеш в папке cache. Это позволяет передавать между стейджамии промежуточные данные, а так же упростить отладку, за счёт однократной генерации SSH ключей.

Подробнее о каждом стейдже:
### newvm
1. Происходит установка адаптированного к работе в рамках CI/CD клиента **yc** для управления Yandex Cloud.
1. Создание кеша и генерация SSH ключей, в случае если их ещё нет.
1. Создание виртуалки.
1. Получение информации о созданной виртуалке, сохранение её  ip адреса для дальнейших шагов.
1. Экспорт сгенерированных ключей и IP адреса в виде артефакта сборки, доступного для скачивания.

### vmconfig
1. Запуск агента SSH ключей и импорт в него ранее сгенерированного ключа.
1. Перенос на виртуалку файлов конфигурации базы, томката.
1. Динамическое создание скрипта скачивания ресурсов по ссылкам из параметров.
1. Запуск на виртуалке скриптов через SSH соединение:
    1. **before.sh** установка утилиты для скачивания файлов с облака mail.ru.
    1. **download.sh** запуск скачивания.
    1. **db-install.sh** установка и настройка бд, импорт скачанного дампа.
    1. **tomcat-install.sh** установка и настройка Tomcat, деплой и запуск приложения

## Что можно улучшить

* Сильно расширить параметризирование. Например вынести в парамеры конфигурацию виртуалки (память, проц, диск), пароль пользователя БД.
* Добавить настройку пользователя-администратора tomcat.
* Добавить систему просмотра логов в браузере.
* Подумать о возможности подключения какого либо провайдера dynamic dns.
* Добавить настройку java процедур в БД (PR_READ_FROM_STREAM)

