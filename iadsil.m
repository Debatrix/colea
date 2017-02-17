function iadsil

% Copyright (c) 1995 by Philipos C. Loizou
%

global  adsFig adsOp


pos = get(0, 'screensize'); % get the screensize
sWi = pos(3);
sHe = pos(4);
xpos=(sWi-200)/2;
ypos=(sHe-80)/2;


if isempty(adsFig)
  adsFig=figure('Units','Pixels','Position',[xpos ypos 200 80],'MenuBar','None','Name',...
	'添加静音段','NumberTitle','Off');
	adsOp=uicontrol('Style','edit','String','100','Position',[70 20 60 20],...
	'Callback','editool(''addsil'')');
	txt='输入静音段长度（毫秒））:';
	uicontrol('Style','Text','String',txt,'Position',[10 50 160 20],...
	'BackgroundColor',[0 0 0],'ForeGroundColor','y');
else
 figure(adsFig); 
end

