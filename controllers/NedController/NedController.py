"""NedController controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import Robot
from socket import *
from threading import *
import time

# create the Robot instance.
robot = Robot()

m1 = robot.getDevice('joint_1')
m2 = robot.getDevice('joint_2')
m3 = robot.getDevice('joint_3')
m7 = robot.getDevice('joint_base_to_jaw_1')
m8 = robot.getDevice('joint_base_to_jaw_2')

m1.setPosition(0)
m2.setPosition(0)
m3.setPosition(0)
m7.setPosition(0)
m8.setPosition(0)

def recieve():
    while True:
        data = client_socket.recv(1024).decode('utf-8').split(',')
        #print(data)
        m1.setPosition(float(data[3])/100)
        m2.setPosition(float(data[4])/100)
        m3.setPosition(float(data[5])/100)

# get the time step of the current world.
timestep = int(robot.getBasicTimeStep())
client_socket=socket(AF_INET, SOCK_STREAM)
client_socket.connect(('localhost', 10000))

# You should insert a getDevice-like function in order to get the
# instance of a device of the robot. Something like:
#  motor = robot.getDevice('motorname')
#  ds = robot.getDevice('dsname')
#  ds.enable(timestep)

recvThread = Thread(target=recieve)
recvThread.daemon = True
recvThread.start()

# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
    # Read the sensors:
    # Enter here functions to read sensor data, like:
    #  val = ds.getValue()

    # Process sensor data here.

    # Enter here functions to send actuator commands, like:
    #  motor.setPosition(10.0)
    pass

# Enter here exit cleanup code.
