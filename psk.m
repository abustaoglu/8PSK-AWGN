clc;
clear all;
close all;
m=8; k=log2(m); %8psk mod
nums=10^5; numb=nums*k;%%1sembol for three bit
tb=100;
t3=0.0001:0.0001:0.01;
A=1;
snr_db=0:10;
Es=1;
E=1/k; %%bit energy
snr=10.^(snr_db./10);
cos_part=0;
sin_part=0;
for n=1:length(snr_db)
    ber_temp=0;
    ber_temp0=0;
for j=1:1:nums %%three bit for each symbol
    logic1=randi([0, 1], [1, 1]); %getting random 0's and 1's
    logic2=randi([0, 1], [1, 1]); %getting random 0's and 1's
    logic3=randi([0, 1], [1, 1]); %getting random 0's and 1's
    %i(t)=sqrt(2*E/Ts)*(cos2*pi*fc*t+(k*2*pi/8))
    if(logic1==0&&logic2==0&&logic3==0)%generate 9 different carrier(gray coding)
        cos_part=cos(0);
        sin_part=-sin(0);
    elseif(logic1==0&&logic2==0&&logic3==1)%second carrier
        cos_part=cos(1*2*pi/m);
        sin_part=sin(1*2*pi/m);
    elseif(logic1==0&&logic2==1&&logic3==1)%third carrier
        cos_part=cos(2*2*pi/m);
        sin_part=sin(2*2*pi/m);
    elseif(logic1==0&&logic2==1&&logic3==0)%fourth carrier
        cos_part=cos(3*2*pi/m);
        sin_part=sin(3*2*pi/m);
    elseif(logic1==1&&logic2==1&&logic3==0)%fifth carrier
        cos_part=cos(4*2*pi/m);
        sin_part=sin(4*2*pi/m);
    elseif(logic1==1&&logic2==1&&logic3==1)%sixth carrier
        cos_part=cos(5*2*pi/m);
        sin_part=sin(5*2*pi/m);
    elseif(logic1==1&&logic2==0&&logic3==1)%seventh carrier
        cos_part=cos(6*2*pi/m);
        sin_part=sin(6*2*pi/m);
    else(logic1==1&&logic2==0&&logic3==0)% eight carrier
        cos_part=cos(7*2*pi/m);
        sin_part=sin(7*2*pi/m);
    end
    aa=sqrt(E/(2*snr(n)));
    cos_noise=aa*randn(1); %random noise
    sin_noise=aa*randn(1);
    %%received angle
    rs=mod(atan2d(sin_noise+sin_part,cos_noise+cos_part)+360,360);%four-quadrant inverse tangent
    %demodulation 8psk modulated signal
    if((rs>=0&&rs<=22.5) || (rs>337.25)) 
        logic_1=0;
        logic_2=0;
        logic_3=0;
    elseif(rs>22.5&&rs<=67.5)
        logic_1=0;
        logic_2=0;
        logic_3=1;
    elseif(rs>67.5&&rs<=112.5)
        logic_1=0;
        logic_2=1;
        logic_3=1;    
    elseif(rs>(112.5)&&rs<=(157.5))
        logic_1=0;
        logic_2=1;
        logic_3=0;    
   elseif(rs>(157.5)&&rs<=(202.5))
        logic_1=1;
        logic_2=1;
        logic_3=0;       
    elseif(rs>(202.5)&&rs<=(247.5))
        logic_1=1;
        logic_2=1;
        logic_3=1;      
     elseif(rs>(247.5)&&rs<=(292.5))
        logic_1=1;
        logic_2=0;
        logic_3=1;   
     elseif(rs>(292.5)&&rs<=(337.5))
        logic_1=1;
        logic_2=0;
        logic_3=0;      
    end
  %ber calcuation for bits
    if(logic1~=logic_1)
        ber_temp=ber_temp+1;
    end
    if(logic2~=logic_2)
        ber_temp=ber_temp+1;
    end
    if(logic3~=logic_3)
       ber_temp=ber_temp+1;
    end
    %%ber calc for symbols
     if(logic1==logic_1 && logic2==logic_2 && logic3==logic_3)
        ber_temp0=ber_temp0+0;
     else
         ber_temp0=ber_temp0+1;
     end
   
end

err0(n)=(ber_temp0/nums);
err(n)=(ber_temp/numb);  %calc err manually
end
   %theoric err
   for p=1:1:length(snr_db)
    %ph=erfc(square(E/N)*sin(pi/m)) 
   ph=E*erfc(sqrt((10.^(snr_db/10))*k)*sin(pi/(m)));
   end
   er=[];
M_8=8;
BER_8=berawgn(snr_db,'psk',M_8,'nondiff');%%another way to find theriocal ber
%%**start plotting
semilogy(snr_db,err,'*');grid on;xlabel('snr_db');ylabel('biter');
hold
semilogy(snr_db,ph,'r-');grid on;legend('simulation','theorical');title('Ber for 8PSK');hold;
