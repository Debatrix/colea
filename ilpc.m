function [a,rx] = ilpc(x,p) 
  % #����#
    % LPC����

 E = zeros(p+1,1);	% ��������
 alpha=zeros(p,p);
 

 R = autoc(x,p);        % �������������R��i��
 rx=R;

 E(1)=R(1);		% �ź�x(n)������
 sumaR=0;

% ========= ��ʼ�ݹ� ======== 
 for i=1:p  

   if i>1
     sumaR =alpha(1:i-1,i-1)'* R(i:-1:2)';	
   end
  
   ki=-(R(i+1) + sumaR)/E(i);
   

   if abs(ki) >= 1, fprintf('����! ���ȶ��� LPC ������..\n\n'); end;

   alpha(i,i)=ki;

	     if i>1
        alpha(1:i-1,i)=alpha(1:i-1,i-1)+ki*alpha(i-1:-1:1,i-1);
     end

   E(i+1) = (1 - ki*ki)*E(i);
   
 end  
 % ========= �����ݹ� =========



a = [1; alpha(:,p)];		  % ����Ԥ��ϵ��LPC

%Ep = E(p+1);           % --- residual error -- Ep = R(1) + R(2:p+1)*a 
  



