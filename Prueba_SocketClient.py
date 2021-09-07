import socket
client_socket=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client_socket.connect(('localhost', 10000))
payload='Hey Server'

try:
    while True:
        client_socket.send(payload.encode('utf-8'))
        data=client_socket.recv(1024)
        print('dice: '+str(data))
        more=input('Want to send more data to the server')
        if more.lower() == 'y':
            payload=input('Enter the data')
        else:
            break

except KeyboardInterrupt:
    print('Exited by user')

client_socket.close()