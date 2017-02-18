function [filtA,filtB]= filtdesi(type,sfreq,numch,nOrd,debug)

% This function designs different kinds of filters.
%
% Copyright (c) 1995 by Philipos C. Loizou
%

global LowFreq UpperFreq center 

if nargin==5, DBG=1; else DBG=0; end;


FS=sfreq/2;
	
range=log10(UpperFreq/LowFreq);
interval=range/numch;

center=zeros(1,numch);
up=zeros(1,numch);
low=zeros(1,numch);

% ===============================================================
 % ========== Narrowband filters ========
 %窄带滤波器
if strcmp(type,'narrow')
    
    % ----- Figure out the center frequencies for all channels
    %-----计算出所有通道的中心频率
   for i=1:numch  
	up1=LowFreq*10^(interval*i);
	low1=LowFreq*10^(interval*(i-1));
	center(i)=0.5*(up1+low1);
	Q = 2.82*(center(i)/1000)^0.638; % Taken from C. van den Honert, in
				         % 'Cochlear Implants' (J. Miller, F. Spelman eds.), p.122
	BW=center(i)/Q;	
	low(i)=center(i)-BW/2; 
	up(i)=center(i)+BW/2;
   end

   % =============== Broadband filters ======
   %宽带滤波器
elseif strcmp(type,'broad')  

   for i=1:numch  % ----- Figure out the center frequencies for all channels
	up(i) =LowFreq*10^(interval*i);
	low(i)=LowFreq*10^(interval*(i-1));
	center(i)=0.5*(up(i)+low(i));
   end


end
% ===============================================================
% ==================        设计滤波器        ===================
% ===============================================================

if FS<up(numch), 	 useHigh=1;
else			 useHigh=0;
end

filtA=zeros(numch,nOrd+1); 
filtB=zeros(numch,nOrd+1); 

 for i=1:numch
	W1=[low(i)/FS, up(i)/FS];
	if i==numch
	  if useHigh==0
	     [b,a]=butter(nOrd/2,W1);
	  else
	     [b,a]=butter(nOrd,W1(1),'high');
	  end
	else
	   [b,a]=butter(nOrd/2,W1);
	end
	filtB(i,1:nOrd+1)=b;   %----->  保存系数 'b'
	filtA(i,1:nOrd+1)=a;   %-----> 保存系数 'a'

	if  DBG==1
	 [h,f]=freqz(b,a,512,sfreq);
	 semilogx(f,10*log10(abs(h)));
	 axis([90 FS -50 5]);
	 xlabel('频率?(Hz)');
	 ylabel('强度?(dB)');
	 hold on
	end
  end





