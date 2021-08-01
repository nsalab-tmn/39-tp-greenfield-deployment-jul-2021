#!/bin/bash
while ! ping -c 1 -W 1 1.1.1.1; do
    echo "Waiting for 1.1.1.1 - network interface might be down..."
    sleep 5
done
set -xe
snap install docker --classic
mkdir ~/src
cd ~/src

cat <<EOF >Dockerfile
FROM alpine
WORKDIR /opt
ADD web-53 config.yaml ./
ENTRYPOINT ./web-53
EOF
wget https://test-web53.s3.eu-central-1.amazonaws.com/web-53
wget https://test-web53.s3.eu-central-1.amazonaws.com/config.yaml
chmod +x web-53
#adjust config.yaml: Redis.Host: redis-53
cat <<EOF > config.yaml
AWS:
  Region: eu-central-1
Server:
  Host: 0.0.0.0
  Port: 8080
DynamoDB:
  Region: eu-central-1
  TableName: test-web-53
  PrimaryPartitionKey: recordId
Redis:
  Host: redis-53
  Port: 6379
EOF

docker build . -t web-53
docker network create --driver bridge web53-net
docker run --restart=always -d --name=web-53 --network=web53-net  \
    -v "$(pwd)/config.yaml:/opt/config.yaml" web-53
        
docker run --restart=always -d --name=redis-53 --network=web53-net redis

