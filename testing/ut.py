from pyats import aetest
import logging
from nested_lookup import nested_lookup
import os
import random

logger = logging.getLogger(__name__)

# define a common setup section by inherting from aetest
class CommonSetup(aetest.CommonSetup):

    @aetest.subsection
    def connect_to_devices(self, testbed, steps):
        for device in testbed.devices:

            with steps.start('Connecting to %s' % device):
                try:
                    testbed.devices[device].connect()                    
                    if device == 'localhost':
                        testbed.devices[device].execute('az login --service-principal -u ' + os.environ.get('AZ_SERVICE_PRINCIPAL') + ' -p ' + os.environ.get('AZ_SERVICE_PRINCIPAL_PASSWORD') + ' --tenant ' + os.environ.get('AZ_TENANT'))
                        testbed.devices[device].execute('export PREFIX='+testbed.devices[device].custom.prefix)
                        print(testbed.devices[device].custom.rg)
                    elif testbed.devices[device].connections.ssh.get('proxy') is not None: 
                        hostname = testbed.devices[device].execute('hostname')
                        if testbed.devices[device].alias not in hostname:
                            aetest.steps.Step.skipped('Device is not reachable over proxy, skipping')                        
                except:
                    aetest.steps.Step.skipped('Connection error, skipping')
  
# define common cleanup after all tests are finished
class CommonCleanup(aetest.CommonCleanup):
    
    @aetest.subsection
    def disconnect_from_devices(self, testbed, steps):
        for device in testbed.devices:
            with steps.start('Disconnecting from %s' % device):
                if device == 'localhost':
                    testbed.devices[device].execute('az logout')
                if testbed.devices[device].connected:
                    testbed.devices[device].disconnect()                                     
                else:
                    aetest.steps.Step.skipped('Device was not connected')

# basic workflow to process each testcase using steps
def process_steps(test_steps, testbed, steps):
    for step in test_steps:
        with steps.start(step['desc']):
            if testbed.devices[step['device']].connected:
                if 'exec_command' in step.keys():
                    var = testbed.devices[step['device']].execute(step['exec_command'])
                if 'assert_value' in step.keys():
                    assert step['assert_value'] in var
                if 'assert_values' in step.keys():
                    for value in step['assert_values']:
                        assert value in var
                if 'assert_not' in step.keys():
                    assert step['assert_not'] not in var
                if 'assert_not_values' in step.keys():
                    for value in step['assert_not_values']: 
                        assert value not in var
                if 'config_command' in step.keys():
                    testbed.devices[step['device']].configure(step['config_command'])
            else:
                aetest.steps.Step.failed('Device was not connected')


def assert_tags(reference_tags, output):
    for tag in reference_tags:
        assert tag in output

#testcase classes which will take data from datafile
class Testcase_A1(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)

class Testcase_A2(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)

class Testcase_A3_1(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)
        
class Testcase_A3_2(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)
        
class Testcase_A3_3(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)

        
class Testcase_A4(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)
        
class Testcase_A5_1(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)

class Testcase_A5_2(aetest.Testcase):
    
    @aetest.setup
    def setup(self):
        aetest.loop.mark(self.test, uids=list(self.tests))
        aetest.skipIf.affix(self.cleanup, self.cleanup_steps is None, 'no cleanup steps specified')

    @aetest.test
    def test(self, testbed, steps, section):
        process_steps(test_steps = self.tests[section.uid], testbed = testbed, steps=steps)
        
    @aetest.cleanup
    def cleanup(self, testbed, steps):
        process_steps(test_steps = self.cleanup_steps, testbed = testbed, steps=steps)