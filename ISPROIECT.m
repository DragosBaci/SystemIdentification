close all
%%citire si plotare date
data = load("baci.mat");

t = double(data.baci.X.Data)';
u = double(data.baci.Y(1,3).Data)'; 
w = double(data.baci.Y(1,2).Data)';
th = double(data.baci.Y(1,1).Data)';

u_filt = median_filt(u,1);
w_filt = median_filt(w,1);

figure
plot(t, [u_filt*200, th, w_filt]), grid, shg, hold on


i3 = 5504;
i4 = 5788;


ust = mean(u_filt(i3:i4));
wst = mean(w_filt(i3:i4));

K = wst / ust;

w63 = 0.63*wst;

plot(t,w63.*(ones(1,length(t))));

i5 = 5245;
i6 = 5295;

Tm = t(i6) - t(i5);

i7 = 5353;
T = t(i7) - t(i6); 


Hw = tf(K, [T  1], 'IODelay', Tm);

A = -1/T;
B = K/T;
C = 1;
D = 0;

sys = ss(A,B,C,D);
u_nou = [u_filt(1)*ones(i6-i5,1); u_filt(1:length(u_filt)-(i6-i5))];

wsim = lsim(sys , u_nou ,t ,w_filt(1));
figure
plot(t, [ wsim, w_filt]), grid, shg ,legend('viteza simulata','viteza')

%validare
eMPN = norm(w_filt-wsim)/norm(w_filt-mean(w_filt))

%% viteza - pozitie

i8 = 5436;
i9 = 5829;

K_theta = (th(i9)-th(i8))/(mean(w(i8:i9))*(t(i9)-t(i8)));

A1 = [-1/T 0;
        K_theta 0];
B1 = [K/T; 0];
C1 = [1 0 ; 0 1];
D1 = [0;0];

sys1 = ss(A1,B1,C1,D1);
ylsim2 = lsim(sys1 , u,t,[w(1),th(1)]);
figure
plot(t,ylsim2(:,2),t,th), title("Suprapunerea intre viteza obtinuta integrata peste pozitie")
legend('pozitie','pozitie simulata')
eMPN2 = norm(th-ylsim2(:,2))/norm(th-mean(th))

%% metode parametrice de identificare

i10=2662;
i11=4482;
i12=5894;
i13=7902;

N= 4;

ti=t(i10:N:i11); %timpul identificare
ui=u(i10:N:i11); %intrarea
wi=w(i10:N:i11); %viteza
thi=th(i10:N:i11); %pozitia

tv=t(i12:N:i13); %timpul validare
uv=u(i12:N:i13); %intrarea
wv=w(i12:N:i13); %viteza
thv=th(i12:N:i13); %pozitia

Te = 4*(t(7)-t(6));
iddata_id = iddata(double(thi),double(wi),Te);
iddata_vd = iddata(double(thv),double(wv),Te);
%% viteza pozitie
arx1 = arx(iddata_id, [1 1 0]);
figure
compare(arx1,iddata_vd)
figure
resid(iddata_vd,arx1)

Harx1 = tf(arx1.B,arx1.A,Te,'variable','z^-1')
Harx1c =tf(4.9618,[1 0])

A12 = 0;
B12 = 4.9618;
C12 = 1;
D12 = 0;

ysim12 = lsim(A12,B12,C12,D12,w,t,th(1));
plot(t,ysim12,t,th),legend('pozitie','pozitie simulata ARX')
eMPN12 = norm(th - ysim12)/(norm(th-mean(th)))

%%
oe1 = oe(iddata_id,[1 1 0]);
figure
compare(oe1,iddata_vd)
figure
resid(iddata_vd,oe1)

Hoe1 = tf(oe1.B,oe1.F,Te,'variable','z^-1')
Hoe1c = tf(4.941,[1 0])

A13 = 0;
B13 = 4.941;
C13 = 1;
D13 = 0;
ysim13 = lsim(A13,B13,C13,D13,w,t,th(1))
plot(t,ysim13,t,th),legend('pozitie','pozitie simulata OE')
eMPN13 = norm(th - ysim13)/(norm(th-mean(th)))
%%
iddata_id2 = iddata(double(wi),double(ui),Te);
iddata_vd2 = iddata(double(wv),double(uv),Te);

arx3 = arx(iddata_id2, [1 1 1]);
figure
compare(arx3,iddata_vd2)

figure
resid(iddata_vd2,arx3)
Harx2 = tf(arx3.B,arx3.A,Te,'variable','z^-1')
Harx2c = d2c(Harx2,'zoh')

Kw = 4511/19.12;
Tw = 1/19.12;
Aw = -1/Tw;
Bw = Kw/Tw;
Cw = 1;
Dw = 0;
ylsim3 = lsim(Aw,Bw,Cw,Dw,u_nou,t,w(1)); 
plot(t,w,t,ylsim3),grid on, legend("viteza","viteza simulata ARX"), ylabel("Rad/s"), xlabel("Timp")

eMPN3 = norm(w-ylsim3)/norm(w-mean(w))
%%
oe3 = oe(iddata_id2,[1 1 1]);
figure
compare(oe3,iddata_vd2)
figure
resid(iddata_vd2,oe3)
Hoe3 = tf(oe3.B,oe3.F,Te,'variable','z^-1')
Hoe3c = d2c(Hoe3,'zoh')

Kw1 = 4511/19.12;
Tw1 = 1/19.12;
Aw1 = -1/Tw1;
Bw1 = Kw1/Tw1;
Cw1 = 1;
Dw1 = 0;

ylsim4 = lsim(Aw1,Bw1,Cw1,Dw1,u_nou,t,w(1));
plot(t,w,t,ylsim4)
eMPN4 = norm(w-ylsim4)/norm(w-mean(w)),grid on, legend("viteza","viteza simulata OE"), ylabel("Rad/s"), ...
xlabel("Timp")
