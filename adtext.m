function adtext

    % ��ǩ���庯��
    % ��ͼ������ӱ�ǩ

% Copyright (c) 1995 by Philipos C. Loizou
%

global txtc ht fFig

x=get(txtc,'String');

figure(fFig)

ht=gtext(x);
set(ht,'Color','w');

