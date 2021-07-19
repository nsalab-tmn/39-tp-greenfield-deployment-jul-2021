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
EXPOSE 8080
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
    -v "$(pwd)/config.yaml:/opt/config.yaml" -p 8080:8080 web-53
        
docker run --restart=always -d --name=redis-53 --network=web53-net redis

cat <<EOF > supercert.pem
-----BEGIN CERTIFICATE-----
MIIKaTCCCVGgAwIBAgISA7kyp2237lrHT7J3muTFEtPFMA0GCSqGSIb3DQEBCwUA
MDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQD
EwJSMzAeFw0yMTA3MDMxNDA5MDVaFw0yMTEwMDExNDA5MDRaMCMxITAfBgNVBAMM
GCouYXouc2tpbGxzY2xvdWQuY29tcGFueTCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAMHfZKNMYPGCHnRjYlyT9Wg4I1gJ8HmoCFREMkdL/95to8ja64g7
2WRJdMqs+zI0U0jFbOcV7fkBnandAgYOmOtKim4NVnNDRICPRasXvlDivDq/w+0s
fBQX1na2F1hh2eYEqmh+wOCFUYhjyFznFDJ2JPVCd/fIVXxQhwpWGFg2sHhEv/m6
cZfdfMvLTCgh/ewLsjZ48xDsKZahBPnY6YaLsIX4S6OXvQY8hRYBNlOqAwV7glgd
1vQ7/LsqFk2ENzcWZJKXZH7f+snPM1aVnWf+3yU9NMLycHhBuX2jynsTrHLhZ1Oz
lzch7DvNYXtYEVs3GmmO25p/9FL1NFzDodMCAwEAAaOCB4YwggeCMA4GA1UdDwEB
/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/
BAIwADAdBgNVHQ4EFgQUrtnug+PWWB9WR2tfqAhRcs8c4X0wHwYDVR0jBBgwFoAU
FC6zF7dYVsuuUAlA5h+vnYsUwsYwVQYIKwYBBQUHAQEESTBHMCEGCCsGAQUFBzAB
hhVodHRwOi8vcjMuby5sZW5jci5vcmcwIgYIKwYBBQUHMAKGFmh0dHA6Ly9yMy5p
LmxlbmNyLm9yZy8wggVVBgNVHREEggVMMIIFSIIYKi5hei5za2lsbHNjbG91ZC5j
b21wYW55giAqLmNvbXAtMDEuYXouc2tpbGxzY2xvdWQuY29tcGFueYIgKi5jb21w
LTAyLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0wMy5hei5za2lsbHNj
bG91ZC5jb21wYW55giAqLmNvbXAtMDQuYXouc2tpbGxzY2xvdWQuY29tcGFueYIg
Ki5jb21wLTA1LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0wNi5hei5z
a2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMDcuYXouc2tpbGxzY2xvdWQuY29t
cGFueYIgKi5jb21wLTA4LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0w
OS5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMTAuYXouc2tpbGxzY2xv
dWQuY29tcGFueYIgKi5jb21wLTExLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICou
Y29tcC0xMi5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMTMuYXouc2tp
bGxzY2xvdWQuY29tcGFueYIgKi5jb21wLTE0LmF6LnNraWxsc2Nsb3VkLmNvbXBh
bnmCICouY29tcC0xNS5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMTYu
YXouc2tpbGxzY2xvdWQuY29tcGFueYIgKi5jb21wLTE3LmF6LnNraWxsc2Nsb3Vk
LmNvbXBhbnmCICouY29tcC0xOC5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNv
bXAtMTkuYXouc2tpbGxzY2xvdWQuY29tcGFueYIgKi5jb21wLTIwLmF6LnNraWxs
c2Nsb3VkLmNvbXBhbnmCICouY29tcC0yMS5hei5za2lsbHNjbG91ZC5jb21wYW55
giAqLmNvbXAtMjIuYXouc2tpbGxzY2xvdWQuY29tcGFueYIgKi5jb21wLTIzLmF6
LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0yNC5hei5za2lsbHNjbG91ZC5j
b21wYW55giAqLmNvbXAtMjUuYXouc2tpbGxzY2xvdWQuY29tcGFueYIgKi5jb21w
LTI2LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0yNy5hei5za2lsbHNj
bG91ZC5jb21wYW55giAqLmNvbXAtMjguYXouc2tpbGxzY2xvdWQuY29tcGFueYIg
Ki5jb21wLTI5LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0zMC5hei5z
a2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMzEuYXouc2tpbGxzY2xvdWQuY29t
cGFueYIgKi5jb21wLTMyLmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICouY29tcC0z
My5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMzQuYXouc2tpbGxzY2xv
dWQuY29tcGFueYIgKi5jb21wLTM1LmF6LnNraWxsc2Nsb3VkLmNvbXBhbnmCICou
Y29tcC0zNi5hei5za2lsbHNjbG91ZC5jb21wYW55giAqLmNvbXAtMzcuYXouc2tp
bGxzY2xvdWQuY29tcGFueYIgKi5jb21wLTM4LmF6LnNraWxsc2Nsb3VkLmNvbXBh
bnmCICouY29tcC0zOS5hei5za2lsbHNjbG91ZC5jb21wYW55MEwGA1UdIARFMEMw
CAYGZ4EMAQIBMDcGCysGAQQBgt8TAQEBMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly9j
cHMubGV0c2VuY3J5cHQub3JnMIIBAwYKKwYBBAHWeQIEAgSB9ASB8QDvAHYAb1N2
rDHwMRnYmQCkURX/dxUcEdkCwQApBo2yCJo32RMAAAF6bOp/8wAABAMARzBFAiAK
WuAtUmeJ/t1iVkyZJLGXUcvuUUs5wWh4OrAj/j7eOQIhAIyalITwjKY6HKaKwJK5
wSl9CW0ZpOBl/FlphyZaD5eHAHUA9lyUL9F3MCIUVBgIMJRWjuNNExkzv98MLyAL
zE7xZOMAAAF6bOqA7AAABAMARjBEAiALLR8nEhC+aYnnHEwyqtR/Uuj53Bo5Jy/j
xGwl8E+wbQIgQEYdzhUbQ/Bdh8o7NcC0M+WCmz1TBP4a8oaKpJdVwy8wDQYJKoZI
hvcNAQELBQADggEBAAkys71MIfziTAm0W1c/Jo98sw5p5zw9p7VjKx902+/8NSlh
z3KsdTAsnV/8BA2EKc16ngjxnlnjLdNf96945UHZQakf6xD5nIWnZCsVfVag/V9Q
A41VMchWcsX0zaNp4g1Zg6TGxiGCnr+VZTJOc4sJ+VSHZiwwKQIs3KX3nE7DvUDE
NhgZP7Ky8L0tC3Tpd+szs/bWvhrClPEEwserabqAsJ/TGTy6J/KngLQhZa7PNpfd
mGyCjzCYw00lU17PBkPXvO+lvgI9dy6LoYKiP7/1p2Qntl/NPsH1gTVs5aKfTh89
CO9tXqciVRLj4RRLCVht+RHQdP4HjBSP30D6EqE=
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
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDB32SjTGDxgh50
Y2Jck/VoOCNYCfB5qAhURDJHS//ebaPI2uuIO9lkSXTKrPsyNFNIxWznFe35AZ2p
3QIGDpjrSopuDVZzQ0SAj0WrF75Q4rw6v8PtLHwUF9Z2thdYYdnmBKpofsDghVGI
Y8hc5xQydiT1Qnf3yFV8UIcKVhhYNrB4RL/5unGX3XzLy0woIf3sC7I2ePMQ7CmW
oQT52OmGi7CF+Eujl70GPIUWATZTqgMFe4JYHdb0O/y7KhZNhDc3FmSSl2R+3/rJ
zzNWlZ1n/t8lPTTC8nB4Qbl9o8p7E6xy4WdTs5c3Iew7zWF7WBFbNxppjtuaf/RS
9TRcw6HTAgMBAAECggEAO9/SJNyh0/Rrk2ZeKllHoTg1MitfqTLL37pwDLTcAMW7
n3x84UYajW5iM3XY3lhqoD7Ys0WCiTSGjL9EsLoxX/lVZ0eXO2G69jlJOt3KWRCt
MTeoOsdSSqJSCbeS3ijaMr+eIUeEKdMCqyyl5Is5IZx7LYOpqUylmg8EpZyRSCyQ
ysRG8ixNcz2ifJMoY9ujktWrQt9f1d4/R1EVnmip70Bt5yfy6GktGfI1qZB8RRQG
pLcUnLir8nNUrIQTAQsnfGdsd1EZq7bMMo8DBBcUh9HxVLTgj/wBRTxuN/s4aTr0
HNmoziCbDmbzetsODYamhSv48ZAUikFSO1HBe8dqgQKBgQD/nufMLRFnytc/62PR
w1Ozvkpwt+0PJeoPlzGwwqvykiSMt5pNKFCq5zpD1UlDvihafenucp4l0gKotdCm
WprIaIW5wSrwu8NJPWjibP3yCbx4cl0MV+Uwsx9xzrRoH9SGVjox4wnuI6D9g2PD
Sg8rvo4tCgGz2x4VtPip+BGP7QKBgQDCKQiKr+Ho0fGGAYWRk+hNO83Ts27qu3mj
VnM2eSulGLLc4VDqPWbF/WyBQXNFFMtgLCAhtfnQkB7uBw9gGWK/dSFz/cYXHcTD
pL6ukj4ctc3r+jv3yZpJRAzI8WVcojyNOQNrLCRiQjngVEHXJxtP6OwjcAgetmdg
yNa80KZAvwKBgBeH+EyqZWzJlnES6Th5I65rOQ0RUWhQlDBlObTM5ulInMa7bB/o
MyzYZluyObFbwvk5mBxUPsy6fXYsbo2xz4fdX1oPNzW8Aykt1wbpA6ORU+E+neQx
/y4xfxaJ8b+YFodbTrYi8VoTu5E61Cc5HRZoz0vEHQ4CgM18wFtdM7itAoGAHcJm
UcOFj8bmCxEepOKTv4rEEIe3H3leun9cp2PJIcP4XkyWt2Bz6TLft6wNe/Ak//ej
cSdQQ/xjET65x5P8g7XzS7EA9LgWWZpds6ospP/ksR+oo2EeKc6pWv9M9vbS6x5q
/LlGVl0qO80OTmjrEcN0tjXMuNBiZf5Ck6wzX0cCgYAyTLCNZmrezhFL/Qc8UTrN
FCuisr5eKTkRt9hUJUigxDag9FGf1lf+xPCt6aqerKoVodQG8kuMtr2jKwV1OD5p
iHdRhnKlkGi2y/YeNCUc4K/qRIv3ftjcLTP7dfi0nuqU3ESQ+cvom34RcdjeAijs
bk1XRXjZQtg4hBvpGr7VvA==
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
      email: postmaster@comp-01.az.skillscloud.company
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
      rule: Host("app.comp-01.az.skillscloud.company")
      # rule: hostregexp("{.+}")
      entrypoints:
      - http
      middlewares:
      - redirect-to-https
      service: noop@internal
    web-53:
      rule: Host("app.comp-01.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-01:
      rule: Host("westus.comp-01.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-02:
      rule: Host("eastus.comp-01.az.skillscloud.company")
      entrypoints:
      - https
      service: web-53
      tls: {}
    web-53-03:
      rule: Host("southcentralus.comp-01.az.skillscloud.company")
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
          - url: "http://10.1.10.6:8080/"
          - url: "http://10.2.10.6:8080/"
          - url: "http://10.3.10.6:8080/"
        healthCheck:
          path: "/health"
          interval: "1s"
          timeout: "2s"
EOF

docker run -d -p 80:80 -p 443:443 -p 5000:8080  -v "$(pwd)/traefik.yml:/etc/traefik/traefik.yml" -v /var/run/docker.sock:/var/run/docker.sock  -v $(pwd)/dynamic_conf.yml:/etc/traefik/dynamic_conf.yml -v $(pwd)/supercert.pem:/etc/traefik/supercert.pem -v $(pwd)/supercert.key:/etc/traefik/supercert.key --name traefik --network=web53-net traefik:v2.4
