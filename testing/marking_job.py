  
import os
from pyats.easypy import run
from genie import testbed
import yaml


def main(runtime):
    runtime.mailbot.mailto = ['agorbachev']
    tb = testbed.load(os.path.join('./testbed.yaml'))
    
    
    for seq in range(1):
    #for seq in [1]:
        prefix = "comp-{:02d}".format(seq + 1)
        
        tb.devices['localhost'].custom.rg = 'rg-' + prefix
        tb.devices['localhost'].custom.prefix = prefix
        tb.devices['cisco-eastus'].connections.ssh.ip = 'eastus.' + prefix + '.az.skillscloud.company'
        tb.devices['cisco-westus'].connections.ssh.ip = 'westus.' + prefix + '.az.skillscloud.company'
        tb.devices['cisco-southcentralus'].connections.ssh.ip = 'southcentralus.' + prefix + '.az.skillscloud.company'
        
        run(testscript = './ut.py', testbed=tb, datafile=yaml.safe_load('./marking.yaml'), taskid = "Competitor {:02d}".format(seq + 1))
    
