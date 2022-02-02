## Test project description

SkillsCloud Company is the leader in the market for API development for SCADA systems data analysis. In 2021, in order to reduce capital expenditures for maintaining its own IT infrastructure, the company is implementing a pilot project to switch to the infrastructure as a service (IaaS) model and is testing the deployment of its software products on the Microsoft Azure public cloud infrastructure. For this purpose, company is searching candidates who will be able to support this project.

As part of practical skills assessment, candidates will be asked to provide a fault-tolerant infrastructure for the functioning of a specialized web application in several regions where the main company's customer is located.

At the border of the global and private networks of each region, a specialized virtual traffic management platform has been deployed. In the private network of each region, there is a virtual platform for application hosting.

![](topology.png)

### Technical requirements

#### Application and its dependencies

- to complete the task, you need to deploy the web-53 application (version v21.08.03), the distribution kit is available at https://test-web53.s3.eu-central-1.amazonaws.com/21.08.03/web-53
- each local application instance must be connected to a local Redis database

#### Common requirements

- from external systems point of view, this web application should be available through a single entry point - https://app.prefix.az.skillscloud.company (where prefix is the individual identifier of the candidate);
- in the failure event of one (or several) application instances (including failure of one or more regions or availability zones), the downtime of access to the application should not exceed 10 seconds;
- all incoming connection requests to the application from WAN must only be accepted using secure application layer protocols.

#### Border traffic management platforms should:

- provide full access to the global Internet for the corresponding regional private subnet;
- provide access to the appropriate regional instance of the web application for any external systems;
- provide full network connectivity between regional private subnets.

#### Application hosting platforms should:

- ensure proper operation of the application and of all its functional dependencies;
- redirect incoming requests via an insecure application layer protocol to the   main entry point address;
- distribute incoming requests among other regional application instances in case the local application instance is faulty (returns HTTP code 5XX);
- implement the necessary mechanisms to automatically restart the local application instance in case of its failure.

### Web-53 application manual 

#### Command line parameters

To display application help use command `./web-53 -h`:
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

All parameters are optional. By default, the application uses `config.yaml` as its configuration file. If this file is present in the launch directory, you can launch the application with the command `./web-53` or `./web-53 -c custom-config.yaml` to launch with the configuration file `custom-config.yaml`. You can generate a default configuration file with the `./web-53 -s` command.

#### Configuration

Default configuration file contains following parameters:

```
# Application hosting region
# This parameter is not used for the task
AWS:
  Region: eu-central-1

# HTTP server configuration
# This is mandatory parameter to run the application instance
Server:
  Host: 0.0.0.0
  Port: 8080

# DynamoDB connection parameters
# This parameter is not used for the task
DynamoDB:
  Region: eu-central-1
  TableName: test-web-53
  PrimaryPartitionKey: recordId

# Redis connection parameters
# This parameter is needed for the task
Redis:
  Host: 172.18.0.2
  Port: 6379

# MySQL connection parameters
# This parameter is not used for the task
DB:
  Host: database-1.c2empzdo10xn.eu-central-1.rds.amazonaws.com
  Port: 3306
  User: admin
  Pass: Aa123456
  DBName: db01
  Table: testweb53
```

#### Evaluation of application status
You can check the status of connections, according to the specified parameters, on the `/status` page:

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

#### Evaluation of application health
The `/health` page displays the health status. In the `true` state, the indicator returns the HTTP code `200`.

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

This indicator should be used by load balancers to avoid sending requests to instances whose health indicator is in the `false` state (returns HTTP code `500`).

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

## Scenario 1: Greenfield deployment

In this basic scenario, candidates will get access to the Microsoft Azure cloud infrastructure management portal, where in the respective regions, within an isolated resource group, all the necessary basic elements are created - subnets, network interfaces, DNS zones, Bastion hosts, and virtual machines:

- a specialized virtual platform for network traffic management is deployed at the border of the global and private networks of each region;
- in the private network of each region - a virtual platform for application hosting.

Using these resources, candidates need to bring the state of the infrastructure in full compliance with the technical requirements.

### Assessment specification

This scenario is evaluating skills for selecting appropriate set of software components to implement solution in accordance with the technical requirements and ensuring the operation of the system in the following states:

Normal state - checks for basic availability conditions, including:

- Providing access to external systems (8%)
- Inter-regional connectivity (17%)
- Availability of the web application (22%)

Emergency state - checks for availability conditions in cases of redundant components disruption, including:

- inter-regional network fault tolerance (20%)
- Web application fault tolerance (33%)

## Scenario 2: Brownfield audit and troubleshooting

