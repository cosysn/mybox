import sys
import os
import os.path
import paramiko
import re

local_path = ''
ssh_path = ''
local_file = []
local_folder = []

class ssh:
    hostname=''
    port=22
    username=''
    password=''

    def connect(self):
        self.ssh = paramiko.SSHClient()
        self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        self.ssh.connect(hostname=self.hostname, port=self.port, username=self.username, password=self.password)

        self.transport = paramiko.Transport(self.hostname, self.port)
        self.transport.connect(username=self.username, password=self.password)
        self.sftp = paramiko.SFTPClient.from_transport(self.transport)
        return
    def ssh_is_exist_folder(self,ssh_path):
        stdin,stdout,stderr = self.ssh.exec_command('find ',ssh_path)
        result = stdout.read().decode('utf-8')
        if len(result) == 0:
            return 0
        else:
            return 1
    def update(self):
        self.ssh_create_folder(ssh_path)
        for path in local_folder:
            self.ssh_create_folder(ssh_path+path)
        for f in local_file:
            self.sftp.put(local_path+f,ssh_path+f)

    def ssh_create_folder(self,ssh_path):
        if self.ssh_is_exist_folder(ssh_path)!=0:
            self.ssh.exec_command('mkdir ' + ssh_path)
        return

    def __init__(self,hostname,port,username,password):
        self.hostname=hostname
        #self.port = port
        self.username = username
        self.password = password
        self.connect()
        self.update()
        self.ssh.close()
        self.sftp.close()
        return

    pass
l = len(sys.argv)
if l <= 2:
    exit(0)
local_path = sys.argv[1]
ssh_path = sys.argv[2]
for root,dirs,files in os.walk(local_path):
    for dir in dirs:
        p = os.path.join(root,dir)
        local_folder.append(p.replace(local_path,''))
    for file in files:
        p = os.path.join(root, file)
        local_file.append(p.replace(local_path, ''))

f = open('config.txt')
s = f.readline()
while s:
    s = s.split()
    t = ssh(s[0],s[1],s[2],s[3])
    s = f.readline()
f.close()
