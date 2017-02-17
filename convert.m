function convert

% Copyright (c) 1996 Philipos C. Loizou

global HDRSIZE Srate
global sfHnd hdrHnd cnvFig

pos = get(0, 'screensize');
wi=350; 
he=180;
ypos=(pos(4)-he)/2;
xpos=(pos(3)-wi)/2;

	cnvFig = figure('Units', 'pixels', 'Position', [xpos ypos wi he],...
	'Menubar','none','NumberTitle','off','Name',...
	'文件转换工具');


if isempty(HDRSIZE)
  HDRSIZE=512;
  Srate=20000;
end

%---------------- Define the buttons-----------------------
dp=35; % he/5
top=he-dp-10;
inc=30;
lft=dp;
wit=65;

quest='是否要将文件转换为 .ILS 格式 ?';

uicontrol('Style','Text','String',quest,'Position',[10 top wi-10 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','y');

top=top-inc;
uicontrol('Style','Text','String','文件头大小 (bytes)','Position',[12 top 75 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','r');

hdrHnd=uicontrol('Style','edit','String',int2str(HDRSIZE),'Position',[12+75 top 50 20],...
	'Callback','convtool(''header'')','BackgroundColor',[1 1 1]);

uicontrol('Style','Text','String','采样率 (Hz)','Position',[20+12+2*wit top wit 27],'BackgroundColor',...
	 [0 0 0],'ForeGroundColor','r');

sfHnd=uicontrol('Style','edit','String',int2str(Srate),'Position',[lft+12+3*wit top 50 20],...
	'Callback','convtool(''sfreq'')','BackgroundColor',[1 1 1]);



wit2=wit+15;
lft=round(0.5*(wi-2*wit2-10));
top=top-inc-20;
uicontrol('Style','pushb','String','是','Position',[lft top wit+15 20],...
	'Callback','convtool(''yes'')');

% ----- start now a new column of buttons

lft=lft+wit2+10;

uicontrol('Style','pushb','String','否','Position',[lft top wit+15 20],...
	'Callback','convtool(''no'')');