cat <<EOF > supercert.pem
-----BEGIN CERTIFICATE-----
MIILejCCCmKgAwIBAgISAzjiL0cdBtSlJdLJehC7ZkOVMA0GCSqGSIb3DQEBCwUA
MDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQD
EwJSMzAeFw0yMTA3MzAxMjUwNDNaFw0yMTEwMjgxMjUwNDFaMCMxITAfBgNVBAMM
GCouYXouc2tpbGxzY2xvdWQuY29tcGFueTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAMFzLxJzy4jt8RpGaNxsr5Me7AuktkGlhcIElyOheHhx9hJ4blQz
knqJ9Vd8U2mN9PyjiaiqAqx91KJSyud9HmrGkE/cAsn9p5MkUgHCEp+wBoFR+jm3
qLKdJlrLwy4//Gzu/9753SLrkHifwFhrcWtxVD+x4RLuJ0wuk214YJI707Vr3dA9
nhVAYB4A29qRvsB8CCHiM8qPUWKNjVLn0WbQTO6JvTbCaUrvsjUzqI3/wAnc/jYy
SHngSfKm8twcAIi4RY8wSSQ9u/K7G8TzWYo0qNTFhQjtI5RKKDXNmLHC/yrGZ1Y8
x/Bj6TccyUT+qkSyMiwuyUNf2B2OSM9e8W0CAwEAAaOCCJcwggiTMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/
BAIwADAdBgNVHQ4EFgQU5InevRnM3HL1dcDATQ+Qdojh5AswHwYDVR0jBBgwFoAU
FC6zF7dYVsuuUAlA5h+vnYsUwsYwVQYIKwYBBQUHAQEESTBHMCEGCCsGAQUFBzAB
hhVodHRwOi8vcjMuby5sZW5jci5vcmcwIgYIKwYBBQUHMAKGFmh0dHA6Ly9yMy5p
LmxlbmNyLm9yZy8wggZmBgNVHREEggZdMIIGWYIYKi5hei5za2lsbHNjbG91ZC5j
b21wYW55gicqLmdmZC0zOS1jb21wLTAxLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmC
JyouZ2ZkLTM5LWNvbXAtMDIuYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQt
MzktY29tcC0wMy5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21w
LTA0LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMDUuYXou
c2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0wNi5hei5za2lsbHNj
bG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTA3LmF6LnNraWxsc2Nsb3VkLmNv
bXBhbnmCJyouZ2ZkLTM5LWNvbXAtMDguYXouc2tpbGxzY2xvdWQuY29tcGFueYIn
Ki5nZmQtMzktY29tcC0wOS5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0z
OS1jb21wLTEwLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAt
MTEuYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0xMi5hei5z
a2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTEzLmF6LnNraWxsc2Ns
b3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMTQuYXouc2tpbGxzY2xvdWQuY29t
cGFueYInKi5nZmQtMzktY29tcC0xNS5hei5za2lsbHNjbG91ZC5jb21wYW55gicq
LmdmZC0zOS1jb21wLTE2LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5
LWNvbXAtMTcuYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0x
OC5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTE5LmF6LnNr
aWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMjAuYXouc2tpbGxzY2xv
dWQuY29tcGFueYInKi5nZmQtMzktY29tcC0yMS5hei5za2lsbHNjbG91ZC5jb21w
YW55gicqLmdmZC0zOS1jb21wLTIyLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyou
Z2ZkLTM5LWNvbXAtMjMuYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzkt
Y29tcC0yNC5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTI1
LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMjYuYXouc2tp
bGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0yNy5hei5za2lsbHNjbG91
ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTI4LmF6LnNraWxsc2Nsb3VkLmNvbXBh
bnmCJyouZ2ZkLTM5LWNvbXAtMjkuYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5n
ZmQtMzktY29tcC0zMC5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1j
b21wLTMxLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMzIu
YXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0zMy5hei5za2ls
bHNjbG91ZC5jb21wYW55gicqLmdmZC0zOS1jb21wLTM0LmF6LnNraWxsc2Nsb3Vk
LmNvbXBhbnmCJyouZ2ZkLTM5LWNvbXAtMzUuYXouc2tpbGxzY2xvdWQuY29tcGFu
eYInKi5nZmQtMzktY29tcC0zNi5hei5za2lsbHNjbG91ZC5jb21wYW55gicqLmdm
ZC0zOS1jb21wLTM3LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCJyouZ2ZkLTM5LWNv
bXAtMzguYXouc2tpbGxzY2xvdWQuY29tcGFueYInKi5nZmQtMzktY29tcC0zOS5h
ei5za2lsbHNjbG91ZC5jb21wYW55MEwGA1UdIARFMEMwCAYGZ4EMAQIBMDcGCysG
AQQBgt8TAQEBMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly9jcHMubGV0c2VuY3J5cHQu
b3JnMIIBAwYKKwYBBAHWeQIEAgSB9ASB8QDvAHYAXNxDkv7mq0VEsV6a1FbmEDf7
1fpH3KFzlLJe5vbHDsoAAAF69653oQAABAMARzBFAiBTdtfEkcKDnE7uxZghN2nZ
STbM9fUA3WQBqOmnwRwcKAIhAJgMqBKOJfHl+xthBkra/O1VCNHeIrt8T2mzEvmv
0cUZAHUA9lyUL9F3MCIUVBgIMJRWjuNNExkzv98MLyALzE7xZOMAAAF69653mwAA
BAMARjBEAiBxriJkK8iMnDw/XnETMnmkKqyE0gqvMq1KIyWQz5FL5QIgcrkyIrHz
i78SIjDpo0Cf/tUABBBneVrAEmCeL1iOZuMwDQYJKoZIhvcNAQELBQADggEBAD12
h2n6LJQPQ77Rrnw5iGbfpBQxaOpEmjZAC3yDG8YU1ZGtjV3MYvr6FNo3rVTy+qrZ
C/dXG5SgnME/eOEr7UFOGm0MHzLlfncG9VVu67Vr8tZhurT0z+GZw1Hexzo6b0dr
XP5j6XvV679NDW9YthAJduqkkB/RBfITk01IJ/Rgq6/14/+/WMkjqvptWBUQoWd3
GaVYWTUCrSkwlQvKcmQ2f/5yu3IGp5lm2JzaOimtrdXwdRs2z5QwhIbvAasvTGI7
RTWHBr3ywn4I5kdnbWcjnkCS/4IKd3oBKrK3VtCZFzj/mKib87l5s8yoHP65TrlN
GBPY8tsvi1trafuVYKQ=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFFjCCAv6gAwIBAgIRAJErCErPDBinU/bWLiWnX1owDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMjAwOTA0MDAwMDAw
WhcNMjUwOTE1MTYwMDAwWjAyMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNTGV0J3Mg
RW5jcnlwdDELMAkGA1UEAxMCUjMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQC7AhUozPaglNMPEuyNVZLD+ILxmaZ6QoinXSaqtSu5xUyxr45r+XXIo9cP
R5QUVTVXjJ6oojkZ9YI8QqlObvU7wy7bjcCwXPNZOOftz2nwWgsbvsCUJCWH+jdx
sxPnHKzhm+/b5DtFUkWWqcFTzjTIUu61ru2P3mBw4qVUq7ZtDpelQDRrK9O8Zutm
NHz6a4uPVymZ+DAXXbpyb/uBxa3Shlg9F8fnCbvxK/eG3MHacV3URuPMrSXBiLxg
Z3Vms/EY96Jc5lP/Ooi2R6X/ExjqmAl3P51T+c8B5fWmcBcUr2Ok/5mzk53cU6cG
/kiFHaFpriV1uxPMUgP17VGhi9sVAgMBAAGjggEIMIIBBDAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMBIGA1UdEwEB/wQIMAYB
Af8CAQAwHQYDVR0OBBYEFBQusxe3WFbLrlAJQOYfr52LFMLGMB8GA1UdIwQYMBaA
FHm0WeZ7tuXkAXOACIjIGlj26ZtuMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcw
AoYWaHR0cDovL3gxLmkubGVuY3Iub3JnLzAnBgNVHR8EIDAeMBygGqAYhhZodHRw
Oi8veDEuYy5sZW5jci5vcmcvMCIGA1UdIAQbMBkwCAYGZ4EMAQIBMA0GCysGAQQB
gt8TAQEBMA0GCSqGSIb3DQEBCwUAA4ICAQCFyk5HPqP3hUSFvNVneLKYY611TR6W
PTNlclQtgaDqw+34IL9fzLdwALduO/ZelN7kIJ+m74uyA+eitRY8kc607TkC53wl
ikfmZW4/RvTZ8M6UK+5UzhK8jCdLuMGYL6KvzXGRSgi3yLgjewQtCPkIVz6D2QQz
CkcheAmCJ8MqyJu5zlzyZMjAvnnAT45tRAxekrsu94sQ4egdRCnbWSDtY7kh+BIm
lJNXoB1lBMEKIq4QDUOXoRgffuDghje1WrG9ML+Hbisq/yFOGwXD9RiX8F6sw6W4
avAuvDszue5L3sz85K+EC4Y/wFVDNvZo4TYXao6Z0f+lQKc0t8DQYzk1OXVu8rp2
yJMC6alLbBfODALZvYH7n7do1AZls4I9d1P4jnkDrQoxB3UqQ9hVl3LEKQ73xF1O
yK5GhDDX8oVfGKF5u+decIsH4YaTw7mP3GFxJSqv3+0lUFJoi5Lc5da149p90Ids
hCExroL1+7mryIkXPeFM5TgO9r0rvZaBFOvV2z0gp35Z0+L4WPlbuEjN/lxPFin+
HlUjr8gRsI3qfJOQFy/9rKIJR0Y/8Omwt/8oTWgy1mdeHmmjk7j1nYsvC9JSQ6Zv
MldlTTKB3zhThV1+XWYp6rjd5JW1zbVWEkLNxE7GJThEUG3szgBVGP7pSWTUTsqX
nLRbwHOoq7hHwg==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFYDCCBEigAwIBAgIQQAF3ITfU6UK47naqPGQKtzANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTIxMDEyMDE5MTQwM1oXDTI0MDkzMDE4MTQwM1ow
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQCt6CRz9BQ385ueK1coHIe+3LffOJCMbjzmV6B493XC
ov71am72AE8o295ohmxEk7axY/0UEmu/H9LqMZshftEzPLpI9d1537O4/xLxIZpL
wYqGcWlKZmZsj348cL+tKSIG8+TA5oCu4kuPt5l+lAOf00eXfJlII1PoOK5PCm+D
LtFJV4yAdLbaL9A4jXsDcCEbdfIwPPqPrt3aY6vrFk/CjhFLfs8L6P+1dy70sntK
4EwSJQxwjQMpoOFTJOwT2e4ZvxCzSow/iaNhUd6shweU9GNx7C7ib1uYgeGJXDR5
bHbvO5BieebbpJovJsXQEOEO3tkQjhb7t/eo98flAgeYjzYIlefiN5YNNnWe+w5y
sR2bvAP5SQXYgd0FtCrWQemsAXaVCg/Y39W9Eh81LygXbNKYwagJZHduRze6zqxZ
Xmidf3LWicUGQSk+WT7dJvUkyRGnWqNMQB9GoZm1pzpRboY7nn1ypxIFeFntPlF4
FQsDj43QLwWyPntKHEtzBRL8xurgUBN8Q5N0s8p0544fAQjQMNRbcTa0B7rBMDBc
SLeCO5imfWCKoqMpgsy6vYMEG6KDA0Gh1gXxG8K28Kh8hjtGqEgqiNx2mna/H2ql
PRmP6zjzZN7IKw0KKP/32+IVQtQi0Cdd4Xn+GOdwiK1O5tmLOsbdJ1Fu/7xk9TND
TwIDAQABo4IBRjCCAUIwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYw
SwYIKwYBBQUHAQEEPzA9MDsGCCsGAQUFBzAChi9odHRwOi8vYXBwcy5pZGVudHJ1
c3QuY29tL3Jvb3RzL2RzdHJvb3RjYXgzLnA3YzAfBgNVHSMEGDAWgBTEp7Gkeyxx
+tvhS5B1/8QVYIWJEDBUBgNVHSAETTBLMAgGBmeBDAECATA/BgsrBgEEAYLfEwEB
ATAwMC4GCCsGAQUFBwIBFiJodHRwOi8vY3BzLnJvb3QteDEubGV0c2VuY3J5cHQu
b3JnMDwGA1UdHwQ1MDMwMaAvoC2GK2h0dHA6Ly9jcmwuaWRlbnRydXN0LmNvbS9E
U1RST09UQ0FYM0NSTC5jcmwwHQYDVR0OBBYEFHm0WeZ7tuXkAXOACIjIGlj26Ztu
MA0GCSqGSIb3DQEBCwUAA4IBAQAKcwBslm7/DlLQrt2M51oGrS+o44+/yQoDFVDC
5WxCu2+b9LRPwkSICHXM6webFGJueN7sJ7o5XPWioW5WlHAQU7G75K/QosMrAdSW
9MUgNTP52GE24HGNtLi1qoJFlcDyqSMo59ahy2cI2qBDLKobkx/J3vWraV0T9VuG
WCLKTVXkcGdtwlfFRjlBz4pYg1htmf5X6DYO8A4jqv2Il9DjXA6USbW1FzXSLr9O
he8Y4IWS6wY7bCkjCWDcRQJMEhg76fsO3txE+FiYruq9RUWhiF1myv4Q6W+CyBFC
Dfvp7OOGAN6dEOM4+qR9sdjoSYKEBpsr6GtPAQw4dy753ec5
-----END CERTIFICATE-----
EOF

