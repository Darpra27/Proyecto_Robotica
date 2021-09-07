from os import add_dll_directory, truncate
import socket
from _thread import *

server_socket = socket.socket()

host='localhost'
port=10000
ThreadCount = 0

try: 
    server_socket.bind(host,port)

except socket.error as e:
    print(str(e))

print('waiting for connection')
server_socket.listen(2)

def client_thread(connection):
    connection.send(str.encode('welcome to the server'))
    while True:
        data=connection.recv(1024)
        reply='Hello I am server'+data.decode('utf-8')

        if not data:
            break
        
        connection.sendall(str.encode(reply))
    connection.close()

while True:
    client, addr = server_socket.accept()
    print('connected to: '+addr[0]+str(addr[1]))

    start_new_thread(client_thread,(client,))

    ThreadCount+=1
    print('Thread number: '+str(ThreadCount))
server_socket.close()