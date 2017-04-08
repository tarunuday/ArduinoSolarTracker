% connect the board
clc;clear;
a = arduino('COM4');
shield = addon(a,'Adafruit/MotorShieldV2');
t=1;
fprintf("Taking readings");
tic
while(t<500)
    v1(t)=readVoltage(a, 'A0'); %blue
    v2(t)=readVoltage(a, 'A1'); %red
    vel=100;
    pos=50;
    e(t)=v1(t)-v2(t);
    d(t)=floor(abs(e(t)*vel));
    p(t)=sign(e(t))*floor(abs(e(t)*pos));
    if e(t)==0
        release(sm2)
    else
        clear sm2;
        sm2 = stepper(shield,2,200,'RPM',d(t),'stepType','Interleave');
        move(sm2,p(t))
    end
    i(t)=t;
    tim(t)=toc;
    z(t)=0;
    t=t+1;
    if mod(t,10)==0
        fprintf('\n');
        fprintf(strcat(num2str(t),' at t=',num2str(tim(t-1)),'s'));
    end
    
end
release(sm2)
fprintf("\n\nDone");
c=clock;
filename=strcat(num2str(pos),"_",num2str(vel),"_",num2str(c(4)),num2str(c(5)),num2str(int8(c(6))),"-",num2str(c(2)),num2str(c(3)),num2str(c(1)));
fprintf(strcat("\nSaved as ",filename));
save(filename);
subplot(2,1,1);
plot(i,v1,'--',i,v2,'--',i,e,'-',i,z,'k')
legend('y = v1','y = v2','Error');
subplot(2,1,2)
plot(i,d,'.-',i,p,'.-',i,z,'k')
legend('d(t)','p(t)');
% close session