function rxx = autoc(x,p)
    % #功能#
    % 计算自相关序列R（i）  compute the autocorrelation sequence R(i)
    % function rxx = autoc(x,p)
    % x 加窗后的样本点 
    % p LPC阶数

x=x(:);

N=length(x);

for k=0:p
   
   rxx(k+1)=x(k+1:N)'*x(1:N-k);
   
end




