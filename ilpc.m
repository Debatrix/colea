function [a,rx] = ilpc(x,p) 
  % #功能#
    % LPC分析

 E = zeros(p+1,1);	% 能量向量
 alpha=zeros(p,p);
 

 R = autoc(x,p);        % 计算自相关序列R（i）
 rx=R;

 E(1)=R(1);		% 信号x(n)的能量
 sumaR=0;

% ========= 开始递归 ======== 
 for i=1:p  

   if i>1
     sumaR =alpha(1:i-1,i-1)'* R(i:-1:2)';	
   end
  
   ki=-(R(i+1) + sumaR)/E(i);
   

   if abs(ki) >= 1, fprintf('警告! 不稳定的 LPC 过滤器..\n\n'); end;

   alpha(i,i)=ki;

	     if i>1
        alpha(1:i-1,i)=alpha(1:i-1,i-1)+ki*alpha(i-1:-1:1,i-1);
     end

   E(i+1) = (1 - ki*ki)*E(i);
   
 end  
 % ========= 结束递归 =========



a = [1; alpha(:,p)];		  % 线性预测系数LPC

%Ep = E(p+1);           % --- residual error -- Ep = R(1) + R(2:p+1)*a 
  



