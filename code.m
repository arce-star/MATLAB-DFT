%一些问题
%1.数据的单位尚不清楚，具体到我们的实验结果上做一些代码的修正即可
%2.零相位点的对应点并不一定是整数，需要做一个修正，目前得到的方案是通过
%傅里叶变换得到的实部和虚部解出相位偏移
%3.得到的结果图像与标准的黑体辐射光谱图有一些偏差：
%（1）有一些未知原因造成的凹陷和凸起（怀疑是空气成分的吸收导致的）
%（2）短波段会有一些尖峰
%（3）长波段的走向并不是单调递减的
%（4）峰值对应的波长与标准光谱图接近

%step1.预处理
M=readmatrix("D:\文件\创新赛\data\TEK0000.CSV");
%M=csvread("D:\文件\创新赛\data\TEK0002.CSV");
%导入数据
M=M.';
%返回M的非共轭转置
x=M(1,:);
%x表示M的第一行-时间
x=x*0.01;
y=M(2,:);
%y表示M的第二行-强度
%question:光强怎么能是个负值？？？
%因为是光强的交流分量，直流分量与傅里叶变换无关
minlam=100;
maxlam=3000;
%设置波长的上下限单位是nm
l=length(y);
%l表示y向量的长度即数据个数2500个
a=zeros(1,maxlam);
b=zeros(1,maxlam);
ag=zeros(1,maxlam);
bg=zeros(1,maxlam);
%生成四个1x3000全零数组
yy=abs(y);
[maxval,index]=max(yy);
%寻找最大值点对应的是0光程差的采样时间点
%利用索引
%滤除上漂
ss=0;
for m=1:l
    ss=ss+y(m);
end
%for m=(l-499):l
%    ss=ss+y(m);
%end
ss=ss/l;
y=y-ss;

%step2.傅里叶变换
%ss表示y的平均上漂值，共2500个数据
%感觉也可以调整数据量，这个也是随速度改变的
for h=1:maxlam
    k=2*pi/h;
%k是各波长h对应的波数
for i=1:l
    b(i)=2*y(i)*exp(-j*k*(i-index)*5);
    %处理过上漂了所以加一也一样
    %为啥要乘5？是2倍速度，每隔一个采样时间点移动2.5nm
    %应该可以改变扫描速度
end
a(h)=trapz(b);
%求积分，积分间隔是采样点之间的间隔1
end

%step3.图像的显示
subplot(1,2,2)
plot(1:maxlam,abs(a))
%复数的模值
title('光谱图')
xlabel('lamda(nm)')
grid on
%各波长处的强度（光谱）

subplot(1,2,1)
plot(1:l,y)
title('原信号干涉图')
xlabel('采样点数')
grid on
%各采样点的强度

%添加高斯噪声的测试
% yg=imnoise(y,'gaussian',0,0.0001);
% %添加高斯噪声（幅度分布服从高斯分布）
% %同时将原来的灰度图像剪裁只剩正值部分
% for h=1:maxlam
%     k=2*pi/h;
% for i=1:l
%     bg(i)=2*yg(i)*cos(k*(i-index)*5);
%     %数据本身全是正值所以加一后有变化
% end
% ag(h)=trapz(5*bg);
% end
% subplot(2,2,4)
% plot(1:maxlam,ag)
% title('干扰光谱图')
% xlabel('lamda(nm)')
% grid on
% 
% subplot(2,2,3)
% plot(1:l,yg)
% title('干扰原信号干涉图')
% xlabel('采样点数')
% grid on