In this scenario, candidates will get access to an isolated resource group that contains a preconfigured infrastructure instance. This infrastructure contains a number of faults that prevent the whole system from proper functioning in accordance with the technical requirements.

Using the available audit tools, candidates need to audit the current infrastructure state, as well as bring infrastructure state in full compliance with the technical requirements by eliminating the faults found.

### Examples of audit information questions

#### Audit of traffic management platforms

- Specify operating system version for gw-region-01
- Specify policy number of Internet Security Association Key Management for gw-region-03
- Specify autonomous system number of interior dynamic routing protocol used on gw-region-01
- Specify profile name for tunnel protection between gw-region-02 and gw-region-03, used on gw-region-02
- Specify IPv4 subnet address подсети in tunnel between gw-region-02 and gw-region-03
- Specify current access role name (view) for azadmin user on gw-region-01

#### Audit of application hosting platforms

- Specify operating system kernel version  for platform-region-01
- Specify containerization system version for platform-region-01
- Specify number of transit hosts from platform-region-02 to 1.1.1.1
- Specify path web-53 executable file, which accepts requests on platform-region-03

#### Audit of application and its main dependencies

- Specify version of web-53 executable file, which accepts requests on platform-region-03
- Specify reverse proxy packet version for platform-region-02
- Specify port number of caching database which is running on platform-region-02
- Specify subnet address which is used by the application and all its dependecies on platform-region-01
- Specify serial number of security certificate which is used for application entry point

### Assessment specification

This scenario is evaluating skills for working with common operating systems audit tools, as well as the skills of working with brownfield deployments to implement required solution in accordance with the technical requirements. The assessment is made on the following domains:

Infrastructure state analysis - verification of audit results, including:

- Audit of traffic management platforms (20%)
- Audit of application hosting platforms (13%)
- Audit of application and its main dependencies (16%)

Troubleshooting - verification of availability conditions when redundant components are failed, including:

- Inter-regional network fault tolerance (15%)
- Web application fault tolerance (35%)

## Scenario 3: Deployment and base audit automation

In this scenario, candidates will get access to the base code repository, which contains proposed basic file structure as well as a description of the input and output data. Based on this information, candidates need to solve task of automating the application deployment and all its main components, as well as run automatic collection of basic information about the platforms on which the application is hosted.

To test their solution, candidates will have access to a sandboxed resource group that contains the "clear" VMs for application hosting. This scenario does not require programmatic interaction with traffic management platforms - it is assumed that these platforms are configured and working, thus being “transparent” to candidates.

To complete this scenario, applicants must register their code repository, which contains all the necessary elements to deploy the application in accordance with the technical requirements.

Link for base code repository: https://github.com/nsalab-tmn/39-tp-deployment-automation-base-aug-2021

### Assessment specification

This scenario is evaluating skills for using automation and configuration management tools to deploy the application in accordance with the technical requirements.

The assessment is done on a "clear" infrastructure instance by running an application deployment script from a repository provided by a candidate. After the completion of the automation script, the evaluation is performed on the following domains:

- Web application availability (27%)
- Web application fault tolerance (21%)
- Audit of application hosting platforms (51%)

### Description of base code repository

This repository is a base example for solving the Test Project for "Deployment and base audit automation" scenario.
This example uses the basic framework for managing configurations with Ansible, but usage of Ansible is not required since assessment will be done using functional criteria.

#### Repository structure

`run.sh` — is an entry point for automatic assessment pipeline and implements the automatic configuration deployment and audit information gathering:

```
# Specifying the interpreter for an executable file
#!/bin/bash

# Inventory output including necessary debugging information
ansible-inventory --graph --yaml --vars

# Checking the availability of all devices
ansible -m ping all 

# Running Ansible playbook to deploy configuration
ansible-playbook deploy.yaml

# Running an Ansible playbook to collect audit information
ansible-playbook audit.yaml
```
`inventory.yaml` — contains an enumeration of hosts where configuration is managed. In this example, within the `all` group, one single host `platform_region_01` is specified

```
all: 
  hosts:
    platform_region_01:
```

`group_vars` is a directory containing variable files for groups of devices specified in `inventory` file.

`group_vars/all.yaml` is a variable file for the `all` inventory group. This example describes connection variables for Linux operating system. Note that the account is specified by the `adminuser` and `password` environment variables.

```
####  CONNECTION SPECIFIC ####
ansible_connection: ssh
ansible_become: no
ansible_network_os: linux

ansible_user: "{{ lookup('env','adminuser') }}"
ansible_ssh_pass: "{{ lookup('env','password') }}"
ansible_port: 22

####  CONFIGURATION SPECIFIC ####
```

