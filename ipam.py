# -*- coding: utf-8 -*-

#!/usr/bin/env python2
# encoding: utf-8

import json
import argparse
import socket, struct

ipstart = '10.20.0.1'
ipcount = 64

#NOTE: 根据列表顺序获取iprange: 不要删除已有机器, 改变已有机器的顺序.只在后面新增机器
ips = [
'10.17.64.38',
'10.17.64.39',
'10.17.64.40',
]

def get_ansible_inventory(hostgroup,iplist):
    inventory = {}
    if len(iplist):
        iplist = sorted(iplist, key=lambda x: (
            '.'.join(x.split('.')[:3]), int(x.split('.')[-1])))
        inventory.update({hostgroup: {'hosts': iplist}})
    return inventory


def parse_args():
    parser = argparse.ArgumentParser(description='Get ipam Range')
    parser.add_argument(
        '--list',
        action='store_true',
        help='List active servers')
    parser.add_argument(
        '--host',
        action='store',
        type=str,
        help='List details about the specific host')
    parser.add_argument(
        '--dump',
        action='store_true',
        help='Dump config')
    return parser.parse_args()

def get_iprange(host):
    startipint = struct.unpack("!L", socket.inet_aton(ipstart))[0]
    rangeStart = socket.inet_ntoa(struct.pack('!L', startipint + ipcount * ips.index(host)))
    rangeEnd = socket.inet_ntoa(struct.pack('!L', startipint + ipcount * ips.index(host) + ipcount - 1))
    iprange = {'rangeStart': rangeStart, 'rangeEnd': rangeEnd}
    return iprange


if __name__ == '__main__':
    args = parse_args()
    if args.list:
        inventory = get_ansible_inventory('docker_host',ips)
        print(json.dumps(inventory, sort_keys=True, indent=4))
    elif args.host:
        hostvar = get_iprange(args.host)
        print(json.dumps(hostvar))
    elif args.dump:
        for ip in ips:
            iprange = get_iprange(ip)
            print "%-15s rangeStart=%-15s rangeEnd=%-15s" % (ip, iprange['rangeStart'], iprange['rangeEnd'])
