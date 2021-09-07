from tkinter import *
import socket 
from _thread import *
import time

aux=0

root = Tk()
root.title('Control Brazos Robots')

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(('localhost', 10000))
server_socket.listen(2)

def NewClient():
    print('waiting...')
    while True:
        client, addr = server_socket.accept()
        print('Client connected from', addr)
        start_new_thread(NewNewClient,(client,))

def NewNewClient(client):
    global aux, text
    while True:
        if aux == 1:
            data=[]
            for i in range(6):
                data.append(str(slider[i].get()))
            client.send(bytes(data[0]+','+data[1]+','+data[2]+','+data[3]+','+data[4]+','+data[5],'utf-8'))
            aux=0
        elif aux==2:
            data=[]
            for i in range(6):
                data.append(text[i].get())
            client.send(bytes(data[0]+','+data[1]+','+data[2]+','+data[3]+','+data[4]+','+data[5],'utf-8'))
            aux=0

def enviar():
    global aux
    aux=1

def enviar2():
    global aux
    aux=2

label1=Label(root, text='Brazo Scara').grid(column=0,row=0)

slider=[]
slider.append(Scale(root,from_=-150,to=200, orient=HORIZONTAL, length=400, resolution=10))
slider[0].set(0)
slider[0].grid(column=1,row=1)

text=[]
text.append(Entry(root, width=4))
text[0].grid(column=0,row=1)
text[0].insert(0,'0')

text.append(Entry(root, width=4))
text[1].grid(column=0,row=2)
text[1].insert(0,'0')

text.append(Entry(root, width=4))
text[2].grid(column=0,row=3)
text[2].insert(0,'0')

text.append(Entry(root, width=4))
text[3].grid(column=0,row=5)
text[3].insert(0,'0')

text.append(Entry(root, width=4))
text[4].grid(column=0,row=6)
text[4].insert(0,'0')

text.append(Entry(root, width=4))
text[5].grid(column=0,row=7)
text[5].insert(0,'0')

slider.append(Scale(root,from_=-300,to=150, orient=HORIZONTAL, length=400, resolution=10))
slider[1].set(0)
slider[1].grid(column=1,row=2)

slider.append(Scale(root,from_=0,to=15, orient=HORIZONTAL, length=400, resolution=3))
slider[2].set(0)
slider[2].grid(column=1,row=3)

slider.append(Label(root, text='Brazo Ned').grid(column=0,row=4))
slider[3]=Scale(root,from_=-280,to=280, orient=HORIZONTAL, length=400, resolution=10)
slider[3].set(0)
slider[3].grid(column=1,row=5)

slider.append(Scale(root,from_=-80,to=80, orient=HORIZONTAL, length=400, resolution=10))
slider[4].set(0)
slider[4].grid(column=1,row=6)

slider.append(Scale(root,from_=-150,to=130, orient=HORIZONTAL, length=400, resolution=10))
slider[5].set(0)
slider[5].grid(column=1,row=7)


boton1=Button(root,text='Enviar Sliders',command=enviar).grid(column=1,row=8)
boton2=Button(root,text='Enviar Texto',command=enviar2).grid(column=0,row=8)

start_new_thread(NewClient,())


root.mainloop()