function rxx = autoc(x,p)
    % #����#
    % �������������R��i��  compute the autocorrelation sequence R(i)
    % function rxx = autoc(x,p)
    % x �Ӵ���������� 
    % p LPC����

x=x(:);

N=length(x);

for k=0:p
   
   rxx(k+1)=x(k+1:N)'*x(1:N-k);
   
end




