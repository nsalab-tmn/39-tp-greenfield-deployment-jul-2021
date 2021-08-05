import yaml
import json
import os
import io
import pprint
import collections.abc
from virl2_client import ClientLibrary 
from pyats.easypy import run
from pyats.easypy import Task
from genie import testbed
from yamlinclude import YamlIncludeConstructor

def update_dict(d, u):
    for k, v in u.items():
        if isinstance(v, collections.abc.Mapping):
            d[k] = update_dict(d.get(k, {}), v)
        else:
            d[k] = v
    return d

def setenv(params):
    for p in params:
        os.environ[p.replace("-","_")] = str(params[p])

def main(runtime):
    
    YamlIncludeConstructor.add_to_loader_class(loader_class=yaml.FullLoader, base_dir='./testcases.d')
    
    with open('marking.yaml') as f:
        df = yaml.load(f, Loader=yaml.FullLoader)
    
    with open('params.yaml') as f:
        params = yaml.load(f, Loader=yaml.FullLoader)

    with open('tf-static-params.json') as f:
        tfs = json.load(f)

    with open('tf-dynamic-params.json') as f:
        tfd = json.load(f)

    update_dict(params, tfs)   

    tasks = []
    seq = 0
    for prefix in tfd:
        update_dict(params, tfd[prefix])
        setenv(params)
        tb = testbed.load('testbed.yaml') 
        tasks.append(Task(
            testscript = './ut.py',
            testbed=tb,
            datafile=df,
            runtime = runtime,
            taskid = "Competitor {:02d}".format(seq + 1),
            params = params))
        tasks[seq].start()
        tasks[seq].wait()
        seq += 1

    # tb = testbed.load(os.path.join('./testbed.yaml'))
        
    # for seq in range(1):
    # #for seq in [1]:
    #     prefix = "comp-{:02d}".format(seq + 1)
        
    #     tb.devices['localhost'].custom.rg = 'rg-' + prefix
    #     tb.devices['localhost'].custom.prefix = prefix
    #     tb.devices['cisco-eastus'].connections.ssh.ip = 'eastus.' + prefix + '.az.skillscloud.company'
    #     tb.devices['cisco-westus'].connections.ssh.ip = 'westus.' + prefix + '.az.skillscloud.company'
    #     tb.devices['cisco-southcentralus'].connections.ssh.ip = 'southcentralus.' + prefix + '.az.skillscloud.company'
        
    #     run(testscript = './ut.py', testbed=tb, datafile=yaml.safe_load('./marking.yaml'), taskid = "Competitor {:02d}".format(seq + 1))
    
