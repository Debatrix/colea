function itext(action)

% 添加或删除文本
% Copyright (c) 1995 by Philipos C. Loizou
%

global txtc tf ht fFig 

if strcmp(action,'add')==1

if isempty(tf)
  tf=figure('Units','Pixels','Position',[300 300 200 90],'MenuBar','None','Name',...
	'Text Window','NumberTitle','Off');
	txtc=uicontrol('Style','edit','String','文本','Position',[20 40 160 20],...
	'Callback','adtext');
	uicontrol('Style','Push','String','关闭','Position',[80 10 50 20],...
	'Callback','closem(''tf'')');
else
 figure(tf); 
end

else


h1=findobj(fFig,'Type','text');
i = find(h1 == ht);

  if  i == 1
    delete(ht);
  else
    disp('错误! 没有待删除的文本.');
  end

end




