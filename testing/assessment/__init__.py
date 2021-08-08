from pyats import aetest
import dns.resolver 
import ipaddress
import httpx
from time import sleep
import logging
logger = logging.getLogger(__name__)

def validate_web_response(testbed, device, action_vars, params): 
    try:
        verify = 'assert_cert' in action_vars.keys() and action_vars['assert_cert']
        client = httpx.Client(verify = verify)             
        query_params = httpx.QueryParams() 
        method = 'GET'
        content = None
        if 'query_params' in action_vars.keys():
            qp = kv_to_dict(action_vars['query_params'], params)
            query_params = query_params.merge(qp)
        if 'method' in action_vars.keys():
            method = action_vars['method']
        if 'content' in action_vars.keys():
            content = action_vars['content']
        
        request = httpx.Request(method = method,
            url = action_vars['name'].format_map(params),
            content = content,
            params = query_params)        
        if 'headers' in action_vars.keys():
            h = kv_to_dict(action_vars['headers'], params)
            request.headers.update(h)
        
        response = client.send(request)

        if 'assert_code' in action_vars.keys():
            assert response.status_code == action_vars['assert_code']
        if 'assert_code_range' in action_vars.keys():
            assert response.status_code >= action_vars['assert_code_range']['min']
            assert response.status_code <= action_vars['assert_code_range']['max']
        if 'assert_redirect' in action_vars.keys() and action_vars['assert_redirect']:
            assert len(response.history) > 0
        if 'assert_content' in action_vars.keys():
            for content in action_vars['assert_content']:
                assert content in response.text
        if 'assert_json' in action_vars.keys():
            j = response.json()
            for seq in range(len(action_vars['assert_json'])):
                values = []
                generator = item_generator(j, action_vars['assert_json'][seq]['key'])
                for v in generator:
                    values.append(v)
                assert action_vars['assert_json'][seq]['value'] in values
    except Exception as e:
        logger.info("Exception occured:" + str(e))
        aetest.steps.Step.failed('Validation failed. Expected: ' + str(action_vars))

def go_sleep(testbed, device, action_vars, params):
    logger.info("Going to sleep for " + str(action_vars['seconds'].format_map(params)) + " seconds")
    sleep(int(action_vars['seconds'].format_map(params)))

def kv_to_dict(kvdict, params): 
    d = {}
    for seq in kvdict: 
        d[str(seq['key']).format_map(params)] = str(seq['value']).format_map(params) 
        #append({str(kvdict[seq]['key']).format_map(params): str(kvdict[seq]['value']).format_map(params)}) 
    return d 

def item_generator(json_input, lookup_key):
    if isinstance(json_input, dict):
        for k, v in json_input.items():
            if k == lookup_key:
                yield v
            else:
                yield from item_generator(v, lookup_key)
    elif isinstance(json_input, list):
        for item in json_input:
            yield from item_generator(item, lookup_key)            
    
def validate_dns_record(testbed, device, action_vars, params):
    resolver = dns.resolver.Resolver()
    try:
        nameservers = nslookup(action_vars['name'].format_map(params))
        resolver.nameservers = ntoa(nameservers)
        answer = resolver.resolve(action_vars['name'].format_map(params), action_vars['record_type'])
        assert len(answer.response.answer[0]) >= action_vars['min_records']
        for seq in range(action_vars['min_records']):
            assert ipaddress.ip_address(str(answer.rrset[seq])).is_private == action_vars['is_private']
    except Exception as e:
        logger.info("Exception occured:" + str(e))
        aetest.steps.Step.failed('Validation failed. Expected: ' + str(action_vars))

def nslookup(domain):
    result = []
    name = dns.name.from_text(domain)
    answer = dns.resolver.resolve(name, 'NS', raise_on_no_answer=False)
    if answer.rrset is not None:
        for set in answer.rrset:
            result.append(str(set))      
        return result
    else:    
        return nslookup(str(name.parent()))

def ntoa(names):
    try:
        addr = []
        for seq in range(len(names)): 
            answer = dns.resolver.resolve(names[seq]) 
            addr.append(str(answer.rrset[0])) 
    except Exception as e:
        logger.info("Exception occured:" + e.msg)
    finally:
        return addr

def set_params(testbed, device, action_vars, params): 
    for var in action_vars:
        params[var['key']] = var['value']
    return params

def find_interface(testbed, device, action_vars, params): 
    command = "show ip route " + action_vars['network'].format_map(params) + " | include \*"
    result = testbed.devices[device].execute(command)
    if result is not None:        
        params[action_vars['param']] = result.split(' via ').pop()
    return params

def verify_output(testbed, device, action_vars, params):    
    result = testbed.devices[device].execute(action_vars['command'].format_map(params))
    assert_tags(action_vars['assert_tags'], result, action_vars['tags_are_present'])

def config(testbed, device, action_vars, params):
    for seq in range(len(action_vars['commands'])): 
	    action_vars['commands'][seq] = action_vars['commands'][seq].format_map(params) 
    result = testbed.devices[device].configure(action_vars['commands'])
    return result

def assert_tags(reference_tags, output, present):
    if present:
        for tag in reference_tags:
            assert tag in output
    else:
        for tag in reference_tags:
            assert tag not in output
    return True