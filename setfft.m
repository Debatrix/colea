function setfft

%控制窗体函数
%设置fft大小
% Copyright (c) 1995 Philipos C. Loizou
%

global ctFFT FFT_SET pFFT S0 fftSize

x = get(ctFFT,'Value');

 if x==2 
   FFT_SET=0;
   fftSize=512;
 elseif (x > 2 )
   pFFT = 2^(x+3);
   FFT_SET=1;
 
  pllpc(S0);

 end





