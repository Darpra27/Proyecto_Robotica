"""PruebaServer controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import Robot
from controller import Keyboard
from controller import PositionSensor
from controller import Connector

# create the Robot instance.
robot = Robot()
m1 = robot.getDevice('Eje_1')
m2 = robot.getDevice('Eje_2')
m3 = robot.getDevice('Actuador')

s1 = PositionSensor('Pos_1')
s2 = PositionSensor('Pos_2')
s3 = PositionSensor('Pos_3')

s1.enable(100)
s2.enable(100)
s3.enable(100)

m1.setPosition(0)
m2.setPosition(0)
m3.setPosition(0)

m1.setVelocity(1)
m2.setVelocity(1)
m3.setVelocity(1)

connector = Connector('connector')


# get the time step of the current world.
timestep = int(robot.getBasicTimeStep())

connector.enablePresence(timestep)

# You should insert a getDevice-like function in order to get the
# instance of a device of the robot. Something like:
#  motor = robot.getDevice('motorname')
#  ds = robot.getDevice('dsname')
#  ds.enable(timestep)
aux=1
# Main loop:
while True:
    timestep = int(robot.getBasicTimeStep())
    keyboard = Keyboard()
    keyboard.enable(timestep)
    
    while robot.step(timestep) != -1:
        # Read the sensors:
        # Enter here functions to read sensor data, like:
        #  val = ds.getValue()
        key = keyboard.getKey()

        if key == ord('A'):
            pos=s1.getValue()
            m1.setPosition(pos+0.01)
        
        elif key == ord('S'):
            pos=s1.getValue()
            m1.setPosition(pos-0.01)
            
        elif key == ord('Q'):
            pos=s2.getValue()
            m2.setPosition(pos+0.01)
        
        elif key == ord('W'):
            pos=s2.getValue()
            m2.setPosition(pos-0.01)
            
        elif key == ord('Z'):
            pos=s3.getValue()
            m3.setPosition(pos+0.01)
        
        elif key == ord('X'):
            pos=s3.getValue()
            m3.setPosition(pos-0.01)
            
        elif key == ord('D'):
            m1.setPosition(0)
            m2.setPosition(0)
            m3.setPosition(0)
            
        elif connector.getPresence()==1 and key==ord('E'):
            connector.lock()

        elif key == ord('R'):
            connector.unlock()
            
        # Process sensor data here.
        
        # Enter here functions to send actuator commands, like:
        #  motor.setPosition(10.0)