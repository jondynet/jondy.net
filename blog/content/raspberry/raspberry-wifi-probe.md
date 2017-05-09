Title: ��ݮ����wifi̽��
Date: 2017-04-12 16:04
Category: Raspberry
Tags: wifi raspberry
Slug: raspberry-wifi-probe
Authors: zhangdi
Summary: ʹ����ݮ����wifi̽��ʼ�

*wifi̽��*ֻ���豸��������������������Ҫ����wifi����̽����豸��mac��ַ���ź�ǿ�ȡ�
�����˾Ҫ��һ��*wifi̽��*��Ʒ�����������߸��ǵ�Ӧ�á�

*wifi̽��*���������ӣ�֮ǰ������ݮ��2���İ����ϲ�usb��������ʵ�ֹ���
�����ֵ���ݮ��3�����Ӽ�����wifi��ͬʱҲԤ���˺��̿ɺ������ߵ�����

����ݮ������*wifi̽��*��Ϊ�˲�Ʒ��������ʾ���㣬���ղ�Ʒ����ֲ��OpenWRTƽ̨�İ����ϡ�

��ݮ��3���İ�����������Ĭ���ǲ�֧��monitorģʽ�ģ����ȵô򲹶�֧��monitorģʽ��

�����Զ���������

�޸� /etc/rc.local

exit 0 ǰ����
������
insmod /root/brcmfmac.ko
������

*wifi̽��*ʵ�ֵĹ��ܣ���ȡ�ܱ��ֻ����豸��mac��ַ���ź�ǿ���ϱ����ƶˣ�
���ȸ���ճ�����ϵ�N��ʵ��wifi̽���python�ű�����Ч��������ʹ�õ���scapy�����ģ�
ʵ�ʲ����ź�ǿ���ǲ��Եģ�ʱ���ϵûȥ�о�����ԭ��ʹ����pcap�İ汾���Ի�ȡ����Ҫ�����ݡ�

�޸Ĵ��ϱ����ܺ�python���룺

������
#coding:utf-8
# by zhangdi <h4ck@163.com>
import os
import random
import pcapy
import time
import json
import zlib
import socket
import binascii
from multiprocessing import Process
from impacket import ImpactDecoder, dot11

MYMAC		 = open('/sys/class/net/eth0/address').read().strip().lower()
INTERFACE    = 'wlan0'
MAX_LEN      = 1514    # max size of packet to capture
PROMISCUOUS  = 1       # promiscuous mode?
READ_TIMEOUT = 300     # in milliseconds

RTD = ImpactDecoder.RadioTapDecoder()

UDP_IP = '192.168.88.234'
UDP_PORT = 12345
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP

clients = {'mac': MYMAC, 'clients':[]}
latest = time.time()

# Channel hopper
def channel_hopper():
    while True:
		channel = random.randrange(1,14)
		cmd = "iw dev wlan0 set channel %d" % channel
		#print cmd
		try:
			os.system(cmd)
			time.sleep(1)
		except KeyboardInterrupt:
			break

def getBssid(arr):
	#Get Binary array to MAC addr format
	out = []
	s = binascii.hexlify(arr)
	t = iter(s)
	st = ':'.join(a+b for a,b in zip(t,t))
	return st

def pcapy_packet(header, data):
	global clients, latest
	radio_packet = RTD.decode(data)
	_signal = radio_packet.get_dBm_ant_signal()
	channel = radio_packet.get_channel()[0]
	if _signal:
		signal = _signal and -(256-_signal) or -120
	pkt = radio_packet.child()
  
	if pkt.get_type() == dot11.Dot11Types.DOT11_TYPE_MANAGEMENT:
		base = pkt.child().child()
		if base.__class__ != dot11.Dot11ManagementProbeRequest: return
		bssid_base = pkt.child()
		#try: ssid = str(base.get_ssid())
		#except: ssid = ''
		bssid = getBssid(bssid_base.get_source_address())
		clients['clients'].append({'mac':bssid, 'channel': channel, 'signal':signal})
		if (time.time() - latest) > 3:
			latest = time.time()
			print clients
			sock.sendto(zlib.compress(json.dumps(clients)), (UDP_IP, UDP_PORT))
			clients['clients'] = []

#if __name__ == "__main__":
p = Process(target = channel_hopper)
p.start()

c = pcapy.open_live('wlan0', MAX_LEN, PROMISCUOUS, READ_TIMEOUT)
try:
	c.loop(-1, pcapy_packet)
except SystemError:
	print clients
������

�����ڼ䷢��ż��������������������2A�ĵ�Դ������������3̨�ڼ����칫�����ڼ�������������

���䣺�����������������Զ��л��ŵ����ں����γɲ�Ʒ��C���԰汾ʱ���ֱ��ŵ�����Ҫ��������ǹ㲥����