cat <<EOF > supercert.key
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDBcy8Sc8uI7fEa
RmjcbK+THuwLpLZBpYXCBJcjoXh4cfYSeG5UM5J6ifVXfFNpjfT8o4moqgKsfdSi
UsrnfR5qxpBP3ALJ/aeTJFIBwhKfsAaBUfo5t6iynSZay8MuP/xs7v/e+d0i65B4
n8BYa3FrcVQ/seES7idMLpNteGCSO9O1a93QPZ4VQGAeANvakb7AfAgh4jPKj1Fi
jY1S59Fm0Ezuib02wmlK77I1M6iN/8AJ3P42Mkh54EnypvLcHACIuEWPMEkkPbvy
uxvE81mKNKjUxYUI7SOUSig1zZixwv8qxmdWPMfwY+k3HMlE/qpEsjIsLslDX9gd
jkjPXvFtAgMBAAECggEBAJI6QjO9ifXYfq6w2GT+Vv1rm1v1xrr6ppARLjoFvW22
Hx65IBTP4wJztBvMY7TfVHeAGvd+g4TlnMySrsOrBUoLDF0BXq5W6cvE4aRokfFZ
eqFYWUA1vvQ87Bgn/ELCpUmmo41l7C2QSOWVRCzSEqr3wIphKFRJ5zSj5FcUblM6
SP6eLtrMehh4VgxnvjqVIVx49PRKkPe2yflTNRgPOQegJoD/XCDl9nO4KKylxDef
ltfxSQDLU7fv9JJoC9YQASRTTWorkzCyzcHtLT/sM/h9Rj0H6D8S9caQ0b59wOQx
qws2RLUYJS8BlozDoPiiwK7Y2y1a/GEWFB8481oqONUCgYEA+8ULGSB1KIWmYpPQ
RwkqZHGuZ7sd+lFeAyMvaXWDwsVovDaXvkNE2zEC92t3muGuWu/pXycOnMMKRonO
dvZALDffc/wsfAfi5Hxows/hhF852g+/yLf32LrDZU++fFVEb2y3Xoy4R6rZS91k
Okt1DjuZ+W2FxtuBOvFckleM2QMCgYEAxLNJAUmoh2UPKgDpjyBw5c97K15UiOta
MZT+o8yAWCllN/FaduFp3qVVlZT8dAwd5Eo2LPuii00mI+Q5o7666Q/sa75N5J9E
UEMxfZ22o8mWyL4Y1XOnFgSluBYa8ANJn3aIH33vtSVuTv8uz6QstDTohi+ecWQR
qf9G0dMxKM8CgYEAj0kbAdfZFZDKmrupA2SR/cw9B8gUTYvVR0/VAd3heQ3Eh6lC
PwQlweFo4MsGrNzXz+VOGdsuk8TkqjRvjoCjEQdTYr0XzBbo6ERtksGghSd000e3
TFJ2+Z+A6L2zmSsl4Ywr5+GKVy9Cr8x16D9dhRYikTPluMDgEV2f46F0BWUCgYA9
i8N6DawXwT0/bU2nJQVuQr9NUJSuysVL4kzSv7gg3cL4ACLIM7vGmIDw7s8XGHt5
5OaSqKGxaJBYhp6qZ5FgP0VAaSlCMbtUSdIAdgqhsP/nC+QFVcygDRA1S2VeWAj/
Rj1NbUBFs9KSETJ6ceoy8KMY6WlwHVmRkXh9StGE7QKBgCN/gx8NmafG+Y2tERFh
fouB3tbJa9AGcN5Rwu5EdDm5vtzSj0qJFImd/51KctMgu0oHINg5MCFmxWz+DjLt
0/bWiAN4grT4ZQgCoHN2moMvTPxr7RudFjH0EwdYx0n3O7dIIQnbpdkVTwUpF4iR
g7kPwwhUZFoZTgj/Jt7BmjEb
-----END PRIVATE KEY-----
EOF