`host_vars` is a directory containing variable files for each host specified in  `inventory` file

`host_vars\platform_region_01.yaml` is a file of unique variables for the host `platform_region_01`. This example specifies a single unique variable, `ansible_host`, containing the IP address (or FQDN) to connect to the host. Note that the IP address is specified by the `platform_01_public_ip` environment variable.

```
####  CONNECTION SPECIFIC ####
ansible_host: "{{ lookup('env','platform_01_public_ip') }}"
```

`deploy.yaml` - contains an example Ansible playbook script for configuration management. In this example, the `kickstart.sh` file is copied to each host in the `all` group and then executed remotely.

```
- name: Execute kickstart script
  hosts: all
  gather_facts: false
  tasks:
    - name: Copy script
      ansible.builtin.copy:
        src: ./kickstart.sh
        dest: /home/azadmin/kickstart.sh
        mode: u=rwx,g=r,o=r
    - name: Run script
      ansible.builtin.shell: /home/azadmin/kickstart.sh
```

`kickstart.sh` is an example script for remote execution on target hosts.

```
#!/bin/bash
sudo echo 'Hello World!' > /home/azadmin/hello.txt
```

`audit.yaml` - contains an example Ansible playbook script for collecting basic audit information on each target host. In this example, for all hosts in the `all` group, the following happens:
  - `gather_facts: true` - basic information is collected
  - `Render report template` - a jinja2 template in YAML format is copied to each host, into which information from ansible-facts is substituted
  - `Fetch rendered reports` - a local `output` folder is created, into which the report is copied from each host
  
```
- name: Get audit information
  hosts: all
  gather_facts: true
  tasks:
    - name: Render report template
      ansible.builtin.template:
        src: template.tpl
        dest: "{{inventory_hostname}}.yaml"
    - name: Fetch rendered reports
      ansible.builtin.fetch:
        src: "{{inventory_hostname}}.yaml"
        dest: "./output/"
        flat: yes
```

`template.tpl` is a jinja2 template for gathering basic information about target hosts. In this example, the IPv4 address of the target host is substituted into the template.

```
IP_address: {{hostvars[inventory_hostname]['ansible_facts']['default_ipv4']['address']}}
```

`requirements.txt` - contains all the dependencies that are necessary for the successful execution of the script. By default, it contains the minimum required set of pip3 packages for running Ansible and checking reports using PyYAML

`ansible.cfg` is a local Ansible configuration file where you can override Ansible configuration options as needed.

#### Example of preparing a runtime for an automatic assessment pipeline

```
# The repository is downloaded to the local machine from the link registered by the candidate
- git clone {CloneURL} repo-{prefix}
- cd repo-{prefix}

# A python3 virtual environment is created with all the dependencies specified by the candidate in the requirements.txt file
- python3 -m venv venv-{prefix}          
- source venv-{prefix}/bin/activate
- pip3 install -r requirements.txt

# Output directory is deleted (if any)
- rm -rf output

# All required environment variables are assigned
- export adminuser={adminuser}
- export password={password}
- export prefix={prefix}
- export platform_01_public_ip={platform-01-public-ip}
...

# The run.sh script is launched
- ./run.sh > run.log
- cat run.log
```

After the execution of the `run.sh` script is finished, a series of functional availability checks and web application fault tolerance are performed in accordance with the technical requirements, as well as audit results are checked against reference values.

#### WARNING
**Connection to all hosts for assessment is done using dynamic variables randomly generated when the clear infrastructure instance is deployed. Infrastructure instance provided to candidates for testing their solution WILL BE DESTROYED before assessment and then recreated. Accordingly, all dynamic variables will be regenerated - do not hardcode in your script dynamic variables values provided to you - use environment variables, according to the examples described above.**

#### Format for audit report files

After the `run.sh` script finishes running, an `output` directory should be created in the local directory, which should contain the log files for each target host. The name of each file must be in the format `hostname_XX.yaml`, for example `platform_region_01.yaml`.

Each report file must contain the following information:

- Distribution: name and version of OS distribution
- Kernel: OS kernel version
- vCPUs: number of virtual processors
- RAM_MB: amount of RAM in megabytes
- Boot_image: path to OS boot file
- Python3: python3 interpreter version

An example audit report file:

```
Distribution: Ubuntu 16.04
Kernel: 3.1.4-88-repack-by-canonical
vCPUs: 1
RAM_MB: 666
Boot_image: /boot/vmlinus-torvalds-3.1.4-88-repack-by-canonical
Python3: 3.2.28
```
