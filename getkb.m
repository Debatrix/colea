function getkb

%输入qQ退出
%global fno

chra=get(gcf,'CurrentCharacter');

%abs(c)

if strcmp(chra,'q') % == 'q' | c == 'Q'

 delete(gcf);
 close all;
 clear all;
 %quitall;
 return;
end

