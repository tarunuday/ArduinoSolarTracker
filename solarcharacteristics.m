clc;
clear;
a = arduino('COM4');
t=1;
distance=5;
while(t<100)
    v1(t)=readVoltage(a, 'A1'); %blue
    i(t)=t;
    z(t)=0;
    f(t)=5;
    t=t+1
end

plot(i,v1,i,z,i,f)

filename=num2str(distance)
save(filename)