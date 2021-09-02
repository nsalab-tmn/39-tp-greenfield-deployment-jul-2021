![](tickets/topology.png)

## Описание конкурсного задания
Компания «SkillsCloud» является лидером на рынке разработки прикладных программных интерфейсов для анализа данных автоматизированных систем управления технологическими процессами. В 2021 году, с целью снижения капитальных затрат на содержание собственной информационной инфраструктуры, компания реализовывает пилотный проект по переходу на модель «инфраструктура как сервис» (IaaS) и тестирует размещение своих программных продуктов на инфраструктуре публичного облака Microsoft Azure, а также проводит отбор кандидатов для дальнейшей работы над данным проектом.  

В рамках практических испытаний, кандидатам будет предложено обеспечить отказоустойчивой инфраструктуры для функционирования специализированного веб-приложения в нескольких регионах присутствия основного заказчика. 

Данная инфраструктура предполагает размещение приложения в нескольких регионах присутствия основного заказчика. На границе глобальной и приватной сети каждого региона развернута специализированная виртуальная платформа для управления сетевым трафиком. В приватной сети каждого региона — виртуальная платформа для размещения приложения.  

### Техническое задание

#### Приложение и зависимости
- для выполнения задания требуется развернуть приложение web-53 версии `v21.08.03`, дистрибутив доступен по ссылке https://test-web53.s3.eu-central-1.amazonaws.com/21.08.03/web-53
- каждый локальный экземпляр приложения должен быть подключен к локальной базе данных Redis

#### Общие требования
- с точки зрения внешних систем, данное веб-приложение должно быть доступно через единую точку входа — https://app.prefix.az.skillscloud.company (где prefix — индивидуальный идентификатор кандидата);
-	при выходе из строя одного (или нескольких) экземпляров приложения (в том числе, при отказе одного или нескольких регионов или зон доступности), простой времени доступа к приложению не должен превышать 10 секунд;
-	все входящие запросы к приложению из глобальной сети должны приниматься только с применением защищенных протоколов уровня приложения.

#### Пограничные платформы управления трафиком должны:
- обеспечивать полный доступ в глобальную сеть интернет для соответствующей региональной частной подсети; 
- обеспечивать доступ к соответствующему региональному экземпляру веб-приложения для любых внешних систем; 
- обеспечивать полную сетевую связность между региональными частными подсетями. 

#### Платформы для размещения приложения должны:
- обеспечивать работу приложения и всех его функциональных зависимостей; 
- перенаправлять входящие запросы по незащищенному протоколу прикладного уровня на адрес основной точки входа; 
- распределять входящие запросы между остальными региональными экземплярами приложения в случае, если локальный экземпляр приложения неисправен (возвращает HTTP код 5XX); 
- реализовывать необходимые механизмы для автоматического перезапуска локального экземпляра приложения, в случае его отказа. 

### Руководство по эксплуатации веб-приложения Web-53 

#### Параметры командной строки
Вызвать справку приложения можно с помощью команды `./web-53 -h`:
```
Usage: web-53 [-hpsv] [-c value] [-t value] [parameters ...]
 -c, --config=value
                    config file; config.yaml by default
 -h, --help         Help
 -p, --parse-config
                    Parse and print config provided by --config/-c option or
                    default config file, without starting a server
 -s, --sample-config
                    Generate a sample config
 -t, --token=value  generate token with secret
 -v, --version      Show version
```
Все параметры являются опциональными. По умолчанию, приложение использует в качестве файла конфигурации `config.yaml`. При наличии данного файла в директории запуска можно запустить приложение командой `./web-53` или `./web-53 -c custom-config.yaml` для запуска с файлом конфигурации `custom-config.yaml`. Сгенерировать файл конфигурации по умолчанию можно с помощью команды `./web-53 -s`.

#### Конфигурация
Файл конфигурации по умолчанию содержит следующие параметры:
```
# Используемый регион для размещения приложения
# Данный раздел не требуется для выполнения задания
AWS:
  Region: eu-central-1

# Конфигурация параметров HTTP-сервера 
# Данные параметры являются обязательными для запуска приложения
Server:
  Host: 0.0.0.0
  Port: 8080

# Параметры подключения к базе данных DynamoDB
# Данный раздел не требуется для выполнения задания
DynamoDB:
  Region: eu-central-1
  TableName: test-web-53
  PrimaryPartitionKey: recordId

# Параметры подключения к базе данных Redis
# Данный раздел требуется для выполнения задания
Redis:
  Host: 172.18.0.2
  Port: 6379

# Параметры подключения к базе данных MySQL
# Данный раздел не требуется для выполнения задания
DB:
  Host: database-1.c2empzdo10xn.eu-central-1.rds.amazonaws.com
  Port: 3306
  User: admin
  Pass: Aa123456
  DBName: db01
  Table: testweb53
```

#### Проверка работы веб-приложения
Проверить состояние подключений, согласно заданным параметрам, можно проверить на странице `/status`:
```
{
  "DynamoDBconfig": null,
  "InstanceID": "is not instance",
  "MySQLconfig": null,
  "OutboundIP": "192.168.172.219",
  "Redis": false,
  "RedisConfig":
    {
      "Host": "172.18.0.2",
      "Port": 6379
    },
  "Release": "Ubuntu 20.04.2 LTS"
}
```

#### Проверка состояния здоровья экземпляра приложения
Страница `/health` отображает состояние здоровья. В состоянии `true` индикатор возвращает HTTP-код `200`.  
```
curl http://localhost:8080/health -v
*   Trying 127.0.0.1:8080...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /health HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< <b>HTTP/1.1 200 OK*</b>
< Content-Type: application/json
< Date: Sat, 21 Aug 2021 15:00:11 GMT
< Content-Length: 17
< 
{"Healthy":true}

```
Данный индикатор должен использоваться балансировщиками нагрузки, чтобы не отправлять запросы к экземплярам, индикатор здоровья которых находятся в состоянии `false` (возвращает HTTP-код `500`).
```
curl http://localhost:8080/health -v
*   Trying 127.0.0.1:8080...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /health HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.68.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 500 Internal Server Error
< Content-Type: application/json
< Date: Sat, 21 Aug 2021 14:59:13 GMT
< Content-Length: 18
< 
{"Healthy":false}
```
