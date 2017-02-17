function specsel

% 閹貉冨煑缁愭ぞ缍嬮崙鑺ユ殶
% 鐠佸墽鐤哃PC/FFT
% Copyright (c) 1995 Philipos C. Loizou
%

global SpcUp LPCSpec S0

x = get(SpcUp,'Value');

if (x > 1)

 if     (x==2) LPCSpec=1;
   else        LPCSpec=0;
  end

pllpc(S0)

end