cat <<EOF > traefik.yml
log:
  level: "DEBUG"
api:
  dashboard: true
  insecure: true

entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"

providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
  file:
    filename: /etc/traefik/dynamic_conf.yml

certificatesResolvers:
  letsEncrypt:
    acme:
      email: postmaster@${prefix}.az.skillscloud.company
      storage: acme.json
      caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
      httpChallenge:
        entryPoint: http
EOF

cat <<EOF> dynamic_conf.yml
tls:
  certificates:
    - certFile: /etc/traefik/supercert.pem
      keyFile: /etc/traefik/supercert.key
http:
  routers:
    http-catchall:
      rule: Host("app.${prefix}.az.skillscloud.company")
      # rule: hostregexp("{.+}")
      entrypoints:
      - http
      middlewares:
      - redirect-to-https
      service: noop@internal
    web-53:
      rule: Host("app.${prefix}.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-01:
      rule: Host("westus.${prefix}.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-02:
      rule: Host("eastus.${prefix}.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-03:
      rule: Host("southcentralus.${prefix}.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
      
  middlewares:
    redirect-to-https:
      redirectScheme:
        scheme: https
        permanent: false
  services:
    web-53:
      loadbalancer:
        servers:
          - url: "http://${platform_01_ip}:8080/"
          - url: "http://${platform_02_ip}:8080/"
          - url: "http://${platform_03_ip}:8080/"
        healthCheck:
          path: "/health"
          interval: "1s"
          timeout: "2s"
EOF

docker run -d -p 80:80 -p 443:443 -p 5000:8080  -v "$(pwd)/traefik.yml:/etc/traefik/traefik.yml" -v /var/run/docker.sock:/var/run/docker.sock  -v $(pwd)/dynamic_conf.yml:/etc/traefik/dynamic_conf.yml -v $(pwd)/supercert.pem:/etc/traefik/supercert.pem -v $(pwd)/supercert.key:/etc/traefik/supercert.key --name traefik --network=web53-net traefik:v2.4
